# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'scripter/version'

Gem::Specification.new do |spec|
  spec.name          = "scripter"
  spec.version       = Scripter::VERSION
  spec.authors       = ["Artūrs Mekšs"]
  spec.email         = ["arturs.mekss@gmail.com"]
  spec.summary       = %q{Library for reducing of boilerplate in ruby scripts with possibility to run fault tolerant iterations}
  spec.description   = %q{Library for reducing of boilerplate in ruby scripts with possibility to run fault tolerant iterations, for example mass notifications, or support scripts}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'timecop', '~> 0.7.1'

  spec.add_dependency 'activesupport', '>= 2'
end
