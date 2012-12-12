# -*- encoding: utf-8 -*-
require File.expand_path('../lib/mailercity/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Rob Forman"]
  gem.email         = ["rob@robforman.com"]
  gem.description   = %q{Ruby bindings for Mailercity API}
  gem.summary       = %q{Mailercity is a central email repository and sending service.}
  gem.homepage      = "https://github.com/robforman/mailercity-ruby"

  gem.add_dependency('faraday')
  gem.add_development_dependency('rake')
  gem.add_development_dependency('rspec')
  gem.add_development_dependency('webmock')

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "mailercity"
  gem.require_paths = ["lib"]
  gem.version       = Mailercity::VERSION
end
