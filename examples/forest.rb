#encoding: utf-8
require_relative "fov"

class Forest
  include ShadowcastingFieldOfView

  attr_reader :px, :py

  GRASS = UT::Tile.new :glyph => ".", :foreground => Gosu::Color.new(0xFF509650)
  GRASS2 = UT::Tile.new :glyph => ".", :foreground => Gosu::Color.new(0xFF5AFA5A)
  TREE = UT::Tile.new :glyph => "☘", :foreground => Gosu::Color.new(0xFF146414)
  ROCK = UT::Tile.new :glyph => "☁", :foreground => Gosu::Color.new(0xFF646464)
  AT = UT::Tile.new :glyph => "@", :foreground => Gosu::Color.new(0xFFFFFFFF)

  def initialize
    @px = 0
    @py = 0
    update_fov
  end

  def get_tile x, y
    return AT if x == @px && y == @py
    r = deterministic_rand x, y
    return TREE if (r > 0.80)
    return ROCK if (r > 0.75)
    return GRASS2  if (r > 0.50)
    return GRASS;
  end

  def move_player dx, dy
    destination = get_tile @px+dx, @py+dy
    if destination.glyph == "."
      @px,@py = @px+dx, @py+dy
      update_fov
    end
  end

  def is_visible? x, y
    @mask[[x,y]] || false
  end

  private

  def update_fov
    @mask = {}
    do_fov @px, @py, 13
  end

  def blocked? x, y
    return (get_tile x, y).glyph != "."
  end

  def light x, y
    @mask[[x,y]] = true
  end

  A = 2971215073
  B = 479001599
  M = 1048573;

  def deterministic_rand x, y
    num = ((A*x)^(B*y)) % M;
    return num.to_f / M;
  end
end
