require 'delivery_router'
require 'customer'
require 'restaurant'
require 'rider'

describe DeliveryRouter do
  context 'DeliveryRouter creation' do
    let(:rider_1) { Rider.new(id: 8, speed: 15, x: 2, y: 4) }
    let(:rider_2) { Rider.new(id: 3, speed: 15, x: 4, y: 6) }
    let(:cust_1) { Customer.new(id: 10, x: 8, y: 10) }
    let(:cust_2) { Customer.new(id: 9, x: 2, y: 4) }
    let(:rest_1) { Restaurant.new(id: 18, cooking_time: 15, x: 2, y: 4) }
    let(:rest_2) { Restaurant.new(id: 17, cooking_time: 25, x: 12, y: 14) }
    let(:restaurants) { [rest_1, rest_2] }
    let(:customers) { [cust_1, cust_2] }
    let(:riders) { [rider_1, rider_2] }

    let(:delivery_router) { DeliveryRouter.new(restaurants, customers, riders) }

    it 'should create a valid delivery_router' do
      expect(delivery_router).to be_an_instance_of(DeliveryRouter)
    end

    it 'should have attributes with proper data' do
      expect(delivery_router.restaurants.count).to eq(2)
      expect(delivery_router.customers.count).to eq(2)
      expect(delivery_router.riders.count).to eq(2)
      expect(delivery_router.orders).to be_empty
    end
    it 'should have working attributes' do
      expect(delivery_router.restaurants.sample).to be_an_instance_of(Restaurant)
      expect(delivery_router.customers.sample).to be_an_instance_of(Customer)
      expect(delivery_router.riders.sample).to be_an_instance_of(Rider)
    end
    it 'should call Order class' do
      # allow(DeliveryRouter.add_order).to receive(Order.new).with({customer: 1, restaurant: 3})
      allow(Order).to receive(:new).with(customer: 9, restaurant: 18).and_return(Order.new(customer: 9, restaurant: 18))
      delivery_router.add_order(customer: 9, restaurant: 18)
      expect(Order).to have_received(:new).with(customer: 9, restaurant: 18)
    end
  end

  describe "#route" do
    before(:all) do
      @customers = [
        Customer.new(:id => 1, :x => 1, :y => 1),
        Customer.new(:id => 2, :x => 5, :y => 1),
      ]
      @restaurants = [
        Restaurant.new(:id => 3, :cooking_time => 15, :x => 0, :y => 0),
        Restaurant.new(:id => 4, :cooking_time => 35, :x => 5, :y => 5),
      ]
      @riders = [
        Rider.new(:id => 1, :speed => 10, :x => 2, :y => 0),
        Rider.new(:id => 2, :speed => 10, :x => 1, :y => 0),
      ]
      @delivery_router = DeliveryRouter.new(@restaurants, @customers, @riders)
    end

    context "given customer 1 orders from restaurant 3" do
      before(:all) do
        @delivery_router.add_order(:customer => 1, :restaurant => 3)
      end

      context "given customer 2 does not order anything" do
        before(:all) do
          @delivery_router.clear_orders(:customer => 2)
        end

        it "does not assign a route to rider 1" do
          route = @delivery_router.route(:rider => 1)
          expect(route).to be_empty
        end

        it "sends rider 2 to customer 1 through restaurant 3" do
          route = @delivery_router.route(:rider => 2)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(3)
          expect(route[1].id).to eql(1)
        end

        it "delights customer 1" do
          expect(@delivery_router.delivery_time(:customer => 1)).to be < 60
        end
      end

      context "given customer 2 orders from restaurant 4" do
        before(:all) do
          @delivery_router.add_order(:customer => 2, :restaurant => 4)
        end

        it "sends rider 1 to customer 2 through restaurant 4" do
          route = @delivery_router.route(:rider => 1)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(4)
          expect(route[1].id).to eql(2)
        end

        it "sends rider 2 to customer 1 through restaurant 3" do
          route = @delivery_router.route(:rider => 2)
          expect(route.length).to eql(2)
          expect(route[0].id).to eql(3)
          expect(route[1].id).to eql(1)
        end

        it "delights customer 1" do
          expect(@delivery_router.delivery_time(:customer => 1)).to be < 60
        end

        it "delights customer 2" do
          expect(@delivery_router.delivery_time(:customer => 2)).to be < 60
        end
      end
    end
  end
end
