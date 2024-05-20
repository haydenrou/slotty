# frozen_string_literal: true

module Slotty
  # The Timeframe class provides methods to determine if one time range
  # covers or contains another time range.
  class Timeframe
    class << self
      # Determines if the surrounding_range completely covers the included_range.
      #
      # @param surrounding_range [Range] The range that is expected to cover the other.
      # @param included_range [Range] The range that is expected to be covered.
      # @return [Boolean] true if surrounding_range covers included_range, otherwise false.
      def covers?(surrounding_range, included_range)
        starts_before = surrounding_range.begin <= included_range.begin
        ends_after = surrounding_range.end >= included_range.end

        starts_before && ends_after
      end

      # Determines if the potential_slot is contained within the excluder range.
      #
      # @param excluder [Range] The range that potentially excludes another.
      # @param potential_slot [Range] The range that is expected to be contained.
      # @return [Boolean] true if potential_slot is within excluder, otherwise false.
      def contains?(excluder, potential_slot)
        start_within = potential_slot.begin >= excluder.begin && potential_slot.begin < excluder.end
        end_within = potential_slot.end > excluder.begin && potential_slot.end <= excluder.end

        start_within || end_within
      end
    end
  end
end
