class ServersController < MVCLI::Controller
  requires :compute
  requires :naming

  def index
    compute.servers.all
  end

  def show
    #What if you have two or more servers with the same name?
    server
  end

  def create
    #Add personalization
    options = {
      name: naming.generate_name(nil, nil),
      flavor_id: 2,
      image_id: '9922a7c7-5a42-4a56-bc6a-93f857ae2346',
      private_key_path: "~/.ssh/id_rsa",
      public_key_path: "~/.ssh/id_rsa.pub"
    }
    p "Initializing creation of #{options[:name]}"
    #Progress bar
    test = compute.servers.bootstrap options
    p "Creation complete!"
    test
  end

  def destroy
    server.tap do |s|
      s.destroy
    end
  end

  def deploy
    require 'net/ssh'

    verbose = true

    Net::SSH.start(server.ipv4_address, 'root') do|ssh|
      ssh_run ssh, 'apt-get -y update', verbose
      ssh_run ssh, 'apt-get -y install curl git-core', verbose
      ssh_run ssh, 'apt-get -y install software-properties-common', verbose

      #Nginx
      #ssh_run ssh, 'add-apt-repository ppa:nginx/stable', verbose
      #ssh_run ssh, 'apt-get -y update', verbose
      #ssh_run ssh, 'apt-get -y install nginx', verbose
      #ssh_run ssh, 'service nginx start', verbose

      #Ruby
      ssh_run ssh, 'curl -Ls get.rvm.io | bash -s stable', verbose
      ssh_run ssh, 'rvm install 2.0.0-p195', verbose
      ssh_run ssh, 'rvm --default use 2.0.0-p195', verbose

      #Rails
      ssh_run ssh, 'gem install rails', verbose

      #MySQL
      ssh_run 'apt-get install -y mysql-client libmysqlclient-dev'


      #Nginx Set Up
      #ssh_run ssh, 'rm /etc/nginx/sites-enabled/default', verbose

      #conf_path = "/etc/nginx/sites-available/my_app.conf"
      #ssh_run ssh, "(
      #echo upstream my_app {
      #echo server unix:///var/run/my_app.sock;
      #echo }
      #echo:
      #echo server {
      #echo listen 80;
      #echo #{server.name} http://#{server.ipv4_address};
      #echo root /var/www/my_app/public;
      #echo:
      #echo location / {
      #echo proxy_pass http://my_app;
      #echo proxy_set_header Host $host;
      #echo proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
      #echo }
      #echo }
      #) > #{conf_path}", verbose

      #ssh_run ssh, 'ln -sf /etc/nginx/sites-available/my_app.conf /etc/nginx/sites-enabled/my_app.conf', verbose
      #ssh_run ssh, 'service nginx restart', verbose

      #Set up for deploy
      repo = params[:repo]
      #repo = `git remote -v`

      f = File.new("config/deploy.rb", 'w')
      f.puts("require 'puma/capistrano'")
      f.puts("require 'bundler/capistrano'")
      f.puts("server #{server.ipv4_address} , :web, :app, :db, primary: true")
      f.puts('set :application, "my_app"')
      f.puts("set :scm, 'git'")
      f.puts("set :repository, #{repo}")
      f.puts("set :branch, 'master'")
      f.puts("default_run_options[:pty] = true")
      f.puts("ssh_options[:forward_agent] = true")
      f.puts("after 'deploy', 'puma:start'")
      f.puts("after 'deploy:restart', 'deploy:cleanup'")
      f.close

      f = File.new("Capfile")
      f.puts("load 'deploy'")
      f.puts("load 'deploy/assets'")
      f.puts("load 'config/deploy'")
      f.close

      #Deploy
      `bundle exec cap deploy:cold`
      `bundle exec cap deploy`

    end
  end

  private

  def server
    index.find {|s| s.name == params[:id]} or fail Fog::Errors::NotFound
  end

  def generate_name
    'divine-reef'
  end

  def ssh
    test = server
    ip_address = test.ipv4_address
    exec "ssh root@#{ip_address} -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -q"
  end

  def ssh_run ssh, command, verbose
    puts "\nExecuting #{command}"

    stdout_data = ""
    stderr_data = ""
    exit_code = nil
    exit_signal = nil
    ssh.open_channel do |channel|
      channel.exec(command) do |ch, success|
        unless success
          abort "FAILED: couldn't execute command (ssh.channel.exec)"
        end
        channel.on_data do |ch,data|
          stdout_data+=data
        end

        channel.on_extended_data do |ch,type,data|
          stderr_data+=data
        end

        channel.on_request("exit-status") do |ch,data|
          exit_code = data.read_long
        end

        channel.on_request("exit-signal") do |ch, data|
          exit_signal = data.read_long
        end
      end
    end
    ssh.loop

    if exit_code != 0
      puts("exit code #{exit_code}")
      puts("error:")
      puts(stderr_data)
      puts "error in command #{command}"
      exit(1)
    end

    puts stdout_data if verbose
    puts "Finished executing #{command}"
  end
end
