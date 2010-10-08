# encoding: UTF-8
#require "observables"
module MongoMapper
  module Plugins
    module Dirtier
      def self.configure(model)
        model.class_eval do
          plugin MongoMapper::Plugins::Dirty unless plugins.include?(MongoMapper::Plugins::Dirty)
        end
      end

      module InstanceMethods

        private

        def write_key(key, value)
          old_value = read_key(key)
          old_value.clear_observer if old_value && old_value.observable?
          observe_if_observable(key, value) if value
          super(key,value)
        end

        def observe_if_observable(key, value)
          key = key.to_s
          if value.observable? || value.can_be_observable?

            value.make_observable unless value.observable?
            previous_values = nil
            value.set_observer do |_,change_type,args|
              if change_type.to_s =~ /before/
                previous_values = attribute_was(key).dup
                attribute_will_change!(key) unless attribute_changed?(key)
              else
                changed_attributes.delete(key) unless value_changed?(key,previous_values,args.current_values)
              end

            end
          end
        end
      end
    end
  end
end
