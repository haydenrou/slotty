# Slotty

Slotty provides a way of determining available slots within a time frame. An example would be where a service provider needs to take bookings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slotty'
```

And then execute:
```ruby
bundle
```

Or install it yourself as:

```ruby
gem install slotty
```

## Usage

```ruby
Slotty.get_slots(
  for_range: Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 11, 00),
  slot_length_mins: 60,
  interval_mins: 15,
  exclude_times: [
    Time.new(2020, 05, 01, 9, 00)..Time.new(2020, 05, 01, 10, 00)
  ]
)

# => [
#   {
#     start_time: Time.new(2020, 05, 01, 8, 00),
#     end_time: Time.new(2020, 05, 01, 9, 00),
#     time: "08:00 AM"
#   },
#   {
#     start_time: Time.new(2020, 05, 01, 10, 00),
#     end_time: Time.new(2020, 05, 01, 11, 00),
#     time: "10:00 AM"
#   },
# ]
```

If you want to just receive the human times back (i.e. "10:00 AM"), you can pass `for: :to_s` to `#get_slots`

### Slotty::Calendar

The `Slotty::Calendar` class provides a convenient way to manage and display time slots in a weekly and monthly calendar format. It can also be used to manage time slots for various purposes, for example scheduling appointments for multiple doctors. The calendar allows you to add time slots and associate metadata with them, such as a doctor ID in the case of doctor appointments. Time slots are represented as ranges of time and can be added to the calendar using the add_availability method.

#### Initialization

`Slotty::Calendar` can be initialized with a date and optional options. If no date is provided, the current date will be used.

```ruby
calendar = Slotty::Calendar.new(params[:date], interval_mins: 30, slot_length_mins: 30)
```

#### Adding time slots

Use the `add_availability` method to add a range and optional metadata:

```ruby
calendar.add_availability(Time.new(2021, 1, 1, 8, 00)..Time.new(2021, 1, 1, 17, 00), { venue_id: 658, employee_id: 344 })
```

The code is an example of how you can use add_availability method to add time slots to a calendar, with a meta attribute of doctor_id to identify which doctor is available during that time slot:

```ruby
calendar = Slotty::Calendar.new('2021-01-01')
calendar.add_availability(Time.new(2021, 1, 1, 9, 00)..Time.new(2021, 1, 1, 12, 00), { doctor_id: 1 })
calendar.add_availability(Time.new(2021, 1, 1, 10, 00)..Time.new(2021, 1, 1, 11, 00), { doctor_id: 2 })
calendar.weekly

# => {
#   "starts_at": "2020-12-28T00:00:00.000+01:00",
#   "ends_at": "2021-01-03T23:59:59.999+01:00",
#   "slots": {
#     "2020-12-28": {},
#     "2020-12-29": {},
#     "2020-12-30": {},
#     "2020-12-31": {},
#     "2021-01-01": {
#       "09:00 AM": [
#         {
#           "start_time": "2021-01-01T09:00:00.000+01:00",
#           "end_time": "2021-01-01T10:00:00.000+01:00",
#           "meta": {
#             "doctor_id": 1
#           }
#         }
#       ],
#       "10:00 AM": [
#         {
#           "start_time": "2021-01-01T10:00:00.000+01:00",
#           "end_time": "2021-01-01T11:00:00.000+01:00",
#           "meta": {
#             "doctor_id": 1
#           }
#         },
#         {
#           "start_time": "2021-01-01T10:00:00.000+01:00",
#           "end_time": "2021-01-01T11:00:00.000+01:00",
#           "meta": {
#             "doctor_id": 2
#           }
#         }
#       ],
#       "11:00 AM": [
#         {
#           "start_time": "2021-01-01T11:00:00.000+01:00",
#           "end_time": "2021-01-01T12:00:00.000+01:00",
#           "meta": {
#             "doctor_id": 1
#           }
#         }
#       ]
#     },
#     "2021-01-02": {},
#     "2021-01-03": {}
#   }
# }
```

In this example, the first line adds a time slot from 9:00 AM to 12:00 PM on January 1st, 2021, and sets the doctor_id to 1. The second line adds a time slot from 10:00 AM to 11:00 AM on the same date, and sets the doctor_id to 2.

This allows you to manage multiple doctors availability on the same calendar and easily distinguish between their schedules.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at <https://github.com/haydenrou/slotty>. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Slotty project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/haydenrou/slotty/blob/master/CODE_OF_CONDUCT.md).
