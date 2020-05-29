require 'order'

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
    @orders << Order.new(order_options)
    add_driver
    add_duration
  end

  def clear_orders(order_options)
    @orders.each do |order|
      order.clear if order.customer == order_options[:customer]
    end
  end

  def route(rider_id)
    return [] if @orders.detect { |o| o.rider == rider_id[:rider] }.nil?
    order = @orders.detect { |o| o.rider == rider_id[:rider] }
    restaurant = @restaurants.detect { |r| r.id == order.restaurant }
    customer = @customers.detect { |c| c.id == order.customer }
    [restaurant, customer]
  end

  def delivery_time(cust_id)
    @orders.detect { |o| o.customer == cust_id[:customer] }.duration
  end

  private

  def add_driver
    @orders.each do |order|
      rest = @restaurants.detect { |r| r.id == order.restaurant }
      order.rider = @riders.min_by { |rider|
        distance({x: rest.val_x, y: rest.val_y},
                 {x: rider.val_x, y: rider.val_y})
      }.id
    end
  end

  def add_duration
    @orders.each do |o|
      restaurant = @restaurants.detect { |r| r.id == o.restaurant }
      rider = @riders.detect { |r| r.id == o.rider }
      customer = @customers.detect { |c| c.id == o.customer }

      duration_rest_cust = distance({x: restaurant.val_x, y: restaurant.val_y},
                                    {x: customer.val_x, y: customer.val_y}) * 60 / rider.speed
      duration_rider_rest = distance({x: rider.val_x, y: rider.val_y},
                                     {x: restaurant.val_x, y: restaurant.val_y}) * 60 / rider.speed
      o.duration = 0
      o.duration += restaurant.cooking_time
      o.duration += duration_rest_cust
      o.duration += (duration_rider_rest - restaurant.cooking_time) if duration_rider_rest > restaurant.cooking_time
    end
  end

  def distance(pt_a, pt_b)
    distance_x = (pt_a[:x] - pt_b[:x]).abs
    distance_y = (pt_a[:y] - pt_b[:y]).abs
    Math.sqrt(distance_x ** 2 + distance_y ** 2)
  end
end
