require 'test_helper'

class InArrayProxyTest < Test::Unit::TestCase
  def setup
    @document = Doc { key :ary, Array }
  end

  context "marking changes on many in array proxies" do
    setup do
      @child = Doc { key :name, String }
      @document.key :child_ids, Array
      @document.many :children, :class=>@child, :in=>:child_ids
    end

    should "not happen if there are none" do
      doc = @document.new
      doc.child_ids_changed?.should be_false
      doc.child_ids_change.should be_nil
    end

    should "happen when change happens" do
      doc = @document.new
      child = @child.create
      doc.children << child
      doc.child_ids_changed?.should be_true
      doc.child_ids_was.should == []
      doc.child_ids_change.should == [[], [child.id]]
    end

    should "track changes for the id array, not the association itself" do
      doc = @document.new
      child = @child.create
      doc.children << child
      doc.children_changed?.should be_false
      doc.child_ids_changed?.should be_true
    end

    should "happen when modified in place" do
      doc = @document.new
      child = @child.create
      doc.children << child
      doc.save!
      new_child = @child.new
      doc.children << new_child
      doc.child_ids_changed?.should be_true
      doc.child_ids_was.should == [child.id]
      doc.child_ids_change.should == [[child.id],[child.id,new_child.id]]
    end

    should "not be changed when loaded from the database" do
      doc = @document.new
      doc.children << @child.create
      doc.changed?.should be_true
      doc.save!
      doc = @document.find(doc.id)
      doc.changed?.should be_false
      doc.child_ids_changed?.should be_false
    end

    should "happen when replaced" do
      doc = @document.new
      child = @child.create
      doc.children << child
      doc.save!
      doc.child_ids_changed?.should be_false
      new_child = @child.create
      doc.children = [new_child]
      doc.child_ids_changed?.should be_true
      doc.child_ids_was.should == [child.id]
      doc.child_ids_change.should == [[child.id],[new_child.id]]
    end

    should "detect when a collection is set to []" do
      doc = @document.new
      child = @child.create
      doc.children << child
      doc.save!
      doc.children = []
      doc.child_ids_changed?.should be_true
      doc.child_ids_change.should == [[child.id],[]]
    end
  end
end
