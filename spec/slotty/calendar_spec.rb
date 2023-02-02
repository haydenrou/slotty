require 'spec_helper'

require "active_support/all"

RSpec.describe Slotty::Calendar do
  describe '#initialize' do
    context 'when date is a Date' do
      it 'sets the date to the provided date' do
        date = Date.new(2021, 01, 01)
        calendar = Slotty::Calendar.new(date)
        expect(calendar.instance_variable_get(:@date)).to eq(date)
      end
    end

    context 'when date is a DateTime' do
      it 'sets the date to the provided date' do
        date = DateTime.new(2021, 01, 01)
        calendar = Slotty::Calendar.new(date)
        expect(calendar.instance_variable_get(:@date)).to eq(date.to_date)
      end
    end

    context 'when date is a string' do
      it 'sets the date to the provided date' do
        date = '2021-01-01'
        calendar = Slotty::Calendar.new(date)
        expect(calendar.instance_variable_get(:@date)).to eq(Date.parse(date))
      end
    end

    context 'when date is not provided' do
      it 'sets the date to the current date' do
        calendar = Slotty::Calendar.new
        expect(calendar.instance_variable_get(:@date)).to eq(Date.current)
      end
    end

    context 'when options are provided' do
      it 'sets the interval_mins and slot_length_mins with the provided options' do
        options = { interval_mins: 30, slot_length_mins: 30 }
        calendar = Slotty::Calendar.new(nil, options)
        expect(calendar.instance_variable_get(:@interval_mins)).to eq(30)
        expect(calendar.instance_variable_get(:@slot_length_mins)).to eq(30)
      end
    end

    context 'when options are not provided' do
      it 'sets the default interval_mins and slot_length_mins' do
        calendar = Slotty::Calendar.new
        expect(calendar.instance_variable_get(:@interval_mins)).to eq(60)
        expect(calendar.instance_variable_get(:@slot_length_mins)).to eq(60)
      end
    end

    it 'initializes availabilities to an empty array' do
      calendar = Slotty::Calendar.new
      expect(calendar.instance_variable_get(:@availabilities)).to eq([])
    end
  end

  describe '#add_availability' do
    let(:calendar) { described_class.new }
    let(:start_time) { Time.new(2023, 01, 01, 9, 0) }
    let(:end_time) { Time.new(2023, 01, 01, 13, 0) }
    let(:range) { start_time..end_time }
    let(:meta) { { foo: 'bar' } }

    context 'when range is valid' do
      it 'adds availability to availabilities array' do
        calendar.add_availability(range, meta)
        expect(calendar.availabilities).to eq([[range, meta]])
      end
    end

    context 'when range is invalid' do
      it 'raises InvalidDateError' do
        expect { calendar.add_availability('invalid_range', meta) }.to raise_error(Slotty::InvalidDateError)
      end
    end
  end

  describe '#weekly' do
    let(:date) { Date.today }
    let(:calendar) { described_class.new(date) }

    let(:start_time) { Time.new(2023, 01, 01, 9, 0) }
    let(:end_time) { Time.new(2023, 01, 01, 13, 0) }
    let(:range) { start_time..end_time }
    let(:meta) { { foo: 'bar' } }

    before do
      calendar.add_availability(range, meta)
    end

    it 'returns the availability slots for the current week' do
      weekly_slots = calendar.weekly
      expect(weekly_slots[:starts_at]).to eq(date.beginning_of_week.beginning_of_day)
      expect(weekly_slots[:ends_at]).to eq(date.end_of_week.end_of_day)
    end

    it 'returns the correct dates in the :slots hash' do
      weekly_slots = calendar.weekly
      expect(weekly_slots[:slots].keys).to match_array((date.beginning_of_week..date.end_of_week).map { |d| d.to_s })
    end
  end

  describe '#monthly' do
    let(:date) { Date.today }
    let(:calendar) { described_class.new(date) }

    let(:start_time) { Time.new(2023, 01, 01, 9, 0) }
    let(:end_time) { Time.new(2023, 01, 01, 13, 0) }
    let(:range) { start_time..end_time }
    let(:meta) { { foo: 'bar' } }

    before do
      calendar.add_availability(range, meta)
    end

    it 'returns the availability slots for the current month' do
      monthly_slots = calendar.monthly
      expect(monthly_slots[:starts_at]).to eq(date.beginning_of_month.beginning_of_day)
      expect(monthly_slots[:ends_at]).to eq(date.end_of_month.end_of_day)
    end

    it 'returns the correct dates in the :slots hash' do
      monthly_slots = calendar.monthly
      expect(monthly_slots[:slots].keys).to match_array((date.beginning_of_month..date.end_of_month).map { |d| d.to_s })
    end
  end

  describe '#previous_month' do
    let(:date) { Date.parse('2023-02-02') }
    let(:calendar) { described_class.new(date) }

    it 'returns the previous month availabilities' do
      prev_month_availabilities = calendar.previous_month
      expect(prev_month_availabilities.date).to eq(date.beginning_of_month - 1.month)
    end
  end

  describe '#next_month' do
    let(:date) { Date.parse('2023-02-02') }
    let(:calendar) { described_class.new(date) }

    it 'returns the next month availabilities' do
      next_month_availabilities = calendar.next_month
      expect(next_month_availabilities.date).to eq(date.end_of_month + 1.day)
    end
  end

  describe '#previous_week' do
    let(:date) { Date.parse('2023-02-02') }
    let(:calendar) { described_class.new(date) }

    it 'returns the previous week availabilities' do
      prev_week_availabilities = calendar.previous_week
      expect(prev_week_availabilities.date).to eq(date.beginning_of_week - 7.days)
    end
  end

  describe '#next_week' do
    let(:date) { Date.parse('2023-02-02') }
    let(:calendar) { described_class.new(date) }

    it 'returns the next week availabilities' do
      next_week_availabilities = calendar.next_week
      expect(next_week_availabilities.date).to eq(date.end_of_week + 1.day)
    end
  end
end
