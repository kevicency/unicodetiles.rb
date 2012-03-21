module UT

  class Tile
    attr_accessor :glyph, :foreground, :background

    DEFAULT_FOREGROUND = Gosu::Color::WHITE
    DEFAULT_BACKGROUND = Gosu::Color::BLACK
    NULL = Tile.new

    def initialize args = {}
      self.glyph      = args[:glyph] || " "
      self.foreground = args[:foreground] || DEFAULT_FOREGROUND
      self.background = args[:background] || DEFAULT_BACKGROUND
    end

    def clone
      Tile.new :glyph      => glyph,
        :foreground => foreground,
        :background => background
    end
  end
end
