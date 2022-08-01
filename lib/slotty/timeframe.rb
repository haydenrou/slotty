module Slotty
  class Timeframe
    class << self
      def covers?(surrounding_range, included_range)
        starts_before = surrounding_range.begin <= included_range.begin
        ends_after = surrounding_range.end >= included_range.end

        starts_before && ends_after
      end

      def contains?(excluder, potential_slot)
        starts_within?(excluder, potential_slot) || ends_within?(excluder, potential_slot)
      end

      def starts_within?(excluder, potential_slot)
        potential_slot.begin >= excluder.begin && potential_slot.begin < excluder.end
      end

      def ends_within?(excluder, potential_slot)
        potential_slot.end > excluder.begin && potential_slot.end <= excluder.end
      end
    end
  end
end

