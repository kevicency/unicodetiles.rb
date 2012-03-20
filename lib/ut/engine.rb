module UT
  class Engine
    attr_accessor :viewport, :world_height, :world_width

    def initialize options = {}
      @viewport = options[:viewport] || (raise ArgumentError.new "viewport is nil")
      @fetch_tile = options[:fetch_tile] || lambda {|x,y| NULLTILE }
      @cache = {}
    end

    def fetch_tile &blk
      @fetch_tile = blk
    end

    def update world_x, world_y
      x = world_x - @viewport.center_x
      y = world_y - @viewport.center_y

      @viewport.width.times do |xi|
        @viewport.height.times do |yi|
          tx, ty = x+xi, y+yi
          tile = @cache[[tx, ty]] if cache_enabled?
          tile ||= @fetch_tile.call tx, ty
          @cache[[tx, ty]] = tile if cache_enabled?
          @viewport.update_tile xi, yi, tile
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
