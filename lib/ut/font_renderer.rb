module UT
  # The *FontRenderer* uses the `Gosu::Font` class to draw the tiles on a
  # `Gosu::Window`.
  # `FontRenderer.new` takes an `options` hash as its only parameter.
  # The `options` hash respects three members:
  #
  #   * `:window`: The `Gosu::Window`. _Defaults to `$window`._
  #
  #   * `:font_name`: Specifies the name of the font. Accepts the same values
  #   as `Gosu::Font.new`. _Defaults to `nil`._
  #
  #   * `:tile_size`: The size of the tile on screen in _pixels_. Equivalent to the font
  #   size. _Default to `0`_.
  #
  #   * `:scale_x`: Scales the font horizontally by this factor to reduce
  #   spacing between the chars. _Default to 1_.
  #
  #   * `:scale_y`: Scales the font vertically by this factor to reduce spacing
  #   between the chars. _Defaults to 1_.
  class FontRenderer
    attr_accessor :tile_size

    def initialize options
      @window = options[:window] || $window
      @font_name = options[:font_name]
      @tile_size = options[:tile_size] || 0
      @scale_x = options[:scale_x] || 1
      @scale_y = options[:scale_y] || 1
      reload_font
    end

    def tile_size
      @tile_size
    end

    def tile_size= value
      @tile_size = value
      reload_font
    end

    def font_name= value
      @font_name = value
      reload_font
    end

    def font_name
      @font_name
    end

    # The `Gosu::Font` instance used for drawing the tiles
    def font
      @font
    end

    # Renders the `tile` width the top-left corner at `[left,top]` on the
    # `window`
    def render tile, left, top
      @window.draw_quad left          , top            , tile.background,
        left+tile_size, top            , tile.background,
        left          , top + tile_size, tile.background,
        left+tile_size, top + tile_size, tile.background

      @font.draw_rel tile.glyph,
                     left+tile_size/2, top+tile_size/2,
                     0, 0.5, 0.5,
                     @scale_x, @scale_y,
                     tile.foreground
    end

    private

    def reload_font
      @font = Gosu::Font.new(@window, @font_name, @tile_size)
    end
  end
end
