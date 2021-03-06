$:.push File.expand_path("lib", __dir__)

# Maintain your gem's version:
require "ez_crud/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.name        = "ez_crud"
  spec.version     = EzCrud::VERSION
  spec.authors     = [""]
  spec.email       = ["tofarr@gmail.com"]
  spec.homepage    = "http://ez-crud.com"
  spec.summary     = "Gem for easing the process of creating crud operations"
  spec.description = "Gem for easing the process of creating crud operations"
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise "RubyGems 2.0 or newer is required to protect against " \
      "public gem pushes."
  end

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 5.2.3"
  spec.add_dependency "bcrypt", "~> 3.1"
  spec.add_dependency "activestorage-validator", "~> 0.1.2"
  spec.add_dependency "jquery-rails", "~> 4.3"
  spec.add_dependency "select2-rails", "~> 4.0"
  spec.add_dependency "flatpickr_rails", "~> 1.1"
  spec.add_dependency "data_uri", "~> 0.1.0"
  spec.add_dependency "mime-types", "~> 3.2"

  spec.add_development_dependency "sqlite3"
end
