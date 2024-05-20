# Slotty
[![Rubocop](https://github.com/haydenrou/slotty/actions/workflows/rubocop.yml/badge.svg)](https://github.com/haydenrou/slotty/actions/workflows/rubocop.yml/badge.svg)
[![Rspec](https://github.com/haydenrou/slotty/actions/workflows/rspec.yml/badge.svg)](https://github.com/haydenrou/slotty/actions/workflows/rspec.yml/badge.svg)

Slotty provides a way of determining available slots within a time frame. An example would be where a service provider needs to take bookings.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slotty'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install slotty

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

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/haydenrou/slotty. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Slotty project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/haydenrou/slotty/blob/master/CODE_OF_CONDUCT.md).
