# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'mailsafe/version'

Gem::Specification.new do |spec|
  spec.name          = "mailsafe"
  spec.version       = Mailsafe::VERSION
  spec.authors       = ["Simon Stemplinger"]
  spec.email         = ["simon@simon-stemplinger.com"]
  spec.description   = 'Safe emailing for Rails'
  spec.summary       = 'Safe emailing for Rails - do not send emails to real users from development or staging environments.'
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
