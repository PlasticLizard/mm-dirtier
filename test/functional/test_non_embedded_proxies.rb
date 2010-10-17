require 'test_helper'

class NonEmbeddedProxyTest < Test::Unit::TestCase
  def setup
    @document = Doc { key :name, String }
    @refdoc = Doc { key :name, String }
  end

  context "changes on many documents proxy" do
    setup do
      @document.many :refs, :class=>@refdoc
    end

    should "not happen" do
      doc = @document.new
      doc.refs.build
      doc.changed?.should be_false
    end

  end
end
