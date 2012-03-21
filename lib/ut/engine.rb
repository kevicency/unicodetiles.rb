module UT
  class Engine
    DEFAULT_SHADER = lambda {|tile,x,y| tile}
    DEFAULT_SOURCE = lambda {|x,y| NULLTILE}
    DEFAULT_MASK = lambda {|x,y| true}

    attr_accessor :viewport, :world_height, :world_width

    def initialize options = {}
      @source = options[:source] || DEFAULT_SOURCE
      @mask = options[:mask] || DEFAULT_MASK
      @shader = options[:shader] || DEFAULT_SHADER
      self.viewport = options[:viewport]
      @cache = {}
    end

    def set_shader &blk
      @shader = blk || DEFAULT_SHADER
    end

    def set_shader= shader
      @shader = shader || DEFAULT_SHADER
    end

    def set_source &blk
      @source = blk || DEFAULT_SOURCE
    end

    def set_source= source
      @source = source || DEFAULT_SOURCE
    end

    def set_mask &blk
      @mask = blk || DEFAULT_MASK
    end

    def set_mask= mask
      @mask = mask || DEFAULT_MASK
    end

    def fetch x, y
      tile = @cache[[x, y]] if cache_enabled?
      tile ||= @source.call x, y
      @cache[[x, y]] = tile if cache_enabled?
      tile
    end

    def apply_shader tile, x, y
      @shader.call tile, x, y
    end

    def is_visible? x, y
      @mask.call x, y
    end

    def update world_x, world_y
      x = world_x - @viewport.center_x
      y = world_y - @viewport.center_y

      @viewport.width.times do |xi|
        @viewport.height.times do |yi|
          tx, ty = x+xi, y+yi
          tile = fetch tx, ty
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
