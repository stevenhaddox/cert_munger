# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'cert_munger/version'

Gem::Specification.new do |spec|
  spec.name          = "cert_munger"
  spec.version       = CertMunger::VERSION
  spec.authors       = ["Steven Haddox"]
  spec.email         = ["steven.haddox@gmail.com"]
  spec.summary       = %q{Reformat commonly malformatted X509 strings.}
  spec.description   = %q{A gem that takes string input for X509 certificates and attempts to reformat them into a valid certificate.}
  spec.homepage      = "https://github.com/stevenhaddox/cert_munger"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.0.0'
  spec.add_dependency 'logging', '~> 2.1'

  spec.add_development_dependency 'awesome_print', '~> 1.2'
  spec.add_development_dependency 'bundler', '~> 1.6'
  spec.add_development_dependency 'codeclimate-test-reporter'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'rack', '~> 1.5'
  spec.add_development_dependency 'rack-test', '~> 0.6'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.48'
  spec.add_development_dependency 'rspec', '~> 3.1'
  spec.add_development_dependency 'yard', '~> 0.8'

  spec.cert_chain  = ['certs/stevenhaddox.pem']
  spec.signing_key = File.expand_path("~/.gem/certs/gem-private_key.pem") if $0 =~ /gem\z/
end
