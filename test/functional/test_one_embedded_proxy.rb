require 'test_helper'

class OneEmbeddedProxyTest < Test::Unit::TestCase
  def setup
    @document = Doc { key :ary, Array }
  end

  context "marking changes on one embedded  proxies" do
    setup do
      @child = EDoc { key :name, String }
      @document.one :child, :class=>@child
    end

    should "not happen if there are none" do
      doc = @document.new
      doc.child_changed?.should be_false
      doc.child_change.should be_nil
    end

    should "happen when change happens" do
      doc = @document.new
      child = @child.new
      doc.child = child
      doc.child_changed?.should be_true
      doc.child_was.should == nil
      doc.child_change.should == [nil, child]
    end

    should "not be changed when loaded from the database" do
      doc = @document.new
      doc.child = @child.new
      doc.changed?.should be_true
      doc.save!
      doc = @document.find(doc.id)
      doc.changed?.should be_false
      doc.child_changed?.should be_false
    end

    should "detect when a collection is set to nil" do
      doc = @document.new
      c = doc.child.build
      doc.save!
      doc.child = nil
      doc.child_changed?.should be_true
      changes = doc.child_change
      changes[0].should == c
      changes[1].should be_nil
    end

    should "remove changes when set back to its original value" do
      doc = @document.new
      child = doc.child.build
      doc.save!
      doc.child = @child.new
      doc.child_changed?.should be_true
      doc.child = child
      doc.child_changed?.should be_false
    end

    should "ignore in place changes to child attributes" do
      doc = @document.new
      child = doc.child.build
      doc.save!
      doc.child.name = "hi there"
      doc.child_changed?.should be_false
    end
  end
end
