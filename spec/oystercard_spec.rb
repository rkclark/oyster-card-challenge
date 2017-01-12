require 'oystercard'
require 'journey'

describe Oystercard do
  subject(:oystercard) { described_class.new }
  let(:entry_station) { instance_double("Station") }
  let(:exit_station) { instance_double("Station") }
  let(:journey) { instance_double("Journey") }
  let(:journey_log) { instance_double("JourneyLog") }

  min_journey_balance = Journey::MIN_FARE
  penalty_fare = Journey::PENALTY_FARE

  describe "#initialize" do
    it 'creates an empty journey_log' do
      allow(journey_log).to receive(:journeys) { [] }
      expect(oystercard.journey_log.journeys).to be_empty
    end
    it 'creates a balance of 0' do
      expect(oystercard.balance).to eq 0
    end
  end

  describe "#top_up" do
    it 'tops up by a given amount' do
      expect(oystercard.top_up(10)).to eq oystercard.balance
    end

    it 'throws error if balance exceeds 90' do
      maximum_bal = described_class::MAX_BALANCE
      expect{ oystercard.top_up(91) }.to raise_error("Balance cannot exceed #{maximum_bal}")
    end
  end

  describe "#deduct" do
    it 'deducts a given amount' do
      expect {oystercard.deduct(15)}.to change{oystercard.balance}.by -15
    end
  end

  describe "#touch_in" do
    context "with insufficient balance" do
      it "raises error" do
        message = "Cannot touch in, you do not have sufficient balance!"
        oystercard.top_up(min_journey_balance - 0.01)
        expect{oystercard.touch_in(entry_station)}.to raise_error(RuntimeError, message)
      end
    end
  end

  describe "#touch_out" do
    it 'calls #start on journey_log' do
      oystercard.top_up(min_journey_balance+ 10)
      oystercard.touch_in(entry_station)
      allow(journey_log).to receive(:finish)
      allow(entry_station).to receive(:zone).and_return(2)
      allow(exit_station).to receive(:zone).and_return(3)
      expect {oystercard.touch_out(exit_station)}.not_to raise_error
    end
  end
end
