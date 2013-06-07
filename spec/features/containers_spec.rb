require "spec_helper"

describe "using the container api" do
  context "with credentials present" do
    Given(:home) {Pathname(set_env "HOME", File.expand_path(current_dir))}
    Given do
      File.open(home.join('.netrc'), "w") do |f|
        f.chmod 0600
        f.puts "machine api.rackspace.com"
        f.puts "   login #{ENV['RACKSPACE_LOGIN'] || '<rackspace-api-token>'}"
      end
    end

    context "when I list all my (and I don't have any)" do

    end
  end
end
