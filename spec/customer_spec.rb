require 'customer'

describe Customer do
  context 'creation' do
    let(:customer) { Customer.new(id: 9, x: 2, y: 4) }

    it 'should create a valid customer' do
      expect(customer).to be_an_instance_of(Customer)
    end

    it 'should have an working attributes' do
      expect(customer.id).to eq(9)
      expect(customer.val_x).to eq(2)
      expect(customer.val_y).to eq(4)
    end
  end
end