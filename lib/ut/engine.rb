module UT

  # The *Engine* is responsible for fetching the relevant *Tile*s from the
  # `source` and checking its visibility with the `mask`. The *Tile*s are also
  # passed to the `shader` before being finally passed to the *Viewport*.
  # `Enigne.new` takes an `options` hash as its only parameter.
  # The `options` hash respects three members:
  #
  #   * `:source`: The source used to fetch tiles. _Defaults to `DEFAULT_SOURCE`_.
  #
  #   * `:mask`: The mask used to determine a tile's visiblity. _Defaults to
  #   `DEFAULT_MASK`_.
  #
  #   * `:shader`: The shader to preprocess tiles. _Defaults to
  #   `DEFAULT_SOURCE`_.
  #
  #   * `:viewport`: The *Viewport* used for rendering.
  #
  #   * `:world_width`: The width of the world. _Default to `nil`_.
  #
  #   * `:world_height`: The height of the world. _Defaults to `nil`_.
  class Engine
    # The default shader. Just returns the tile it gets.
    DEFAULT_SHADER = lambda {|tile,x,y| tile}
    # The default tile source. Always return `Tile::NULL`
    DEFAULT_SOURCE = lambda {|x,y| Tile::NULL}
    # The default mask. Always returns `true`.
    DEFAULT_MASK = lambda {|x,y| true}

    # The *Viewport* used for rendering
    attr_accessor :viewport
    # The width and height of the world. *Tile*s 'outside' of the world are
    # not passed to the *Viewport* for rendering.
    # If the `world_width` and `world_height` are `nil`, the world is infinte
    # and all tiles are rendered.
    attr_accessor :world_height, :world_width

    def initialize options = {}
      @source = options[:source] || DEFAULT_SOURCE
      @mask = options[:mask] || DEFAULT_MASK
      @shader = options[:shader] || DEFAULT_SHADER
      self.viewport = options[:viewport]
      self.world_width = options[:world_width]
      self.world_height = options[:world_height]
      @cache = {}
    end

    # Takes a block that accepts a `tile`, `x` and `y` and stores it as the
    # shader function.
    def set_shader &blk
      @shader = blk || DEFAULT_SHADER
    end

    # Takes a *Proc* or *lambda* which accepts a `tile`, `x` and `y` and stores
    # it as the shader function.
    def set_shader= shader
      @shader = shader || DEFAULT_SHADER
    end

    # Takes a block that accepts `x` and `y` and stores it as the
    # source function.
    def set_source &blk
      @source = blk || DEFAULT_SOURCE
    end

    # Takes a *Proc* or *lambda* which accepts a `x` and `y` and stores
    # it as the source function.
    def set_source= source
      @source = source || DEFAULT_SOURCE
    end

    # Takes a block that accepts `x` and `y` and stores it as the
    # mask function.
    def set_mask &blk
      @mask = blk || DEFAULT_MASK
    end

    # Takes a *Proc* or *lambda* which accepts a `x` and `y` and stores
    # it as the mask function.
    def set_mask= mask
      @mask = mask || DEFAULT_MASK
    end

    # Fetches the *Tile* at location `[x,y]` from the source
    def fetch x, y
      return nil unless in_world? x, y
      return nil unless is_visible? x, y

      tile = @cache[[x, y]] if cache_enabled?
      tile ||= @source.call x, y
      @cache[[x, y]] = tile if cache_enabled?
      apply_shader tile, x ,y
    end

    # Applies the shader to the `tile` at `[x,y]`
    def apply_shader tile, x, y
      @shader.call tile, x, y
    end

    # Determines the visibility of the *Tile* at `[x,y]`
    def is_visible? x, y
      @mask.call x, y
    end

    # Updates the *Engine*. `world_x` and `world_y` represents the center of the
    # world that should be rendered in _tile coordinates_.
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

    # Checks if the cache is enabled.
    def cache_enabled?
      @cache_enabled
    end

    # Enables or disables the cache.
    def cache_enabled= value
      @cache_enabled = value
    end

    # Clears the cache.
    def clear_cache
      @cache = {}
    end

    # Checks if a location is in the world.
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
