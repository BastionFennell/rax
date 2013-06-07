require "spec_helper"

describe "using the instances api" do
  context "with credentials present" do
    Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "   login #{ENV['RACKSPACE_LOGIN'] || '<rackspace-api-token>'}"
        f.puts "   password #{ENV['RACKSPACE_API_TOKEN'] ||'<rackspace-api-token>'}"
      end
    end

    context "when I list all my instances (and I don't have any)" do
      When {VCR.use_cassette('instance/show-instances') {run "rax show instances"}}
      Then {all_stdout =~ /you don't have any instances/}
      And {last_exit_status.should eql 0}
    end

    context "when I create an instance" do
      When {VCR.use_cassette('instance/create-instance') {run "rax create instance"}}
      Then {all_stdout =~ /created instance (\w+)/}
      And {last_exit_status.should eql 0}
    end

    context "when I show an instance" do
      When {VCR.use_cassette('instance/show-instance') {run "rax show instance divine-reef"}}
      Then {last_exit_status.should eql 0}
    end

    context "when I destroy an instance that exists" do
      When {VCR.use_cassette('instance/destroy-instance') {run "rax destroy instance divine-reef"}}
      Then {all_stdout =~ /destruction/}
      And {last_exit_status.should eql 0}
    end
  end
end
