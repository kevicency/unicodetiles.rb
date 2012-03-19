module UT
  class Viewport
    attr_accessor :renderer
    attr_accessor :top, :left
    attr_accessor :width, :height

    def initialize options={}
      self.renderer = options[:renderer]
      self.left = options[:left] || 0
      self.top = options[:top] || 0
      self.width = options[:width]
      self.height = options[:height]

      @tiles = {}
    end

    def clear
      @tiles = {}
    end

    def update_tile x, y, tile
      @tiles[[x,y]] = tile
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
      height * tile_size
    end

    def center_x
      (width/2).floor
    end

    def center_y
      (height/2).floor
    end
  end
end
