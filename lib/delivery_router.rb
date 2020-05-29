class DeliveryRouter
  attr_accessor :orders
  attr_reader :restaurants, :customers, :riders

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
      o[:duration] += restaurant.cooking_time
      dist_rest_cust = distance({x: restaurant.val_x, y: restaurant.val_y}, {x: customer.val_x, y: customer.val_y})
      o[:duration] += dist_rest_cust * 60 / rider.speed
      dist_rider_rest = distance({x: rider.val_x, y: rider.val_y},{x: restaurant.val_x, y: restaurant.val_y})
      time_rider_rest = dist_rider_rest * 60 / rider.speed
      if time_rider_rest > restaurant.cooking_time
        o[:duration] += (time_rider_rest - restaurant.cooking_time)
      end
    end
  end

  def distance(a, b)
    distance_x = (a[:x] - b[:x]).abs
    distance_y = (a[:y] - b[:y]).abs
    Math.sqrt(distance_x ** 2 + distance_y ** 2)
  end
end
