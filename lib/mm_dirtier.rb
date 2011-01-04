require 'rubygems'
require "mongo_mapper"
require "observables"

base_dir = File.dirname(__FILE__)
[
 'version',
 'many_embedded_proxy_listener',
 'in_array_proxy_listener',
 'one_embedded_proxy_listener',
 'extensions',
 'plugins/dirtier',
 'support'
].each {|req| require File.join(base_dir,'mm_dirtier',req)}


MongoMapper::Document.append_inclusions(MmDirtier::Plugins::Dirtier)
MongoMapper::EmbeddedDocument.append_inclusions(MmDirtier::Plugins::Dirtier)
