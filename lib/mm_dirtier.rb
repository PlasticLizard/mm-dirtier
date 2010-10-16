require 'rubygems'
require "mongo_mapper"
require "observables"

base_dir = File.dirname(__FILE__)
[
 'version',
 'many_embedded_proxy_listener',
 'in_array_proxy_listener',
 'extensions'
].each {|req| require File.join(base_dir,'mm_dirtier',req)}

require File.join(base_dir,"mongo_mapper","plugins","dirtier")

MongoMapper::Document.append_inclusions(MongoMapper::Plugins::Dirtier)
MongoMapper::EmbeddedDocument.append_inclusions(MongoMapper::Plugins::Dirtier)
