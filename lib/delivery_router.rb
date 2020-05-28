class DeliveryRouter
  attr_accessor :restaurants, :customers, :riders, :orders

  def initialize(restaurants, customers, riders)
    @orders = []
    @restaurants = restaurants
    @customers = customers
    @riders = riders
  end

  def add_order(order_options); end

  def clear_orders(order_options); end

  def route(order_options); end

  def delivery_time(order_options); end

end