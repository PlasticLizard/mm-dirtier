require 'test_helper'

class DirtierTest < Test::Unit::TestCase
  def setup
    @document = Doc { key :ary, Array }
  end

  context "marking changes on observable keys" do
    should "not happen if there are none" do
      doc = @document.new
      doc.ary_changed?.should be_false
      doc.ary_change.should be_nil
    end

    should "happen when change happens" do
      doc = @document.new
      doc.ary = %w(Golly Gee Willikers Batman)
      doc.ary_changed?.should be_true
      doc.ary_was.should == []
      doc.ary_change.should == [[], %w(Golly Gee Willikers Batman)]
    end

    should "happen when modified in place" do
      doc = @document.new
      doc.ary = %w(Golly Gee Willikers Batman)
      doc.save!
      doc.ary.push('POW!')
      doc.ary_changed?.should be_true
      doc.ary_was.should == %w(Golly Gee Willikers Batman)
      doc.ary_change.should == [%w(Golly Gee Willikers Batman),%w(Golly Gee Willikers Batman POW!)]
    end

    should "clear when modified in place back to the original state" do
      doc = @document.new
      doc.ary = %w(Golly Gee Willikers Batman)
      doc.save!
      doc.ary.push('POW!')
      doc.ary_changed?.should be_true
      doc.ary.pop
      doc.ary_changed?.should be_false
    end

    should "not flag changes when an array removed from a doc is changed" do
      doc = @document.new
      doc.ary = %w(hi there)
      a1 = doc.ary
      doc.ary = %w(huggy bear)
      a2 = doc.ary
      doc.save!
      a1 << "huggy bear"
      doc.ary_changed?.should be_false
      a2.unshift("hi there")
      doc.ary_changed?.should be_true
    end

  end

  context "marking changes on embedded many proxies" do
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

  context "marking changes on many in array proxies" do
    setup do
      @child = Doc { key :name, String }
      @document.key  :child_ids, Array
      @document.many :children, :class=>@child, :in => :child_ids
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
