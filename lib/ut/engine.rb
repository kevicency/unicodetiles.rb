module UT
  class Engine
    attr_accessor :viewport, :world_height, :world_width

    def initialize options = {}
      @viewport = options[:viewport] || (raise ArgumentError.new "viewport is nil")
      @resolve_tile = options[:resolve_tile] || lambda {|x,y| NULLTILE }
    end

    def resolve_tile &blk
      @resolve_tile = blk
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

    def cache_enabled?
      @cache_enabled
    end

    def cache_enabled= value
      @cache_enabled = value
    end
  end
end
