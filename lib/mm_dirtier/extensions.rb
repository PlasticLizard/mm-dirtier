module MongoMapper
  module Plugins
    module Associations
      #By default, proxies should not be observable
      class Proxy
        def can_be_observable?
          false
        end
        def observable?
          false
        end
      end

      class ManyEmbeddedProxy
        def can_be_observable?; true; end
        def observable?; @observable; end

        def make_observable
          class << self; include MmDirtier::ManyEmbeddedProxyListener; end unless observable?
          @observable = true
        end
      end

      class ManyEmbeddedPolymorphicProxy
        def can_be_observable?; true; end
        def observable?; @observable; end

        def make_observable
          class << self; include MmDirtier::ManyEmbeddedProxyListener; end unless observable?
          @observable = true
        end
      end

      class InArrayProxy
        def can_be_observable?; true; end
        def observable?; @observable; end

        def make_observable
          class << self; include MmDirtier::InArrayProxyListener;end unless observable?
          @observable = true
        end
      end

      class OneEmbeddedProxy
        def can_be_observable?; true; end
        def observable?; @observable; end

        def make_observable
          class << self; include MmDirtier::OneEmbeddedProxyListener;end unless observable?
          @observable = true
        end
      end

      class ManyDocumentsProxy
        def save_to_collection(options={})
          @target.each { |doc| doc.save(options) if doc.changed? } if @target
        end
      end

    end
  end
end
