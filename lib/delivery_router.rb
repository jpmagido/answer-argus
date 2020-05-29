class DeliveryRouter
  attr_accessor :restaurants, :customers, :riders, :orders

  def initialize(restaurants, customers, riders)
    @orders = []
    @restaurants = restaurants
    @customers = customers
    @riders = riders
  end

  def add_order(order_options)
    @orders << order_options
    add_driver
    add_duration
  end

  def clear_orders(order_options)
    @orders.each do |order|
      order.clear if order[:customer] == order_options[:customer]
    end
  end


  def route(rider_id)
    return [] if @orders.detect { |o| o[:rider] == rider_id[:rider] }.nil?
    order = @orders.detect { |o| o[:rider] == rider_id[:rider] }
    restaurant = @restaurants.detect { |r| r.id == order[:restaurant] }
    customer = @customers.detect { |c| c.id == order[:customer] }
    [restaurant, customer]
  end

  def delivery_time(cust_id)
    @orders.detect { |o| o[:customer] = cust_id[:customer] }[:duration]
  end

  private

  def add_driver
    @orders.each do |order|
      rest = @restaurants.detect { |r| r.id == order[:restaurant] }
      order[:rider] = @riders.min_by { |rider|
        distance(
          {x: rest.val_x, y: rest.val_y},
          {x: rider.val_x, y: rider.val_y}
        )
      }.id
    end
  end

  def add_duration
    @orders.each do |o|
      o[:duration] = 0
      restaurant = @restaurants.detect { |r| r.id == o[:restaurant] }
      rider = @riders.detect { |r| r.id == o[:rider] }
      customer = @customers.detect { |c| c.id == o[:customer] }
      cooking_time = restaurant.cooking_time
      o[:duration] += cooking_time
      dist = distance({x: restaurant.val_x, y: restaurant.val_y}, {x: customer.val_x, y: customer.val_y})
      o[:duration] += dist * 60 / rider.speed
    end
  end

  def distance(a, b)
    distance_x = (a[:x] - b[:x]).abs
    distance_y = (a[:y] - b[:y]).abs
    Math.sqrt(distance_x ** 2 + distance_y ** 2)
  end
end
