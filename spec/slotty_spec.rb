RSpec.describe Slotty do
  it "gets relevant slots" do
    attributes = {
      for_range: Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 9, 30),
      slot_length_mins: 60,
      interval_mins: 15,
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
      for_range: Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 11, 00),
      slot_length_mins: 60,
      interval_mins: 15,
      exclude_times: [
        Time.new(2020, 05, 01, 9, 00)..Time.new(2020, 05, 01, 10, 00)
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

  it "gets relevant slots without excluded times x2" do
    attributes = {
      for_range: Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 18, 00),
      slot_length_mins: 45,
      interval_mins: 15,
      exclude_times: [
        Time.new(2020, 05, 01, 9, 00)..Time.new(2020, 05, 01, 13, 00),
        Time.new(2020, 05, 01, 14, 00)..Time.new(2020, 05, 01, 16, 00)
      ]
    }

    expected_slots = [
      {
        start_time: Time.new(2020, 05, 01, 8, 00),
        end_time: Time.new(2020, 05, 01, 8, 45),
        time: "08:00 AM"
      },
      {
        start_time: Time.new(2020, 05, 01, 8, 15),
        end_time: Time.new(2020, 05, 01, 9, 00),
        time: "08:15 AM"
      },
      {
        start_time: Time.new(2020, 05, 01, 13, 00),
        end_time: Time.new(2020, 05, 01, 13, 45),
        time: "01:00 PM"
      },
      {
        start_time: Time.new(2020, 05, 01, 13, 15),
        end_time: Time.new(2020, 05, 01, 14, 00),
        time: "01:15 PM"
      },
      {
        start_time: Time.new(2020, 05, 01, 16, 00),
        end_time: Time.new(2020, 05, 01, 16, 45),
        time: "04:00 PM"
      },
      {
        start_time: Time.new(2020, 05, 01, 16, 15),
        end_time: Time.new(2020, 05, 01, 17, 00),
        time: "04:15 PM"
      },
      {
        start_time: Time.new(2020, 05, 01, 16, 30),
        end_time: Time.new(2020, 05, 01, 17, 15),
        time: "04:30 PM"
      },
      {
        start_time: Time.new(2020, 05, 01, 16, 45),
        end_time: Time.new(2020, 05, 01, 17, 30),
        time: "04:45 PM"
      },
      {
        start_time: Time.new(2020, 05, 01, 17, 00),
        end_time: Time.new(2020, 05, 01, 17, 45),
        time: "05:00 PM"
      },
      {
        start_time: Time.new(2020, 05, 01, 17, 15),
        end_time: Time.new(2020, 05, 01, 18, 00),
        time: "05:15 PM"
      },
    ]

    expect(Slotty.get_slots(attributes)).to eq(expected_slots)
  end

  it "gets no slots" do
    attributes = {
      for_range: Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 8, 45),
      slot_length_mins: 60,
      interval_mins: 15,
    }

    expected_slots = []

    expect(Slotty.get_slots(attributes)).to eq(expected_slots)
  end

  it "gets one slot" do
    attributes = {
      for_range: Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 9, 00),
      slot_length_mins: 60,
      interval_mins: 15,
    }

    expected_slots = [{
      start_time: Time.new(2020, 05, 01, 8, 00),
      end_time: Time.new(2020, 05, 01, 9, 00),
      time: "08:00 AM"
    }]

    expect(Slotty.get_slots(attributes)).to eq(expected_slots)
  end

  it "expects invalid range to raise error" do
    expect { Slotty.get_slots({ for_range: 1, slot_length_mins: 3, interval_mins: 3 }) }.to raise_error(Slotty::InvalidDateError, "for_value must be type of Range")
    expect { Slotty.get_slots({ for_range: (Time.now..(Time.now + 60 * 60)), slot_length_mins: "", interval_mins: 3 }) }.to raise_error(Slotty::InvalidSlotLengthError, "slot_length_mins must be an integer")
    expect { Slotty.get_slots({ for_range: Time.now..(Time.now + 60 * 60), slot_length_mins: 3, interval_mins: "" }) }.to raise_error(Slotty::InvalidIntervalError, "interval_mins must be an integer")
    expect { Slotty.get_slots({ for_range: Time.now..(Time.now + 60 * 60), slot_length_mins: 3, interval_mins: 3, exclude_times: 2 }) }.to raise_error(Slotty::InvalidExclusionError, "exclude_times must be an array of time ranges")
    expect { Slotty.get_slots({ for_range: Time.now..(Time.now + 60 * 60), slot_length_mins: 3, interval_mins: 3, exclude_times: [], as: :wrong }) }.to raise_error(Slotty::InvalidFormatError, "cannot format slot in this way")
  end

  it "relevants slots even if slot runs over the end" do
    attributes = {
      for_range: Time.new(2020, 05, 01, 8, 00)..Time.new(2020, 05, 01, 9, 30),
      slot_length_mins: 60,
      interval_mins: 15,
      allow_slot_run_over: true,
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
      {
        start_time: Time.new(2020, 05, 01, 8, 45),
        end_time: Time.new(2020, 05, 01, 9, 45),
        time: "08:45 AM"
      },
      {
        start_time: Time.new(2020, 05, 01, 9, 00),
        end_time: Time.new(2020, 05, 01, 10, 00),
        time: "09:00 AM"
      },
      {
        start_time: Time.new(2020, 05, 01, 9, 15),
        end_time: Time.new(2020, 05, 01, 10, 15),
        time: "09:15 AM"
      },
    ]

    expect(Slotty.get_slots(attributes)).to eq(expected_slots)
  end
end

