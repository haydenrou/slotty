module Slotty
  class Validator
    class << self
      def has_overlaps?(slot, excluded_slots = [])
        return false if excluded_slots.empty?

        excluded_slots.any? do |excluder|
          excluder_overlaps_slot_start = (excluder[:start]..excluder[:end]).include? slot.begin
          excluder_overlaps_slot_end   = (excluder[:start]..excluder[:end]).include? slot.end
          slot_overlaps_excluder_start = (slot.begin..slot.end).include? excluder[:start]
          slot_overlaps_excluder_end   = (slot.begin..slot.end).include? excluder[:end]

          excluder_overlaps_slot_start |
            excluder_overlaps_slot_end |
            slot_overlaps_excluder_start |
            slot_overlaps_excluder_end
        end
      end
    end
  end
end
