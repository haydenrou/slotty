module Slotty
  class Timeframe
    class << self
      def covers?(surrounding_range, included_range)
        starts_before = surrounding_range.begin <= included_range.begin
        ends_after = surrounding_range.end >= included_range.end

        starts_before && ends_after
      end

      def contains?(excluder, potential_slot)
        start_within = potential_slot.begin >= excluder.begin && potential_slot.begin < excluder.end
        end_within = potential_slot.end > excluder.begin && potential_slot.end <= excluder.end

        start_within || end_within
      end
    end
  end
end

