require "test_helper"

describe Event do
  describe "#new" do
    it "accepts a +value+, a +whole+ arc and a +part+ arc" do
      event = Event.new(42, Arc.new(1/2, 1), Arc.new(0,1))
      assert_equal 42, event.value
      assert_equal Arc.new(1/2, 1), event.whole
      assert_equal Arc.new(0, 1), event.part
    end
  end
end
