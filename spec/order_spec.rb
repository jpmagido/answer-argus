require 'order'

describe Order do
  context 'creation' do
    let(:order) { Order.new(customer: 9, restaurant: 2) }

    it 'should create a valid customer' do
      expect(order).to be_an_instance_of(Order)
    end

    it 'should have an working attributes' do
      expect(order.customer).to eq(9)
      expect(order.restaurant).to eq(2)
    end
  end
end