require 'journey_log'

describe JourneyLog do

  let(:journey_class) { Journey }
  let(:oystercard) { instance_double("Oystercard") }
  let(:entry_station) { instance_double("Station") }
  let(:exit_station) { instance_double("Station") }
  subject(:journey_log) { described_class.new(journey_class, oystercard) }

  before(:each) do
    allow(oystercard).to receive(:deduct)
    allow(entry_station).to receive(:zone) { 2 }
    allow(exit_station).to receive(:zone) { 2 }
  end


  describe "#initialize" do
    context "testing #new on class" do
      subject(:journey_log_class) { described_class }
      it { is_expected.to respond_to(:new).with(2).arguments }
    end
    it "has a journey_class" do
      expect(journey_log.journey_class).to eq Journey
    end
    it "has an empty journeys array" do
      expect(journey_log.journeys).to be_empty
    end
    it 'initializes with empty current journey' do
      expect(journey_log.current_journey).to be_nil
    end
  end

  describe "#start" do
    it "creates a @current_journey" do
      journey_log.start(entry_station)
      expect(journey_log.current_journey).to be_a(Journey)
    end
    context "with incomplete journey" do
      it "raises no error" do
        expect{journey_log.start(entry_station)}.not_to raise_error
      end
    end
  end

  describe "#finish" do
    it "increases journeys count by 1" do
      expect{journey_log.finish(exit_station)}.to change{journey_log.journeys.count}.by 1
    end
    it 'stores a journey in journeys' do
      journey_log.finish(exit_station)
      expect(journey_log.journeys[-1]).to be_a(Journey)
    end
    context "with no current journey" do
      it 'raises no error' do
        expect{journey_log.finish(exit_station)}.not_to raise_error
      end
    end

    it 'deducts fare from balance' do
      journey_log.start(entry_station)
      allow(entry_station).to receive(:zone).and_return(2)
      allow(exit_station).to receive(:zone).and_return(3)
      expect { journey_log.finish(exit_station) }.not_to raise_error
    end

  end

end
