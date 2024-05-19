# frozen_string_literal: true

require 'slotty/timeframe'

module Slotty
  # The Slot class represents a time slot and provides methods to check
  # for overlaps with excluded slots and to format the time slot as a string.
  class Slot
    attr_reader :range, :begin, :end

    # Initializes a Slot instance with a specified range.
    #
    # @param range [Range] The time range for the slot.
    def initialize(range:)
      @range = range
      @begin = range.begin
      @end = range.end
    end

    # Checks if the slot has overlaps with any of the excluded slots.
    #
    # @param excluded_slots [Array<Range>] An array of ranges representing excluded slots.
    # @return [Boolean] true if there are overlaps with any excluded slots, otherwise false.
    def overlaps?(excluded_slots = [])
      return false if excluded_slots.empty?

      excluded_slots.any? do |exc_slot|
        Timeframe.contains?(exc_slot, range)
      end
    end

    # Returns the start time of the slot formatted as a string.
    #
    # @return [String] The formatted start time of the slot.
    def to_s
      range.begin.strftime('%I:%M %p')
    end

    # Returns a hash representation of the slot with detailed time information.
    #
    # @return [Hash] A hash containing the start time, end time, and formatted time.
    def full
      {
        start_time: range.begin,
        end_time: range.end,
        time: to_s
      }
    end
  end
end
