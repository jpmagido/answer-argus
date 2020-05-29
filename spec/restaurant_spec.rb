require 'restaurant'

describe Restaurant do
  context 'creation' do
    let(:restaurant) { Restaurant.new(id: 18, cooking_time: 15, x: 2, y: 4) }

    it 'should create a valid restaurant' do
      expect(restaurant).to be_an_instance_of(Restaurant)
    end

    it 'should have an working attributes' do
      expect(restaurant.id).to eq(18)
      expect(restaurant.cooking_time).to eq(15)
      expect(restaurant.val_x).to eq(2)
      expect(restaurant.val_y).to eq(4)
    end
  end
end