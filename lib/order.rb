class Order
  attr_accessor :duration, :rider
  attr_reader :customer, :restaurant

  def initialize(options)
    @customer = options[:customer]
    @restaurant = options[:restaurant]
  end
end