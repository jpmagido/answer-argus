class Rider
  attr_reader :id, :val_x, :val_y, :speed

  def initialize(options)
    @id = options[:id]
    @val_x = options[:x]
    @val_y = options[:y]
    @speed = options[:speed]
  end
end
