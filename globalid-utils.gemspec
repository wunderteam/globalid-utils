$LOAD_PATH.unshift(File.expand_path('lib', __dir__))

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

  s.required_ruby_version = ">= #{IO.read(File.expand_path('.ruby-version', __dir__)).chomp}"

  s.add_dependency 'activemodel',    '>= 6', '< 8'
  s.add_dependency 'activesupport',  '>= 6', '< 8'
  s.add_dependency 'globalid',       '>= 1.0.1', '< 1.1.0'
  s.add_dependency 'railties',       '>= 6', '< 8'

  s.add_development_dependency 'pry',   '~> 0.14.2'
  s.add_development_dependency 'rake',  '13.0.6'
  s.add_development_dependency 'rspec', '3.12.0'
  s.add_development_dependency 'rspec_junit_formatter', '~> 0.6.0'
end
