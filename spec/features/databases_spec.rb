require "spec_helper"

describe "using the database api" do
  context "with credentials present" do
    Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "   login #{ENV['RACKSPACE_LOGIN'] || '<rackspace-username>'}"
        f.puts "   password #{ENV['RACKSPACE_API_TOKEN'] || '<rackspace-username>'}"
      end
    end

    context "when I list all my databases on an instance(and I don't have any)" do
      When {VCR.use_cassette('database/show-databases') {run "rax show databases on instance divine-reef"}}
      Then {all_stdout =~ /you don't have any databases/}
      And {last_exit_status.should eql 0}
    end

    context "when I create a database on an instance" do
      When {VCR.use_cassette('database/create-database') {run "rax create database on instance divine-reef"}}
      Then {all_stdout =~ /created instance/}
      And {last_exit_status.should eql 0}
    end

    context "when I show a database on an instance" do
      When {VCR.use_cassette('database/show-database') {run "rax show database divine-reef on instance divine-reef"}}
      Then {last_exit_status.should eql 0}
    end

    context "when I destroy a database on an instance" do
      When {VCR.use_cassette('database/destroy-database') {run "rax destroy database divine-reef on instance divine-reef"}}
      Then {all_stdout =~ /destruction/}
      And {last_exit_status.should eql 0}
    end
  end
end
