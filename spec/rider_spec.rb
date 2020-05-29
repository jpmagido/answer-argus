require 'rider'

describe Rider do
  context 'creation' do
    let(:rider) { Rider.new(id: 8, speed: 15, x: 2, y: 4) }

    it 'should create a valid rider' do
      expect(rider).to be_an_instance_of(Rider)
    end

    it 'should have an working attributes' do
      expect(rider.id).to eq(8)
      expect(rider.speed).to eq(15)
      expect(rider.val_x).to eq(2)
      expect(rider.val_y).to eq(4)
    end
  end
end
