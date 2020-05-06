RSpec.describe Slotty do
  it "gets relevant slots" do
    attributes = {
      from: Time.new(2020, 05, 01, 8, 00),
      to: Time.new(2020, 05, 01, 9, 30),
      slot_length: 60 * 60,
      timeframe: 15 * 60,
    }

    expected_slots = [
      {
        start_time: Time.new(2020, 05, 01, 8, 00),
        end_time: Time.new(2020, 05, 01, 9, 00),
        time: "08:00 AM"
      },
      {
        start_time: Time.new(2020, 05, 01, 8, 15),
        end_time: Time.new(2020, 05, 01, 9, 15),
        time: "08:15 AM"
      },
      {
        start_time: Time.new(2020, 05, 01, 8, 30),
        end_time: Time.new(2020, 05, 01, 9, 30),
        time: "08:30 AM"
      },
    ]

    expect(Slotty.get_slots(attributes)).to eq(expected_slots)
  end

  it "gets relevant slots without excluded times" do
    attributes = {
      from: Time.new(2020, 05, 01, 8, 00),
      to: Time.new(2020, 05, 01, 11, 00),
      slot_length: 60 * 60,
      timeframe: 15 * 60,
      exclude_times: [
        { start: Time.new(2020, 05, 01, 9, 01), end: Time.new(2020, 05, 01, 9, 59) },
      ]
    }

    expected_slots = [
      {
        start_time: Time.new(2020, 05, 01, 8, 00),
        end_time: Time.new(2020, 05, 01, 9, 00),
        time: "08:00 AM"
      },
      {
        start_time: Time.new(2020, 05, 01, 10, 00),
        end_time: Time.new(2020, 05, 01, 11, 00),
        time: "10:00 AM"
      },
    ]

    expect(Slotty.get_slots(attributes)).to eq(expected_slots)
  end
end
