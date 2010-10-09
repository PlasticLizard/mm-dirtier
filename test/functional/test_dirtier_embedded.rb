require 'test_helper'

class DirtierEmbeddedTest < Test::Unit::TestCase
  def setup
    @edoc = EDoc('Duck') { key :name, String }
    @document = Doc('Long') { key :name, String }
    @document.many :ducks, :class=>@edoc
  end

  context "Embedded documents" do
    setup do
      @doc = @document.new
      @duck = @doc.ducks.build
    end

    should "track changes" do
      @duck.name = "hi"
      @duck.changed?.should be_true
    end

    should "clear changes when saved" do
      @duck.name = "hi"
      @duck.changed?.should be_true
      @duck.save!
      @duck.changed?.should_not be_true
    end

    should "clear changes when the parent is saved" do
      @duck.name = "hi"
      @duck.changed?.should be_true
      @doc.save!
      @duck.changed?.should_not be_true
    end

    context "with nested embedded documents" do
      setup do
        @inner_edoc = EDoc('Dong') {key :name, String}
        @edoc.many :dongs, :class=>@inner_edoc
        @dong = @duck.dongs.build
      end

      should "track changes" do
        @dong.name = "hi"
        @dong.changed?.should be_true
      end

      should "clear changes when the root saves" do
        @dong.name = "hi"
        @dong.changed?.should be_true
        @doc.save!
        @dong.changed?.should be_false
      end

    end

  end

end
