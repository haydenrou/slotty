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
    def get_slots(options)
      for_range = options.fetch(:for_range, 60)
      slot_length_mins = options.fetch(:slot_length_mins, 60)
      interval_mins = options.fetch(:interval_mins, 60)
      as = options.fetch(:as, :full)
      exclude_times = options.fetch(:exclude_times, [])
      meta = options.fetch(:meta, [])

      raise InvalidDateError, "for_value must be type of Range" unless for_range.is_a?(Range)
      raise InvalidSlotLengthError, "slot_length_mins must be an integer" unless slot_length_mins.is_a?(Integer)
      raise InvalidIntervalError, "interval_mins must be an integer" unless interval_mins.is_a?(Integer)
      raise InvalidExclusionError, "exclude_times must be an array of time ranges" unless exclude_times.is_a?(Array) && exclude_times.all? { |t| t.is_a?(Range) }

      slot_length = slot_length_mins * 60
      interval = interval_mins * 60

      slots = Array.new(0)

      potential_slot = slot_for_range(range: for_range.begin..(for_range.begin + slot_length), meta:)

      while Timeframe.covers?(for_range, potential_slot)
        if potential_slot.has_overlaps?(exclude_times)
          potential_slot = slot_for_range(range: (potential_slot.begin + interval)..(potential_slot.begin + interval + slot_length), meta:)

          next
        end

        raise InvalidFormatError, "cannot format slot in this way" unless potential_slot.respond_to?(as)

        slots << potential_slot.send(as)

        potential_slot = slot_for_range(range: (potential_slot.begin + interval)..(potential_slot.begin + interval + slot_length), meta:)
      end

      slots
    end

    def slot_for_range(range:, meta:)
      Slot.new(range:, meta:)
    end
  end
end
