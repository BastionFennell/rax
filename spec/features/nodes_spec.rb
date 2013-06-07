require "spec_helper"

describe "using the node api" do
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
    context "when I list all my nodes on a loadbalancer (and I don't have any)" do
      When {VCR.use_cassette('node/show-nodes') {run "rax show nodes on loadbalancer divine-reef"}}
      Then {all_stdout =~ /you don't have any nodes/}
      And {last_exit_status.should eql 0}
    end

    context "when I create a node on a loadbalancer" do
      When {VCR.use_cassette('node/create-node') {run "rax create node on loadbalancer divine-reef at address 198.61.221.220"}}
      Then {all_stdout =~ /created node (\w+)/}
      And {last_exit_status.should eql 0}
    end

    context "when I show a node on a loadbalancer" do
      When {VCR.use_cassette('node/show-node') {run "rax show node 198.61.221.220 on loadbalancer divine-reef"}}
      Then {last_exit_status.should eql 0}
    end

    context "when I destroy a node on a loadbalancer" do
      When {VCR.use_cassette('node/destroy-node') {run "rax destroy node 198.61.221.219 on loadbalancer divine-reef"}}
      Then {all_stdout =~ /destruction/}
      And {last_exit_status.should eql 0}
    end
  end
end
