require 'journey'

describe Journey do
  subject(:journey) { described_class.new }
  let(:entry_station) { instance_double("Station") }
  let(:exit_station) { instance_double("Station") }
  let(:entry_zone) { 3 }
  let(:exit_zone) { 5 }

  describe "#initialize" do
    it 'with empty entry' do
      expect(journey.entry_station).to be_nil
    end

    it 'with empty exit' do
      expect(journey.exit_station).to be_nil
    end
  end

  describe "#start" do
    it 'inserts the entry station' do
      journey.start(entry_station)
      expect(journey.entry_station).to eq entry_station
    end
  end

  describe "#finish" do
    it 'inserts the exit station' do
      journey.finish(exit_station)
      expect(journey.exit_station).to eq exit_station
    end
  end

  describe "#complete?" do
    it 'checks journey is complete' do
      journey.start(entry_station)
      journey.finish(exit_station)
      expect(journey).to be_complete
    end
  end

  describe '#fare' do
    context 'calculates fare' do
      before do
        journey.start(entry_station)
        journey.finish(exit_station)
      end
      
      it 'within the same zone' do
        allow(entry_station).to receive(:zone) { 3 }
        allow(exit_station).to receive(:zone) { 3 }
        expect(journey.fare).to eq described_class::MIN_FARE
      end

      it 'across different zones' do
        allow(entry_station).to receive(:zone) { entry_zone }
        allow(exit_station).to receive(:zone) { exit_zone }
        expect(journey.fare).to eq(described_class::MIN_FARE + (entry_zone - exit_zone).abs)
      end
    end

    it 'returns penalty when not touched out' do
      journey.start(entry_station)
      expect(journey.fare).to eq described_class::PENALTY_FARE
    end

    it 'returns penalty when not touched in' do
      journey.finish(exit_station)
      expect(journey.fare).to eq described_class::PENALTY_FARE
    end
  end

end
