module MmDirtier
  module ManyEmbeddedProxyListener
    include Observables::ArrayWatcher

    #It appears that #make_observable operates on the underlying
    #target, not on the proxy. Therefore, 'replace', which is proxied,
    #does not get properly overriden. this is intended to fix that.
    def replace(*args)
      changes = changes_for(:modified,:replace,*args)
      changing(:modified,:trigger=>:replace, :changes=>changes) {super}
    end
  end
end
