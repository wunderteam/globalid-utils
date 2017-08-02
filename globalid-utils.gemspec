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

  s.required_ruby_version = '>= 2.3.0'

  s.add_dependency 'activemodel',    ['>= 4.2.6', '< 6.0']
  s.add_dependency 'activesupport',  ['>= 4.2.6', '< 6.0']
  s.add_dependency 'globalid',       '~> 0.4.0'
  s.add_dependency 'railties',       ['>= 4.2.6', '< 6.0']

  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec', '~> 3.4.0'
end
