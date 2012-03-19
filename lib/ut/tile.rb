module UT

  NULLCHAR = " ";
  DEFAULT_FOREGROUND = Gosu::Color::WHITE
  DEFAULT_BACKGROUND = Gosu::Color::GRAY

  class Tile
    attr_accessor :glyph, :foreground, :background

    def initialize args = {}
      self.glyph      = args[:glyph] || NULLCHAR
      self.foreground = args[:foreground] || args[:fg] || DEFAULT_FOREGROUND
      self.background = args[:background] || args[:bg] || DEFAULT_BACKGROUND
    end

    def clone
      Tile.new :glyph          => glyph,
        :foreground  => foreground,
        :background  => background
    end
  end

  NULLTILE = Tile.new
end
