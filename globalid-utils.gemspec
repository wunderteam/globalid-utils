$LOAD_PATH.unshift(File.expand_path('../lib', __FILE__))

require 'global_id_utils/version'

Gem::Specification.new do |s|
  s.name        = 'globalid-utils'
  s.version     = GlobalIdUtils::VERSION
  s.license     = 'MIT'
  s.authors     = ['Bryan Dragon']
  s.email       = ['dragon@wundercapital.com']
  s.homepage    = 'https://github.com/wunderteam/globalid-utils'
  s.summary     = 'Utilities for customizing and validating GlobalIDs'
  s.description = 'Utilities for customizing and validating GlobalIDs'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ['lib']

  s.required_ruby_version = ">= #{IO.read(File.expand_path('../.ruby-version', __FILE__)).chomp}"

  s.add_dependency 'activemodel',    '~> 5.2.6'
  s.add_dependency 'activesupport',  '~> 5.2.6'
  s.add_dependency 'globalid',       '~> 0.4.2'
  s.add_dependency 'railties',       '~> 5.2.6'

  s.add_development_dependency 'rake',  '12.3.3'
  s.add_development_dependency 'rspec', '3.6.0'
  s.add_development_dependency 'pry',   '~> 0.12'
  s.add_development_dependency 'rspec_junit_formatter',    '~> 0.3.0'
end
