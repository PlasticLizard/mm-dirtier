# encoding: UTF-8
require File.expand_path('../lib/mm_dirtier/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'mm_dirtier'
  s.homepage = 'http://github.com/PlasticLizard/mm_dirtier'
  s.summary = 'Even dirtier dirty tracking for MongoMapper'
  s.require_path = 'lib'
  #s.default_executable = ''
  s.authors = ['Nathan Stults']
  s.email = ['hereiam@sonic.net']
  #s.executables = ['']
  s.version = MongoMapper::Dirtier::Version
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("{lib,mongo_mapper,test}/**/*") + %w[LICENSE README.rdoc]

 s.add_dependency  'observables', '~> 0.1.1'
  #s.add_dependency 'activemodel',             '~> 3.0.0'
  #s.add_dependency 'activesupport',           '~> 3.0.0'
  #s.add_dependency 'plucky',                  '~> 0.3.5'

  s.add_development_dependency 'rake'
  #s.add_development_dependency 'tzinfo'
  #s.add_development_dependency 'json'
  s.add_development_dependency 'log_buddy'
  s.add_development_dependency 'jnunemaker-matchy', '~> 0.4.0'
  s.add_development_dependency 'shoulda',           '~> 2.11'
  #s.add_development_dependency 'timecop',           '~> 0.3.1'
  #s.add_development_dependency 'mocha',
end

