require 'test_helper'

class TestMongoMapperDirtier < Test::Unit::TestCase
  context "including mm_dirtier" do
    should "include something or other" do
      assert_equal defined?(MongoMapper::Dirtier), "constant"
    end
  end
end
