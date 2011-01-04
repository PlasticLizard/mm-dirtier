module MongoMapper
  module Extensions
    module Hash
      def from_mongo(value)
        value ||= {}
        value.make_indifferent!
      end
    end
  end
end

module IndifferentAccess
  def [](key)
    key = key.to_s
    super(key)
  end

  def []=(key,val)
    super(key.to_s,val)
  end

  def include?(key)
    super(key.to_s)
  end

  def delete(key)
    super(key.to_s)
  end

  def method_missing(sym,*args,&block)
    return self[sym.to_s[0..-2]] = args[0] if sym.to_s =~ /.*=$/
    return self[sym] if self.keys.include?(sym.to_s)
    nil
  end
end

class Hash
  extend MongoMapper::Extensions::Hash

  def make_indifferent!
    return self if defined?(@is_indifferent) && @is_indifferent

    stringify_keys!
    extend IndifferentAccess
    @is_indifferent = true

    self
  end
end

