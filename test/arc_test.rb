require "test_helper"

describe Arc do
  describe "#new" do
    it "accepts +from+ and +to+ rationals" do
      arc = Arc.new(1, 3)
      assert_equal 1, arc.from
      assert_equal 3, arc.to
    end
  end

  describe "#cycles" do
    it "splits arc into a list of arcs at cycle boundaries" do
      arcs = Arc.new(0, 3).cycles
      assert_equal [
        Arc.new(0, 1),
        Arc.new(1, 2),
        Arc.new(2, 3),
      ], arcs

      arcs = Arc.new(0, 3.5).cycles
      assert_equal [
        Arc.new(0, 1),
        Arc.new(1, 2),
        Arc.new(2, 3),
        Arc.new(3, 3.5),
      ], arcs
    end

    it "returns an empty list if arc has no width" do
      arcs = Arc.new(0, 0).cycles
      assert_equal [], arcs
    end
  end

  describe "#cycles_zero_width" do
    it "splits arc into a list of arcs at cycle boundaries" do
      arcs = Arc.new(0, 3.5).cycles_zero_width
      assert_equal [
        Arc.new(0, 1),
        Arc.new(1, 2),
        Arc.new(2, 3),
        Arc.new(3, 3.5),
      ], arcs
    end

    it "works with zero-width arcs" do
      arcs = Arc.new(2, 2).cycles_zero_width
      assert_equal [Arc.new(2, 2)], arcs
    end
  end

  describe "#whole_cycles" do
    it "returns a list of arcs of the whole cycles which are included in this arc" do
      arcs = Arc.new(0, 3).whole_cycles
      assert_equal [
        Arc.new(0, 1),
        Arc.new(1, 2),
        Arc.new(2, 3),
      ], arcs

      arcs = Arc.new(0, 3.5).whole_cycles
      assert_equal [
        Arc.new(0, 1),
        Arc.new(1, 2),
        Arc.new(2, 3),
        Arc.new(3, 4),
      ], arcs
    end
  end

  describe "#apply" do
    it "returns a new arc by applying +block+ to both +from+ and +to+" do
      assert_equal Arc.new(3, 6), Arc.new(1, 2).apply { |v| v * 3 }
      assert_equal Arc.new(1/2, 1), Arc.new(1, 2).apply { |v| v / 2 }
    end
  end
end
