require "ducky/coordinate"

module Ducky

  class Player
    attr_accessor :location
    attr_reader :items

    def initialize
      @location = Coordinate.new(0, 0, 0)
      @items = []
    end

    def go( direction )
      exits = WORLD.exits_at( @location )

      if exits.include?( direction )
        puts "You go #{ direction.to_s }."
        @location = @location.send( direction )
        WORLD.describe_room( @location )
      else
        puts "You can't go that direction."
      end
    end
  end

end
