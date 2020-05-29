class Customer
  attr_accessor :id, :val_x, :val_y

  def initialize(options)
    @id = options[:id]
    @val_x = options[:x]
    @val_y = options[:y]
  end
end
