module MmDirtier
  module OneProxyListener
    include Observables::Base

    def replace(val)
      change_type = target.nil? ? :modified : :added
      changes = changes_for(change_type,:replace,val)
      changing(change_type,:trigger=>:replace, :changes=>changes) {super}
    end

    def changes_for(change_type, trigger_method, *args, &block)
      prev = target.nil? ? nil : target.dup
      if change_type == :added
        lambda {{:added=>args}}
      else
        lambda{{:removed=>[prev], :added=>args}}
      end
    end

    def dup
      target.dup
    end

  end
end
