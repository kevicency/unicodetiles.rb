require_relative 'helper'

class ExampleWindow < Gosu::Window
  attr_accessor :engine, :dungeon, :shader

  REPEAT = 250

  def initialize
    super WINDOW_WIDTH, WINDOW_HEIGHT, false
    @down_keys = {}
  end

  def update
    keys = [Gosu::KbW, Gosu::KbA, Gosu::KbS, Gosu::KbD]
    deltas = [[0,-1],[-1,0],[0,1],[1,0]]
    keys.each_with_index do |key, i|
      if button_down? key
        if @down_keys.include? key
          @down_keys[key] += update_interval
          if @down_keys[key] > REPEAT
            @dungeon.move_player deltas[i][0], deltas[i][1]
            @down_keys[key] -= REPEAT
          end
        else
          @dungeon.move_player deltas[i][0], deltas[i][1]
          @down_keys[key] = update_interval
        end
      else
        @down_keys.delete key
      end
    end
    engine.update @dungeon.px, @dungeon.py
    shader.center @dungeon.px, @dungeon.py unless shader.nil?
    shader.update update_interval unless shader.nil?
  end

  def draw
    draw_quad 0, 0, Gosu::Color::BLACK,
              width, 0, Gosu::Color::BLACK,
              0, height, Gosu::Color::BLACK,
              width, height, Gosu::Color::BLACK

    engine.viewport.draw
  end
end


