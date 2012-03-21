require_relative '../lib/ut'
require 'set'

class Window < Gosu::Window
  attr_accessor :engine

  def initialize width, height
    super width, height, false
    @down_keys = Set.new
    @px = 0
    @py = 0
  end

  def update
    keys = [Gosu::KbW, Gosu::KbA, Gosu::KbS, Gosu::KbD]
    deltas = [[0,-1],[-1,0],[0,1],[1,0]]
    keys.each_with_index do |key, i|
      if button_down? key
        unless @down_keys.include? key
          @px += deltas[i][0]
          @py += deltas[i][1]
        end
      else
        @down_keys.delete key
      end
    end
    engine.update @px, @py
  end

  def draw
    engine.viewport.draw
  end
end

$window = Window.new 48*14, 48*10

#@renderer = UT::FontRenderer.new :font_name => "Consolas", :tile_size => 24
@renderer = UT::FontRenderer.new :font_name => "fonts/DejaVuSansMono.ttf", :tile_size => 48
@viewport = UT::Viewport.new :renderer => @renderer, :width => 14, :height => 10
@engine = UT::Engine.new :viewport => @viewport
@engine.set_source do |x,y|
  UT::Tile.new :glyph => (x%3+y%3==0?"#":" "), :background => Gosu::Color.from_hsv((x+y)%360,1,1)
end
$window.engine = @engine
$window.show
