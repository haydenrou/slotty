require "slotty/timeframe"

module Slotty
  class Slot
    attr_reader :range, :begin, :end

    def initialize(range:)
      @range = range
      @begin = range.begin
      @end = range.end
    end

    def has_overlaps?(excluded_slots = [])
      return false if excluded_slots.empty?

      excluded_slots.any? do |exc_slot|
        Timeframe.contains?(exc_slot, range)
      end
    end

    def to_s
      range.begin.strftime(Slotty.configuration.slot_to_s_format)
    end

    def full
      {
        start_time: range.begin,
        end_time:   range.end,
        time:       to_s
      }
    end
  end
end
