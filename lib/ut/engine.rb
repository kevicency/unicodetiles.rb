module UT
  class Engine
    attr_accessor :viewport, :world_height, :world_width

    def initialize options = {}
      @viewport = options[:viewport] || (raise ArgumentError.new "viewport is nil")
      @resolve_tile = options[:resolve_tile] || lambda {|x,y| NULLTILE }
    end

    def to_resolve_tile &blk
      @resolve_tile = blk
    end

    def resolve_tile x, y
      @resolve_tile.call x, y
    end

    def update world_x, world_y
      x = world_x - @viewport.center_x
      y = world_y - @viewport.center_y

      @viewport.width.times do |xi|
        @viewport.height.times do |yi|
          @viewport.update_tile xi, yi, (@resolve_tile.call x+xi,y+yi)
        end
      end
    end
  end
end
