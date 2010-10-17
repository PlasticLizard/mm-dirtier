# encoding: UTF-8
module MongoMapper
  module Plugins
    module Dirtier

      def self.included(model)
        model.plugin MongoMapper::Plugins::Dirtier
      end

      def self.configure(model)
        model.plugin MongoMapper::Plugins::Dirty unless
          model.plugins.include?(MongoMapper::Plugins::Dirty)
      end

      module InstanceMethods

        protected

        def attribute_method?(attr)
          #Since associations are storing their changes in the models
          # normal dirty tracking system, then association names are
          # valid attributes as far as dirty is concerned
          super || !!associations.keys.detect { |a| a.to_s == attr.to_s }
        end

        private

        def get_proxy(association)
          #I can't imagine why, but super.tap{...} is causing errors here.
          #Proxy meta monkey wierdness, no doubt.
          proxy = super
          key_name = proxy_key_name(proxy)
          unless association.observable?
            observe_if_observable(key_name,proxy)
          end
          return proxy
        end

        def proxy_key_name(proxy)
          proxy.options[:in] ? proxy.options[:in] : proxy.association.name
        end

        def write_key(key, value)
          old_value = read_key(key)
          old_value.clear_observer if old_value && old_value.observable?
          observe_if_observable(key, value) if value
          super(key,value)
        end

        def value_changed?(key_name, old, value)
          value = nil if keys[key_name] && keys[key_name].number? && value.blank?
          old != value
        end


        def observe_if_observable(key, value)
          key = key.to_s

          if value.observable? || value.can_be_observable?

            value.make_observable unless value.observable?
            previous_values = nil
            value.set_observer do |_,change_type,args|
              if change_type.to_s =~ /before/
                previous_values = attribute_was(key)
                #previous_values = previous_values.nil? ? nil : previous_values.dup
                previous_values = dup_if_required(previous_values)
                attribute_will_change!(key) unless attribute_changed?(key)
              else
                changed_attributes.delete(key) unless value_changed?(key,previous_values,args.current_values)
              end
            end
          end
        end

        def dup_if_required(val)
          val.nil? || val.respond_to?(:_id) ? val : val.dup
        end

      end
    end
  end
end
