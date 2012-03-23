# encoding: utf-8

require_relative '../lib/ut'
require_relative 'helper'
require_relative 'forest'
require_relative 'example_window'

$window = ExampleWindow.new

@forest = Forest.new
@renderer = UT::FontRenderer.new :font_name => "fonts/DejaVuSansMono.ttf", :tile_size => TILE_SIZE, :scale_x => SCALE_X, :scale_y => SCALE_Y
@viewport = UT::Viewport.new :renderer => @renderer, :width => VIEWPORT_WIDTH, :height => VIEWPORT_HEIGHT
@engine = UT::Engine.new :viewport => @viewport
@engine.set_source do |x,y|
  @forest.get_tile x, y
end
@engine.set_mask do |x,y|
  @forest.is_visible? x, y
end

$window.dungeon = @forest
$window.engine = @engine
$window.show
