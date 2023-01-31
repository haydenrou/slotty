require "slotty/timeframe"

module Slotty
  class Slot
    attr_reader :range, :begin, :end, :meta

    def initialize(range:, meta: {})
      @range = range
      @begin = range.begin
      @end = range.end
      @meta = meta
    end

    def has_overlaps?(excluded_slots = [])
      return false if excluded_slots.empty?

      excluded_slots.any? do |exc_slot|
        Timeframe.contains?(exc_slot, range)
      end
    end

    def to_s
      range.begin.strftime('%I:%M %p')
    end

    def full
      {
        start_time: range.begin,
        end_time:   range.end,
        time:       to_s
      }
    end

    def calendar
      {
        start_time: range.begin,
        end_time:   range.end,
        meta: meta
      }
    end
  end
end
