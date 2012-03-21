# encoding: utf-8

require_relative '../lib/ut'
require_relative 'helper'
require_relative 'forest'
require 'set'

class Window < Gosu::Window
  attr_accessor :engine, :forest

  def initialize width, height
    super width, height, false
    @down_keys = Set.new
  end

  def update
    keys = [Gosu::KbW, Gosu::KbA, Gosu::KbS, Gosu::KbD]
    deltas = [[0,-1],[-1,0],[0,1],[1,0]]
    keys.each_with_index do |key, i|
      if button_down? key
        unless @down_keys.include? key
          forest.move_player deltas[i][0], deltas[i][1]
          @down_keys << key
        end
      else
        @down_keys.delete key
      end
    end
    engine.update forest.px, forest.py
  end

  def draw
    draw_quad 0, 0, Gosu::Color::BLACK,
              width, 0, Gosu::Color::BLACK,
              0, height, Gosu::Color::BLACK,
              width, height, Gosu::Color::BLACK

    engine.viewport.draw
  end
end

$window = Window.new WINDOW_WIDTH, WINDOW_HEIGHT

@forest = Forest.new
@renderer = UT::FontRenderer.new :font_name => "fonts/DejaVuSansMono.ttf", :tile_size => TILE_SIZE
@viewport = UT::Viewport.new :renderer => @renderer, :width => VIEWPORT_WIDTH, :height => VIEWPORT_HEIGHT
@engine = UT::Engine.new :viewport => @viewport
@engine.set_source do |x,y|
  @forest.get_tile x, y
end
@engine.set_mask do |x,y|
  @forest.is_visible? x, y
end

$window.forest = @forest
$window.engine = @engine
$window.show
