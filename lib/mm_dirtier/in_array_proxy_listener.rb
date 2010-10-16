module MmDirtier
  module InArrayProxyListener
    include Observables::Base

    def ids
      super.tap do |ids|

        unless ids.observable?
          ids.make_observable
          ids.set_observer do |sender,type,args|
            notifier.publish type, args
          end
        end

      end

    end

  end
end
