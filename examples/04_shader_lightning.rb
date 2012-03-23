# encoding: utf-8

require_relative '../lib/ut'
require_relative 'helper'
require_relative 'dungeon'
require_relative 'shader'
require_relative 'example_window'

$window = ExampleWindow.new

@dungeon = Dungeon.new
@shader = Shader.new
@renderer = UT::FontRenderer.new :font_name => "fonts/DejaVuSansMono.ttf", :tile_size => TILE_SIZE
@viewport = UT::Viewport.new :renderer => @renderer, :width => VIEWPORT_WIDTH, :height => VIEWPORT_HEIGHT
@engine = UT::Engine.new :viewport => @viewport, :world_width => @dungeon.width, :world_height => @dungeon.height
@engine.set_source do |x,y|
  @dungeon.get_tile x, y
end
@engine.set_mask do |x,y|
  @dungeon.is_visible? x, y
end
@engine.set_shader do |tile, x, y|
  @shader.apply tile, x, y
end

$window.dungeon = @dungeon
$window.shader = @shader
$window.engine = @engine
$window.show
