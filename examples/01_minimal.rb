# encoding: utf-8

require_relative '../lib/ut'
require_relative 'helper'
require 'set'


class Window < Gosu::Window
  attr_accessor :viewport

  def initialize width, height
    super width, height, false
  end

  def draw
    viewport.draw
  end
end

$window = Window.new WINDOW_WIDTH, WINDOW_HEIGHT

@renderer = UT::FontRenderer.new :font_name => "fonts/DejaVuSansMono.ttf", :tile_size => TILE_SIZE
@viewport = UT::Viewport.new :renderer => @renderer, :width => VIEWPORT_WIDTH, :height => VIEWPORT_HEIGHT
@viewport.put_string 0, 0, "Hello World !", Gosu::Color::CYAN
@viewport.put_string 0, 1, "Some unicode chars:", Gosu::Color::GREEN, Gosu::Color::GRAY
%W{☠ ☃ ⚙ ☻ ♞ ☭ ✈ ✟ ✂ ✯}.each_with_index do |c,i|
  @viewport.put_tile i, 2, (UT::Tile.new :glyph => c, :foreground => Gosu::Color.from_hsv(c.ord%360, 1, 1))
end
@viewport.put_string 14, 4, "Long strings get automatically wrapped as block"
@viewport.put_string 13, 7, "or as a line if u want", nil, nil, :line
@viewport.put_string 20, 9, "or not at all", nil, nil, :none

$window.viewport = @viewport
$window.show
