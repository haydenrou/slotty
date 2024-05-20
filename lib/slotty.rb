# frozen_string_literal: true

require 'slotty/version'
require 'slotty/timeframe'
require 'slotty/slot'

# The Slotty module provides methods to generate time slots based on a specified
# range, slot length, and interval. It also allows for excluding specific time
# slots from the generated list.
module Slotty
  InvalidFormatError = Class.new(StandardError)
  InvalidDateError = Class.new(StandardError)
  InvalidSlotLengthError = Class.new(StandardError)
  InvalidIntervalError = Class.new(StandardError)
  InvalidExclusionError = Class.new(StandardError)

  class << self
    # Retrieves available slots within a specified range, considering slot length,
    # interval between slots, and any times to be excluded.
    #
    # @param for_range [Range] The range within which to generate slots.
    # @param slot_length_mins [Integer] The length of each slot in minutes.
    # @param interval_mins [Integer] The interval between the start of each slot in minutes.
    # @param as [Symbol] The format in which to return the slots (:full by default).
    # @param exclude_times [Array<Range>] An array of time ranges to be excluded.
    # @raise [InvalidDateError] If for_range is not a Range.
    # @raise [InvalidSlotLengthError] If slot_length_mins is not an integer.
    # @raise [InvalidIntervalError] If interval_mins is not an integer.
    # @raise [InvalidExclusionError] If exclude_times is not an array of ranges.
    # @raise [InvalidFormatError] If the format specified in `as` is invalid.
    # @return [Array<Object>] An array of slots in the specified format.
    # rubocop:disable Metrics/MethodLength
    # rubocop:disable Metrics/AbcSize
    # rubocop:disable Metrics/CyclomaticComplexity
    # rubocop:disable Metrics/PerceivedComplexity
    def get_slots(for_range:,
                  slot_length_mins:,
                  interval_mins:,
                  as: :full,
                  exclude_times: [])
      raise InvalidDateError, 'for_value must be type of Range' unless for_range.is_a?(Range)
      raise InvalidSlotLengthError, 'slot_length_mins must be an integer' unless slot_length_mins.is_a?(Integer)
      raise InvalidIntervalError, 'interval_mins must be an integer' unless interval_mins.is_a?(Integer)

      unless exclude_times.is_a?(Array) && exclude_times.all? do |t|
               t.is_a?(Range)
             end
        raise InvalidExclusionError,
              'exclude_times must be an array of time ranges'
      end

      slot_length = slot_length_mins * 60
      interval = interval_mins * 60

      slots = Array.new(0)

      potential_slot = Slot.new(range: for_range.begin..(for_range.begin + slot_length))

      while Timeframe.covers?(for_range, potential_slot)
        if potential_slot.overlaps?(exclude_times)
          range = (potential_slot.begin + interval)..(potential_slot.begin + interval + slot_length)
          potential_slot = Slot.new(range:)

          next
        end

        raise InvalidFormatError, 'cannot format slot in this way' unless potential_slot.respond_to?(as)

        slots << potential_slot.send(as)

        range = (potential_slot.begin + interval)..(potential_slot.begin + interval + slot_length)

        potential_slot = Slot.new(range:)
      end

      slots
    end
    # rubocop:enable Metrics/MethodLength
    # rubocop:enable Metrics/AbcSize
    # rubocop:enable Metrics/CyclomaticComplexity
    # rubocop:enable Metrics/PerceivedComplexity
  end
end
