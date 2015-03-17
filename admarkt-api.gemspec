# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'admarkt/api/version'

Gem::Specification.new do |spec|
  spec.name          = "admarkt-api"
  spec.version       = Admarkt::Api::VERSION
  spec.authors       = ["Tsyren Ochirov"]
  spec.email         = ["nsu1team@gmail.com"]
  spec.summary       = %q{A Ruby wrapper for the Admarkt Sellside API http://ecg-icas.github.io/icas/doc/prod/index.html}
  spec.description   = %q{A Ruby wrapper for the Admarkt Sellside API http://ecg-icas.github.io/icas/doc/prod/index.html}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency 'oauth2'
  spec.add_dependency 'virtus'
  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
  spec.add_development_dependency "webmock"
end
