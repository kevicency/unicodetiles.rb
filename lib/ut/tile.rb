module UT
  # A *Tile* stores all attributes required by a *Viewport* to draw it.
  # `Tile.new` takes an `args` hash as its only parameter.
  # The `args` hash respects three members:
  #
  #   * `:glyph`: The unicode character. _Defaults to `' '`._
  #
  #   * `:foreground`: The foreground color represented by a `Gosu::Color`
  #   instance. _Defaults to `DEFAULT_FOREGROUND`._
  #
  #   * `:background`: The background color represented by a `Gosu::Color`
  #   instance. _Defaults to `DEFAULT_BACKGROUND`._
  class Tile
    # The unicode character
    attr_accessor :glyph
    # Foreground and background color of the *Tile*
    # Colors are stored as an instance of `Gosu::Color`
    attr_accessor :foreground, :background

    # The default foreground color is white
    DEFAULT_FOREGROUND = Gosu::Color::WHITE
    # the default background color is black
    DEFAULT_BACKGROUND = Gosu::Color::BLACK
    # An empty tile wih default fore- and background color
    NULL = Tile.new

    def initialize args = {}
      self.glyph      = args[:glyph] || " "
      self.foreground = args[:foreground] || DEFAULT_FOREGROUND
      self.background = args[:background] || DEFAULT_BACKGROUND
    end

    # Clones the tile by copying all attributes to a new *Tile*. Returns the
    # cloned tile.
    def clone
      Tile.new :glyph      => glyph,
               :foreground => foreground,
               :background => background
    end
  end
end
