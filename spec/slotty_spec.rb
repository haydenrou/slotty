# frozen_string_literal: true

RSpec.describe Slotty do # rubocop:disable Metrics/BlockLength
  it 'gets relevant slots' do
    attributes = {
      for_range: Time.new(2020, 0o5, 0o1, 8, 0o0)..Time.new(2020, 0o5, 0o1, 9, 30),
      slot_length_mins: 60,
      interval_mins: 15
    }

    expected_slots = [
      {
        start_time: Time.new(2020, 0o5, 0o1, 8, 0o0),
        end_time: Time.new(2020, 0o5, 0o1, 9, 0o0),
        time: '08:00 AM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 8, 15),
        end_time: Time.new(2020, 0o5, 0o1, 9, 15),
        time: '08:15 AM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 8, 30),
        end_time: Time.new(2020, 0o5, 0o1, 9, 30),
        time: '08:30 AM'
      }
    ]

    expect(Slotty.get_slots(**attributes)).to eq(expected_slots)
  end

  it 'gets relevant slots without excluded times' do
    attributes = {
      for_range: Time.new(2020, 0o5, 0o1, 8, 0o0)..Time.new(2020, 0o5, 0o1, 11, 0o0),
      slot_length_mins: 60,
      interval_mins: 15,
      exclude_times: [
        Time.new(2020, 0o5, 0o1, 9, 0o0)..Time.new(2020, 0o5, 0o1, 10, 0o0)
      ]
    }

    expected_slots = [
      {
        start_time: Time.new(2020, 0o5, 0o1, 8, 0o0),
        end_time: Time.new(2020, 0o5, 0o1, 9, 0o0),
        time: '08:00 AM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 10, 0o0),
        end_time: Time.new(2020, 0o5, 0o1, 11, 0o0),
        time: '10:00 AM'
      }
    ]

    expect(Slotty.get_slots(**attributes)).to eq(expected_slots)
  end

  it 'gets relevant slots without excluded times x2' do # rubocop:disable Metrics/BlockLength
    attributes = {
      for_range: Time.new(2020, 0o5, 0o1, 8, 0o0)..Time.new(2020, 0o5, 0o1, 18, 0o0),
      slot_length_mins: 45,
      interval_mins: 15,
      exclude_times: [
        Time.new(2020, 0o5, 0o1, 9, 0o0)..Time.new(2020, 0o5, 0o1, 13, 0o0),
        Time.new(2020, 0o5, 0o1, 14, 0o0)..Time.new(2020, 0o5, 0o1, 16, 0o0)
      ]
    }

    expected_slots = [
      {
        start_time: Time.new(2020, 0o5, 0o1, 8, 0o0),
        end_time: Time.new(2020, 0o5, 0o1, 8, 45),
        time: '08:00 AM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 8, 15),
        end_time: Time.new(2020, 0o5, 0o1, 9, 0o0),
        time: '08:15 AM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 13, 0o0),
        end_time: Time.new(2020, 0o5, 0o1, 13, 45),
        time: '01:00 PM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 13, 15),
        end_time: Time.new(2020, 0o5, 0o1, 14, 0o0),
        time: '01:15 PM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 16, 0o0),
        end_time: Time.new(2020, 0o5, 0o1, 16, 45),
        time: '04:00 PM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 16, 15),
        end_time: Time.new(2020, 0o5, 0o1, 17, 0o0),
        time: '04:15 PM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 16, 30),
        end_time: Time.new(2020, 0o5, 0o1, 17, 15),
        time: '04:30 PM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 16, 45),
        end_time: Time.new(2020, 0o5, 0o1, 17, 30),
        time: '04:45 PM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 17, 0o0),
        end_time: Time.new(2020, 0o5, 0o1, 17, 45),
        time: '05:00 PM'
      },
      {
        start_time: Time.new(2020, 0o5, 0o1, 17, 15),
        end_time: Time.new(2020, 0o5, 0o1, 18, 0o0),
        time: '05:15 PM'
      }
    ]

    expect(Slotty.get_slots(**attributes)).to eq(expected_slots)
  end

  it 'gets no slots' do
    attributes = {
      for_range: Time.new(2020, 0o5, 0o1, 8, 0o0)..Time.new(2020, 0o5, 0o1, 8, 45),
      slot_length_mins: 60,
      interval_mins: 15
    }

    expected_slots = []

    expect(Slotty.get_slots(**attributes)).to eq(expected_slots)
  end

  it 'gets one slot' do
    attributes = {
      for_range: Time.new(2020, 0o5, 0o1, 8, 0o0)..Time.new(2020, 0o5, 0o1, 9, 0o0),
      slot_length_mins: 60,
      interval_mins: 15
    }

    expected_slots = [{
      start_time: Time.new(2020, 0o5, 0o1, 8, 0o0),
      end_time: Time.new(2020, 0o5, 0o1, 9, 0o0),
      time: '08:00 AM'
    }]

    expect(Slotty.get_slots(**attributes)).to eq(expected_slots)
  end

  it 'expects invalid range to raise error' do
    expect do
      Slotty.get_slots(for_range: 1, slot_length_mins: 3,
                       interval_mins: 3)
    end.to raise_error(Slotty::InvalidDateError, 'for_value must be type of Range')
    expect do
      Slotty.get_slots(for_range: (Time.now..(Time.now + 60 * 60)), slot_length_mins: '',
                       interval_mins: 3)
    end.to raise_error(Slotty::InvalidSlotLengthError, 'slot_length_mins must be an integer')
    expect do
      Slotty.get_slots(for_range: Time.now..(Time.now + 60 * 60), slot_length_mins: 3,
                       interval_mins: '')
    end.to raise_error(Slotty::InvalidIntervalError, 'interval_mins must be an integer')
    expect do
      Slotty.get_slots(for_range: Time.now..(Time.now + 60 * 60), slot_length_mins: 3, interval_mins: 3,
                       exclude_times: 2)
    end.to raise_error(Slotty::InvalidExclusionError, 'exclude_times must be an array of time ranges')
    expect do
      Slotty.get_slots(for_range: Time.now..(Time.now + 60 * 60), slot_length_mins: 3, interval_mins: 3,
                       exclude_times: [],
                       as: :wrong)
    end.to raise_error(Slotty::InvalidFormatError, 'cannot format slot in this way')
  end
end
