require "slotty/version"
require "slotty/validator"

module Slotty
  class Error < StandardError; end

  class << self
    def get_slots(from:, to:, slot_length:, timeframe:, exclude_times: [])
      slots = Array.new(0)

      potential_slot = from..(from + slot_length)

      while (from..to).cover?(potential_slot)
        if Validator.has_overlaps?(potential_slot, exclude_times)
          potential_slot = (potential_slot.begin + timeframe)..(potential_slot.begin + timeframe + slot_length)

          next
        end

        slots << {
          start_time: potential_slot.begin,
          end_time:   potential_slot.end,
          time:       potential_slot.begin.strftime('%H:%M %p')
        }

        potential_slot = (potential_slot.begin + timeframe)..(potential_slot.begin + timeframe + slot_length)
      end

      slots
    end
  end
end
