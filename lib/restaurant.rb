class Restaurant
  attr_reader :id, :val_x, :val_y, :cooking_time

  def initialize(options)
    @id = options[:id]
    @val_x = options[:x]
    @val_y = options[:y]
    @cooking_time = options[:cooking_time]
  end
end
