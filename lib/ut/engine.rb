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
      self.world_width = options[:world_width]
      self.world_height = options[:world_height]
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
      return NULLTILE unless in_world? x, y
      return NULLTILE unless is_visible? x, y

      tile = @cache[[x, y]] if cache_enabled?
      tile ||= @source.call x, y
      @cache[[x, y]] = tile if cache_enabled?
      apply_shader tile, x ,y
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
          @viewport.put_tile xi, yi, tile
        end
      end
    end

    def cache_enabled?
      @cache_enabled
    end

    def cache_enabled= value
      @cache_enabled = value
    end

    def clear_cache
      @cache = {}
    end


    def in_world? x, y
      result = true
      unless world_width.nil?
        result &&= (x >= 0 && x < world_width)
      end
      unless world_height.nil?
        result &&= (y >= 0 && y< world_height)
      end
      result
    end
  end
end
