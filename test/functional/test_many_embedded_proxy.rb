require 'test_helper'

class ManyEmbeddedProxyTest < Test::Unit::TestCase
  def setup
    @document = Doc { key :ary, Array }
  end

  context "marking changes on many embedded proxies" do
    setup do
      @child = EDoc { key :name, String }
      @document.many :children, :class=>@child
    end

    should "not happen if there are none" do
      doc = @document.new
      doc.children_changed?.should be_false
      doc.children_change.should be_nil
    end

    should "happen when change happens" do
      doc = @document.new
      child = doc.children.build
      doc.children_changed?.should be_true
      doc.children_was.should == []
      doc.children_change.should == [[], [child]]
    end

    should "happen when modified in place" do
      doc = @document.new
      child = doc.children.build
      doc.save!
      new_child = @child.new
      doc.children << new_child
      doc.children_changed?.should be_true
      doc.children_was.should == [child]
      doc.children_change.should == [[child],[child,new_child]]
    end

    should "not be changed when loaded from the database" do
      doc = @document.new
      child = doc.children.build
      doc.changed?.should be_true
      doc.save!
      doc = @document.find(doc.id)
      doc.changed?.should be_false
      doc.children_changed?.should be_false
    end

    should "happen when replaced" do
      doc = @document.new
      child = doc.children.build
      doc.save!
      doc.children_changed?.should be_false
      new_child = @child.new
      doc.children = [new_child]
      doc.children_changed?.should be_true
      doc.children_was.should == [child]
      doc.children_change.should == [[child],[new_child]]
    end

    should "clear when modified in place back to the original state" do
      doc = @document.new
      child = doc.children.build
      doc.save!
      doc.children.build
      doc.children_changed?.should be_true
      doc.children.pop
      doc.children_changed?.should be_false
    end

    should "detect when a collection is set to []" do
      doc = @document.new
      child = doc.children.build
      doc.save!
      doc.children = []
      doc.children_changed?.should be_true
      doc.children_change.should == [[child],[]]
    end

  end
end
