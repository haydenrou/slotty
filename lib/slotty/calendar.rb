# frozen_string_literal: true

require 'active_support/core_ext/date'
require 'active_support/isolated_execution_state'

module Slotty
  class Calendar
    attr_accessor :availabilities, :date

    # Creates a new instance of Calendar.
    #
    # @param date [Date, String, nil] The date to use as the basis for calculating weekly and monthly slots.
    #   If date is nil, the current date is used. If date is a string, it will be parsed into a Date object.
    #   If date is a Date, it will be used as is.
    #
    # @param options [Hash] Options to be passed to the Calendar instance
    # @option options [Integer] :interval_mins (60) Interval in minutes for slots
    # @option options [Integer] :slot_length_mins (60) Length of slot in minutes
    #
    # @return [Calendar] A new instance of Calendar
    # @example
    #   calendar = Slotty::Calendar.new(Date.today)
    #
    def initialize(date = nil, options = {})
      @date = if date.nil?
                Date.current
              elsif date.is_a?(Date)
                date
              else
                Date.parse(date)
              end
      default_values(options)
    end

    # Adds an availability to the calendar's availabilities array
    #
    # @param [Range] range The range representing the start and end times of the availability
    # @param [Hash] meta Additional metadata to store with the availability
    # @raise [InvalidDateError] If the range is not a type of Range
    # @example
    #   calendar = Slotty::Calendar.new
    #   calendar.add_availability(Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 11, 00), { doctor_id: 1 })
    #
    def add_availability(range, meta = {})
      raise InvalidDateError, 'range must be type of Range' unless range.is_a?(Range)

      @availabilities << [range, meta]
    end

    # Returns a hash of all the weekly availabilities for the calendar's date
    #
    # @return [Hash{Symbol => Object}] The hash representation of the weekly availabilities
    #   * :starts_at [DateTime] The starting time of the week
    #   * :ends_at [DateTime] The ending time of the week
    #   * :slots [Hash{String => Hash}]
    #     A nested hash structure representing the slots, grouped by dates and then by times.
    #     The outermost hash has keys as strings representing dates, in the format of 'YYYY-MM-DD'
    #     The second level hash has keys as strings representing times, in the format of 'HH:MM AM/PM'
    #     The innermost array contains hashes representing individual slots, with the following keys:
    #       * :start_time [Time] The starting time of the slot
    #       * :end_time [Time] The ending time of the slot
    #       * :meta [Hash] Additional metadata for the slot, as provided during add_availability
    #
    # @example
    #   calendar = Slotty::Calendar.new
    #   calendar.add_availability(Time.new(2023, 02, 01, 8, 00)..Time.new(2020, 05, 01, 11, 00), { doctor_id: 1 })
    #   calendar.weekly
    #   => {
    #        starts_at: "Mon, 30 Jan 2023 00:00:00.000000000 CET +01:00",
    #        ends_at: "Sun, 05 Feb 2023 23:59:59.999999999 CET +01:00",
    #        slots: {
    #          ...
    #          "2023-02-01": {
    #            ...
    #            "08:00 AM": [{...}],
    #            ...
    #          },
    #          ...
    #        }
    #      }
    #
    def weekly
      grouped_by_days(slots, @date.beginning_of_week.beginning_of_day, @date.end_of_week.end_of_day)
    end

    # Returns a hash of the monthly availability slots.
    #
    # @return [Hash{Symbol => Object}] The hash representation of the monthly availabilities
    #   * :starts_at [DateTime] The starting time of the month
    #   * :ends_at [DateTime] The ending time of the month
    #   * :slots [Hash{String => Hash}]
    #     A nested hash structure representing the slots, grouped by dates and then by times.
    #     The outermost hash has keys as strings representing dates, in the format of 'YYYY-MM-DD'
    #     The second level hash has keys as strings representing times, in the format of 'HH:MM AM/PM'
    #     The innermost array contains hashes representing individual slots, with the following keys:
    #       * :start_time [Time] The starting time of the slot
    #       * :end_time [Time] The ending time of the slot
    #       * :meta [Hash] Additional metadata for the slot, as provided during add_availability
    #
    # @example
    #   calendar = Slotty::Calendar.new
    #   calendar.add_availability(Time.new(2023, 02, 01, 8, 00)..Time.new(2020, 05, 01, 11, 00), { doctor_id: 1 })
    #   calendar.monthly
    #   => {
    #        starts_at: "Mon, 30 Jan 2023 00:00:00.000000000 CET +01:00",
    #        ends_at: "Sun, 05 Feb 2023 23:59:59.999999999 CET +01:00",
    #        slots: {
    #          ...
    #          "2023-02-01": {
    #            ...
    #            "08:00 AM": [{...}],
    #            ...
    #          },
    #          ...
    #        }
    #      }
    #
    def monthly
      grouped_by_days(slots, @date.beginning_of_month.beginning_of_day, @date.end_of_month.end_of_day)
    end

    private

    # @private
    # Sets default values for @availabilities, @interval_mins, and @slot_length_mins instance variables.
    #
    # @param options [Hash] the hash of options that should include :interval_mins and :slot_length_mins keys.
    # @return [void]
    def default_values(options)
      @availabilities = []
      @interval_mins = options.fetch(:interval_mins, 60)
      @slot_length_mins = options.fetch(:slot_length_mins, 60)
    end

    # @private
    # This method groups the slot availability data by days for either a week or a month.
    # It initializes the day groups with an empty hash and then adds slot data to the appropriate day group.
    # Finally, it returns a hash with the start and end dates of the week/month and the grouped slots data.
    #
    # @param [Array] slots An array of slot availability data
    # @param [DateTime] from The start date of the week/month to be considered
    # @param [DateTime] to The end date of the week/month to be considered
    # @return [Hash] A hash containing the start and end dates and grouped slot data
    def grouped_by_days(slots, from, to)
      groups = initial_day_groups(from, to)
      add_slots_to_day_groups(slots, groups)
      create_result_hash(from, to, groups)
    end

    # @private
    # Returns a hash of dates with an empty hash as value, between the range specified by from and to.
    # The keys of the hash are the dates in string format.
    #
    # @param [DateTime] from start date
    # @param [DateTime] to end date
    # @return [Hash] a hash with dates as keys and empty hashes as values
    # @example
    #   from = Date.parse("2022-02-01")
    #   to = Date.parse("2022-02-05")
    #   initial_day_groups(from, to)
    #   # => { "2022-02-01" => {}, "2022-02-02" => {}, "2022-02-03" => {}, "2022-02-04" => {}, "2022-02-05" => {} }
    def initial_day_groups(from, to)
      (from.to_datetime..to.to_datetime).to_a.group_by { |dt| dt.to_date.to_s }.transform_values { {} }
    end

    # @private
    # Adds the slots to their respective day group
    #
    # @param slots [Array] An array of slot hashes
    # @param groups [Hash] A hash of day groups where the keys are date strings and the values are empty hashes
    #
    # @return [Hash] The updated groups hash with the slots added to their respective day groups
    #
    # @example
    #   groups = { "2022-02-01" => {}, "2022-02-02" => {} }
    #   slots = [
    #     { start_time: Time.new(2022, 2, 1, 10, 0, 0), end_time: Time.new(2022, 2, 1, 11, 0, 0) },
    #     { start_time: Time.new(2022, 2, 2, 9, 0, 0), end_time: Time.new(2022, 2, 2, 10, 0, 0) }
    #   ]
    #   add_slots_to_day_groups(slots, groups)
    #   => { "2022-02-01" => { "10:00 AM" => [{ start_time: Time.new(2022, 2, 1, 10, 0, 0), end_time: Time.new(2022, 2, 1, 11, 0, 0) }] },
    #        "2022-02-02" => { "09:00 AM" => [{ start_time: Time.new(2022, 2, 2, 9, 0, 0), end_time: Time.new(2022, 2, 2, 10, 0, 0) }] }
    #      }
    def add_slots_to_day_groups(slots, groups)
      slots.each do |slot|
        datekey = slot[:start_time].to_date.to_s
        next if groups[datekey].nil?

        timekey = slot[:start_time].to_datetime.strftime('%I:%M %p')
        groups[datekey][timekey] = [] if groups[datekey][timekey].nil?
        groups[datekey][timekey] << slot
      end
    end

    # @private
    # Creates a hash with start and end dates and slots
    #
    # @param from [Time] start date
    # @param to [Time] end date
    # @param groups [Array] array of slot groups
    #
    # @return [Hash] hash with start and end dates and slots
    #
    # @example
    #   create_result_hash(Time.now, Time.now + 1.week, [{venue_id: 1}])
    #   # => { starts_at: Time.now, ends_at: Time.now + 1.week, slots: [{venue_id: 1}] }
    def create_result_hash(from, to, groups)
      {
        starts_at: from,
        ends_at: to,
        slots: groups
      }
    end

    # @private
    # Builds and returns an array of slots based on the availabilities.
    #
    # @return [Array] An array of hashes representing individual slots, with the following keys:
    #   * :start_time [Time] The starting time of the slot
    #   * :end_time [Time] The ending time of the slot
    #   * :meta [Hash] Additional metadata for the slot, as provided during add_availability
    #
    def slots
      availabilities.flat_map do |range, meta|
        Slotty.get_slots(
          slot_length_mins: @slot_length_mins,
          interval_mins: @interval_mins,
          for_range: range,
          as: :calendar,
          exclude_times: [],
          meta:
        )
      end
    end
  end
end
