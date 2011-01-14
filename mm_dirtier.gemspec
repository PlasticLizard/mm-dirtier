# encoding: UTF-8
require File.expand_path('../lib/mm_dirtier/version', __FILE__)

Gem::Specification.new do |s|
  s.name = 'mm_dirtier'
  s.homepage = 'http://github.com/PlasticLizard/mm_dirtier'
  s.summary = 'Even dirtier dirty tracking for MongoMapper'
  s.require_path = 'lib'
  s.authors = ['Nathan Stults']
  s.email = ['hereiam@sonic.net']
  s.version = MongoMapper::Dirtier::Version
  s.platform = Gem::Platform::RUBY
  s.files = Dir.glob("{lib,mongo_mapper,test}/**/*") + %w[LICENSE README.rdoc]

  s.add_dependency  'observables', '~> 0.1.3'

  s.add_development_dependency 'rake'
  s.add_development_dependency 'log_buddy'
  s.add_development_dependency 'jnunemaker-matchy', '~> 0.4.0'
  s.add_development_dependency 'shoulda',           '~> 2.11'
end

