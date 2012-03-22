module UT

  # The *viewport* stores the *Tile*s that should be drawn onto the screen as well
  # as their location on the screen.
  # `Viewport.new` takes an `options` hash as its only parameter.
  # The `options` hash respects three members:
  #
  #   * `:renderer`: The renderer that renders the tiles. _Defaults to `nil`._
  #
  #   * `:left`: Specifies the horizontal offset in _pixels_ from the left side
  #   of the screen. _Defaults to 0_.
  #
  #   * `:top`: Specifies the vertical offset in _pixels_ from the top of the
  #   screen. _Defaults to 0_.
  #
  #   * `:width`: The width of the *Viewport* in _tiles_.
  #
  #   * `:height`: The height of the *Viewport* in _tiles_.
  #
  #   * `:wrap_mode`: The wrap mode for strings. _Defaults to `:block`_.
  class Viewport
    # The renderer used to draw the tiles on screen.
    # Must repond to:
    #
    #   * `tile_size`: Returns the size of the rendered tile in _pixel_.
    #
    #   * `render(tile, left, top)`: Renders the `tile` on screen with the
    #   top-left corner of the tile located at `[left, top]`.
    attr_accessor :renderer
    # Coordinates of the top-left corner of the *Viewport*.
    attr_accessor :top, :left
    # Width and height of the viewport measured in _tiles_.
    attr_accessor :width, :height
    # A flag which tells the *Viewport* how to handle strings that are longer
    # than `width`. Accepts the following values:
    #
    #   * `:line`: Wraps the string into the next line and starts at the
    #   beginning of the line.
    #   * `:block`: Wraps the string into the next line and starts at the same
    #   x-coordinate.
    #   * `:none`: No wrapping of strings
    attr_accessor :wrap_mode

    def initialize options={}
      self.renderer = options[:renderer]
      self.left = options[:left] || 0
      self.top = options[:top] || 0
      self.width = options[:width]
      self.height = options[:height]
      self.wrap_mode = options[:wrap_mode] || :block

      @tiles = {}
    end

    # Clears all tiles in the *Viewport*
    def clear
      @tiles = {}
    end

    # Stores the `tile` at location `[x,y]`
    def put_tile x, y, tile
      if tile.nil?
        @tiles.delete [x,y]
      else
        @tiles[[x,y]] = tile
      end
    end

    # Puts a `string` into the *Viewport* by creating a tile for each character
    # and storing them in a line starting at `[x,y]`. The tiles colors can be
    # specified by `foreground` and `background`. `wrap_mode` overrides the
    # global `wrap_mode` of the *Viewport*.
    def put_string x, y, string, foreground = nil, background = nil, wrap_mode = nil
      counter = 0
      string.each_char do |c|
        tx, ty = case wrap_mode || self.wrap_mode
                 when :block
                   [x+counter%(width-x), y+(counter/(width-x)).floor]
                 when :line
                   [(x+counter)%width, ty = y+((x+counter)/width).floor]
                 else
                   [x + counter, y]
                 end
        put_tile tx, ty, (Tile.new :glyph => c,
                          :foreground => foreground,
                          :background => background)
        counter += 1;
      end
    end

    # Draws the tiles onto the screen using the `renderer`
    def draw
      @tiles.each do |coords, tile|
        tleft = left + coords[0]*@renderer.tile_size
        ttop = top + coords[1]*@renderer.tile_size
        @renderer.render tile, tleft, ttop
      end
    end

    # The width of the *Viewport* on the screen in _pixels_.
    def render_width
      width * @renderer.tile_size
    end

    # The height of the *Viewport* on the screen in _pixels_.
    def render_height
      height * @renderer.tile_size
    end

    # The x-coordinate of the center of the *Viewport* in _tiles_.
    def center_x
      (width/2).floor
    end

    # The y-coordinate of the center of the *Viewport* in _tiles_.
    def center_y
      (height/2).floor
    end
  end
end
