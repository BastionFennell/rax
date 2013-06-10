require "spec_helper"

describe "using the container api" do
  context "with credentials present" do
    Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "   login #{ENV['RACKSPACE_LOGIN'] || '<rackspace-username>'}"
        f.puts "   password #{ENV['RACKSPACE_API_TOKEN'] || '<rackspace-api-token>'}"
      end
    end

    context "when I list all my containers (and I don't have any)" do
      When {VCR.use_cassette('containers/show-containers') {run "rax show containers"}}
      Then {all_stdout =~ /you don't have any containers/}
      And {last_exit_status.should eql 0}
    end

    context "when I create a container" do
      When {VCR.use_cassette('containers/create-server') {run "rax create container"}}
      Then {all_stdout =~ /created container (\w+)/}
      And {last_exit_status.should eql 0}
    end

    context "when I show a container" do
      When {VCR.use_cassette('container/show-container') {run "rax show container divine-reef"}}
      Then {last_exit_status.should eql 0}
    end

    context "when destroy a container that exists" do
      When {VCR.use_cassette('container/destroy-container') {run "rax destroy container divine-reef"}}
      Then {all_stdout =~ /destruction/}
      And {last_exit_status.should eql 0}
    end
  end
end
