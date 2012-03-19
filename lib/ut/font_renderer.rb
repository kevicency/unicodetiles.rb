require 'gosu'

module UT
  class FontRenderer
    attr_accessor :tile_size

    def initialize options
      @window = options[:window] || $window
      @font_name = options[:font_name]
      @tile_size = options[:tile_size]
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

    def font
      @font
    end

    def render tile, left, top
      @window.draw_quad left          , top            , tile.background,
                        left+tile_size, top            , tile.background,
                        left          , top + tile_size, tile.background,
                        left+tile_size, top + tile_size, tile.background

      @font.draw_rel tile.glyph, left+tile_size/2, top+tile_size/2,
                     0, 0.5, 0.5, 1, 1, tile.foreground
    end

    private

    def reload_font
      @font = Gosu::Font.new(@window, @font_name, @tile_size)
    end
  end
end
