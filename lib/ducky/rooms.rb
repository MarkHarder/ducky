require "ducky/items"
require "ducky/terminal_utilities"

module Ducky

  class Room
    attr_reader :description, :items

    def initialize( description )
      @description = description
      @items = []
    end

    def perform( command )
      if command.start_with?( "take" )
        item_name = command[5..-1]
        for item in @items
          if item.name == item_name
            puts "You take the #{ item_name }."
            taken_item = item
          end
        end

        unless taken_item.nil?
          @items.delete( taken_item )
          PLAYER.items.push( taken_item )
        end
      elsif command.start_with?( "drop" )
        item_name = command[5..-1]
        for item in PLAYER.items
          if item.name == item_name
            puts "You drop the #{ item_name }."
            dropped_item = item
          end
        end

        unless dropped_item.nil?
          PLAYER.items.delete( dropped_item )
          @items.push( dropped_item )
        end
      end
    end
  end

  class DungeonCellRoom < Room
    def initialize
      super( "You see a white skeleton and a pile of straw." )

      @coin_found = false
      @coin_taken = false
    end

    def perform( command )
      if command == "take coin"
        if @coin_found && !@coin_taken
          @coin_taken = true
          puts "You take the coin."
          PLAYER.items.push( Coin.new )
        else
          super( command )
        end
      elsif command.start_with?( "look at" )
        target = command[8..-1]

        if target == "skeleton"
          if @coin_taken
            puts TerminalUtilities.format( "The heap of bones look like the remains of a single person. There is nothing else remarkable about them." )
          else
            puts TerminalUtilities.format( "The heap of bones look like the remains of a single person. You see a shiny coin burried in the bones." )
            @coin_found = true
          end
        elsif target == "straw"
          puts "It is rough and looks dirty."
        elsif target == "coin"
          if @coin_found
            unless @coin_taken
              puts TerminalUtilities.format( "A thick gold coin. Possibly a Spanish dubloon." )
            else
              super( command )
            end
          end
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class DungeonRoom < Room
    def initialize
      super( "You see a white skeleton through the bars of a cell." )
    end

    def perform( command )
      if command.start_with?( "look at" )
        target = command[8..-1]

        if target == "skeleton"
          puts TerminalUtilities.format( "The heap of bones look like the remains of a single person." )
        elsif target == "straw"
          puts "It is rough and looks dirty."
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class RugRoom < Room
    def initialize
      super( "A thick, red rug strikes a bold difference to the cream-colored walls." )
    end

    def perform( command )
      if command.start_with?( "look at" )
        target = command[8..-1]

        if target == "rug"
          puts TerminalUtilities.format( "It is very soft and a rich red color." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class RopeRoom < Room
    def initialize
      super( "A rope is coiled onto the linoleum floor." )
    end

    def perform( command )
      if command == "take rope"
        if @description.include?( "rope" )
          puts "You take the rope."
          PLAYER.items.push( Rope.new )
          @description = "The linoleum floor shines bleakly in the light."
        else
          super( command )
        end
      elsif command.start_with?( "look at" )
        target = command[8..-1]

        if target == "rope"
          if @description.include?( "rope" )
            puts TerminalUtilities.format( "It is 10 meters of thick, coarse rope. You imagine it could be used for sailing." )
          else
            super( command )
          end
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class FootStatueRoom < Room
    def initialize
      super( "The only thing in this room is a large, alabaster statue of a foot." )
    end

    def perform( command )
      if command.start_with?( "look at" )
        target = command[8..-1]

        if target == "statue"
          puts TerminalUtilities.format( "With a sole larger than you, this statue is in the shape of a foot cut off at the ankle. The smooth, white surface is shining but on closer inspection you see some small worms crawling near the base." )
        elsif target == "worm"
          puts TerminalUtilities.format( "A cute, yellow inchworm." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class EntranceHall < Room
    def initialize
      super( "You are standing in a room with white walls and a single black door." )
    end

    def perform( command )
      if command.start_with?( "look at" )
        target = command[8..-1]

        if target == "door"
          puts TerminalUtilities.format( "The door is very dark and very locked. You must find the key to leave." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class VendingMachineRoom < Room
    def initialize
      super( "The walls of this room are white and a large, purple vending machine stands against one wall." )
    end

    def perform( command )
      if command.start_with?( "look at" )
        target = command[8..-1]

        if target == "vending machine"
          puts TerminalUtilities.format( "A fluorescently colored vending machine that only sells one type of soft drink." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class TowelRoom < Room
    def initialize
      super( "A stack of fluffy, yellow towels are sitting on a wooden cabinet." )

      @towel_taken = false
    end

    def perform( command )
      if command == "take towel"
        unless @towel_taken
          @towel_taken = true
          puts "You take a towel."
          PLAYER.items.push( Towel.new )
        else
          puts "You already have one."
        end
      elsif command.start_with?( "look at" )
        target = command[8..-1]

        if target == "towel"
          puts TerminalUtilities.format( "It is a thick, fluffy, yellow towel. Probably super moisture absorbant as well." )
          command = ""
        elsif target == "cabinet"
          puts TerminalUtilities.format( "It is a simple, heavyset cabinet with no drawers or compartments." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class BaseballRoom < Room
    def initialize
      super( "The walls are blue here and a baseball hat lies folded on the floor." )
    end

    def perform( command )
      if command == "take baseball hat"
        if @description.include?( "baseball" )
          puts "You take the baseball hat."
          PLAYER.items.push( BaseballHat.new )
          @description = "The walls are blue here."
        else
          super( command )
        end
      elsif command.start_with?( "look at" )
        target = command[8..-1]

        if target == "baseball hat"
          if @description.include?( "baseball" )
              puts TerminalUtilities.format( "It is a red, white, and blue baseball hat. It is comfortably flexible. If you had a mirror it would probably look quite nice on you." )
          else
            super( command )
          end
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class BrainRoom < Room
    def initialize
      super( "Resting on a pedestal is a brain in a jar." )
    end

    def perform( command )
      if command == "take jar"
        if @description.include?( "jar" )
          puts "You take the jar."
          PLAYER.items.push( Jar.new )
          @description = "You see a short, stone pedestal in the middle of the room."
        else
          super( command )
        end
      elsif command.start_with?( "look at" )
        target = command[8..-1]

        if target == "jar"
          if @description.include?( "jar" )
            puts TerminalUtilities.format( "It is a large, clear, glass jar with a metal lid. Inside floating in some clear liquid is a squishy-looking brain." )
          else
            super( command )
          end
        elsif target == "pedestal"
          puts TerminalUtilities.format( "A short pedestal made of white stone. It is perfect for holding up an object like a glass jar." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class HoleRoom < Room
    def initialize
      super( "There is a large hole in the wooden floor of this room." )
    end

    def perform( command )
      if command.start_with?( "look at" )
        target = command[8..-1]

        if target == "hole"
          puts TerminalUtilities.format( "It is large and dark. You can see straw below you." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class DungeonStairsRoom < Room
    def initialize
      super( "The walls and floor of this room are stone and a narrow stone staircase leads down." )
    end

    def perform( command )
      if command.start_with?( "look at" )
        target = command[8..-1]

        if target == "staircase"
          puts TerminalUtilities.format( "They are stone stairs. They down." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class GemRoom < Room
    def initialize
      super( "There is a gem on a pedestal here." )
    end

    def perform( command )
      if command == "take gem"
        if @description.include?( "gem" )
          puts "You take the gem."
          PLAYER.items.push( Gem.new )
          @description = "You see a short, stone pedestal in the middle of the room."
        else
          super( command )
        end
      elsif command.start_with?( "look at" )
        target = command[8..-1]

        if target == "gem"
          if @description.include?( "gem" )
            puts TerminalUtilities.format( "It is about the size of your thumb but it sparkles brilliantly in the light." )
          else
            super( command )
          end
        elsif target == "pedestal"
          puts TerminalUtilities.format( "A short pedestal made of white stone. It is perfect for holding up an object like a gem." )
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

  class NecklaceRoom < Room
    def initialize
      super( "A small wooden box has been left on the floor." )
      @necklace_found = false
      @necklace_taken = false
    end

    def perform( command )
      if command == "take necklace"
        if @necklace_found && !@necklace_taken
          @necklace_taken = true
          puts "You take the necklace."
          PLAYER.items.push( Necklace.new )
        else
          super( command )
        end
      elsif command.start_with?( "look at" )
        target = command[8..-1]

        if target == "box"
          if @necklace_taken
            puts TerminalUtilities.format( "It is a rectangular box. When you open the lid you see that it is empty." )
          else
            puts TerminalUtilities.format( "It is a rectangular box. When you open the lid you see a silver necklace." )
            @necklace_found = true
          end
        elsif target == "necklace"
          if @necklace_found
            unless @necklace_taken
              puts TerminalUtilities.format( "A fragile, silver necklace with a silver lion pendant." )
            else
              super( command )
            end
          end
        else
          super( command )
        end
      else
        super( command )
      end
    end
  end

end
