# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'snapdeal_api/version'

Gem::Specification.new do |spec|
  spec.name          = "snapdeal_api"
  spec.version       = SnapdealApi::VERSION
  spec.authors       = ["Girish Nair"]
  spec.email         = ["girish@girishn.com"]

  spec.summary       = %q{Pull data from snapdeal.com affiliate APIs}
  spec.description   = %q{This gem provides a simple utility class to pull data from snapdeal.com using Snapdeal's affiliate APIs}
  spec.homepage      = "https://rubygems.org/gems/snapdeal_api"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"

  spec.add_dependency('rest-client', '1.7.2')
  spec.add_dependency('nokogiri', '1.6.6.2')
  spec.add_dependency('json', '1.8.1')
end
