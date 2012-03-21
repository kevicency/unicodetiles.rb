module UT
  class Viewport
    attr_accessor :renderer
    attr_accessor :top, :left
    attr_accessor :width, :height
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

    def clear
      @tiles = {}
    end

    def put_tile x, y, tile
      @tiles[[x,y]] = tile
    end

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

    def draw
      @tiles.each do |coords, tile|
        tleft = left + coords[0]*@renderer.tile_size
        ttop = top + coords[1]*@renderer.tile_size
        @renderer.render tile, tleft, ttop
      end
    end

    def render_width
      width * @renderer.tile_size
    end

    def render_height
      height * @renderer.tile_size
    end

    def center_x
      (width/2).floor
    end

    def center_y
      (height/2).floor
    end
  end
end
