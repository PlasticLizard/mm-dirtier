require 'test_helper'

class DirtierTest < Test::Unit::TestCase
  def setup
    @document = Doc { key :ary, Array }
    @document.plugin(MongoMapper::Plugins::Dirtier)
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
end
