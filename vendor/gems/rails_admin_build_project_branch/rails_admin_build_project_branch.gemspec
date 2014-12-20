$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "rails_admin_build_project_branch/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "rails_admin_build_project_branch"
  s.version     = RailsAdminBuildProjectBranch::VERSION
  s.authors     = ["stricte"]
  s.email       = ["stricte@softica.pl"]
  s.homepage    = "http://softica.pl"
  s.summary     = "RailsAdminBuildProjectBranch."
  s.description = "Description of RailsAdminBuildProjectBranch."
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "rails", "~> 4.1.6"
end
