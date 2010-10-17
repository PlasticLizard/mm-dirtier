module MmDirtier
  module OneEmbeddedProxyListener
    include Observables::Base

    def replace(val)
      changing(:modifier) {super}
    end

    #This is a dirty hack.
    #duplicable? has to return true,
    #or the ActiveModel::Dirty will store
    # the proxy in its change set,
    # and then when you check for changes
    # it will always reflect the latest value
    # of its target, which isn't what is desired.
    # However, duplicating an embedded document
    # gives it a new object ID, which ruins the
    # identity of the child and isn't what
    # we want either. Thus this nasty, nasty
    # business. There must be a better way,
    # but at the moment it escapes me.
    def duplicable?
      true
    end

    def clone
      target
    end
  end
end
