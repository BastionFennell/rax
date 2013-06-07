require "spec_helper"

describe "using the loadbalancer api" do
  context "with credentials present" do
    Given(:home) {Pathname(set_env "HOME",File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "   login #{ENV['RACKSPACE_LOGIN'] || '<rackspace-username>'}"
        f.puts "   password #{ENV['RACKSPACE_API_TOKEN'] || '<rackspace-api-token>'}"
      end
    end


    context "when I list all my loadbalancers (and I don't have any)" do
      When {VCR.use_cassette('loadbalancer/show-loadbalancers') {run "rax show loadbalancers"}}
      Then {all_stdout =~ /you don't have any loadbalancers/}
      And {last_exit_status.should eql 0}
    end

    context "when I create a loadbalancer" do
      When {VCR.use_cassette('loadbalancer/create-loadbalancer') {run "rax create loadbalancer with node at address 198.61.221.219"}}
      Then {all_stdout =~ /created loadbalancer (\w+)/}
      And {last_exit_status.should eql 0}
    end

    context "when I show a loadbalancer" do
      When {VCR.use_cassette('loadbalancer/show-loadbalancer') {run "rax show loadbalancer divine-reef"}}
      Then {last_exit_status.should eql 0}
    end

    context "when I destroy a loadbalancer that exists" do
      When {VCR.use_cassette('loadbalancer/destroy-loadbalancer') {run "rax destroy loadbalancer divine-reef"}}
      Then {all_stdout =~ /destruction/}
      And {last_exit_status.should eql 0}
    end
  end
end
