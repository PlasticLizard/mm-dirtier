module MongoMapper
  module Plugins
    module DirtierEmbeddedDocument

      def self.included(model)
        model.plugin(MongoMapper::Plugins::DirtierEmbeddedDocument)
      end

      def self.configure(model)
        model.plugin(MongoMapper::Plugins::Dirtier)
      end

      module InstanceMethods
        def persist
          super
          try_change { true }
          embedded_associations.each do |association|
            proxy = get_proxy(association)
            proxy.save_to_collection({}) if proxy.proxy_respond_to?(:save_to_collection)
          end
        end
      end
    end

  end
end



