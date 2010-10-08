require 'rubygems'
require "mongo_mapper"
require "observables"

base_dir = File.dirname(__FILE__)
[
  'version'
].each {|req| require File.join(base_dir,'mm_dirtier',req)}

require File.join(base_dir,"mongo_mapper","plugins","dirtier")