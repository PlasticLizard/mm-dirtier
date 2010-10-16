module MongoMapper
  module Plugins
    module Associations

      class ManyEmbeddedProxy
        def make_observable
          class << self; include MmDirtier::ManyEmbeddedProxyListener; end unless observable?
        end
      end

      class InArrayProxy
        def make_observable
          class << self; include MmDirtier::InArrayProxyListener;end unless observable?
        end
      end

    end
  end
end
