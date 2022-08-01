module Slotty
  class Configuration
    attr_accessor :slot_to_s_format

    def initialize
      @slot_to_s_format = '%I:%M %p'
    end
  end
end
