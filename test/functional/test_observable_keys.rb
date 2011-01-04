
require 'test_helper'

class ObservableKeysTest < Test::Unit::TestCase
  context "marking changes on observable array keys" do
    setup do
      @document = Doc { key :ary, Array }
    end

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

  context "marking changes on observable hash keys" do
    setup do
      @document = Doc { key :hash, Hash }
    end

    should "happen when change happens" do
      doc = @document.new
      doc.hash = {"Golly" => "Gee", "Willikers" => "Batman"}
      doc.hash_changed?.should be_true
      doc.hash_was.should == {}
      doc.hash_change.should == [{}, {"Golly" => "Gee", "Willikers" => "Batman"}]
    end

    should "happen when modified in place" do
      doc = @document.new
      doc.hash = {"Golly" => "Gee", "Willikers" => "Batman"}
      doc.save!
      doc.hash["Willikers"] = "Robin"
      doc.hash_changed?.should be_true
      doc.hash_was.should == {"Golly" => "Gee", "Willikers" => "Batman"}
      doc.hash_change.should == [{"Golly" => "Gee", "Willikers" => "Batman"},{"Golly" => "Gee", "Willikers" => "Robin"}]
    end
  end
end
