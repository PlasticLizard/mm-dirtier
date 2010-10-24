require 'test_helper'

class OneEmbeddedProxyTest < Test::Unit::TestCase
  def setup
    @document = Doc("Doc") { key :ary, Array }
  end

  context "marking changes on one embedded  proxies" do
    setup do
      @child = EDoc("Child") { key :name, String }
      @child.plugin MongoMapper::Plugins::Dirty
      @child.plugin MmDirtier::Plugins::Dirtier
      @document.one :child, :class=>@child
      @child.one :grandchild, :class=>@child

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

    should "detect when a child is set to nil" do
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

    should "detect deletion on a nested embedded one" do
      doc = @document.new
      child = doc.child.build
      grandchild = child.grandchild.build
      doc.save!
      child.name = "tada"
      child.grandchild = nil
      child.grandchild_changed?.should be_true
      change = child.grandchild_change
      change[0].should == grandchild
      change[1].should be_nil
    end
  end
end
