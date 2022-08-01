require "slotty/version"
require "slotty/timeframe"
require "slotty/slot"

module Slotty
  InvalidFormatError = Class.new(StandardError)
  InvalidDateError = Class.new(StandardError)
  InvalidSlotLengthError = Class.new(StandardError)
  InvalidIntervalError = Class.new(StandardError)
  InvalidExclusionError = Class.new(StandardError)

  class << self
    def get_slots(for_range:, slot_length_mins:, interval_mins:, as: :full, exclude_times: [], allow_slot_run_over: false)
      raise InvalidDateError, "for_value must be type of Range" unless for_range.is_a?(Range)
      raise InvalidSlotLengthError, "slot_length_mins must be an integer" unless slot_length_mins.is_a?(Integer)
      raise InvalidIntervalError, "interval_mins must be an integer" unless interval_mins.is_a?(Integer)
      raise InvalidExclusionError, "exclude_times must be an array of time ranges" unless exclude_times.is_a?(Array) && exclude_times.all? { |t| t.is_a?(Range) }

      slot_length = slot_length_mins * 60
      interval = interval_mins * 60

      slots = Array.new(0)

      potential_slot = Slot.new(range: for_range.begin..(for_range.begin + slot_length))

      while Timeframe.covers?(for_range, potential_slot) || (allow_slot_run_over && Timeframe.starts_within?(for_range, potential_slot))
        if potential_slot.has_overlaps?(exclude_times)
          potential_slot = Slot.new(range: (potential_slot.begin + interval)..(potential_slot.begin + interval + slot_length))

          next
        end

        raise InvalidFormatError, "cannot format slot in this way" unless potential_slot.respond_to?(as)

        slots << potential_slot.send(as)

        potential_slot = Slot.new(range: (potential_slot.begin + interval)..(potential_slot.begin + interval + slot_length))
      end

      slots
    end
  end
end
