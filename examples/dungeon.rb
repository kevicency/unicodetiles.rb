#encoding: utf-8
require_relative 'fov'

class Dungeon
  include ShadowcastingFieldOfView
  attr_reader :px, :py

  AT_TILE = UT::Tile.new :glyph => "@"
  WALL_TILE = UT::Tile.new :glyph => "▒", :foreground => Gosu::Color.new(0xFF646464)
  FLOOR_TILE = UT::Tile.new :glyph => ".", :foreground => Gosu::Color.new(0xFF323232)

  def initialize
    @px = 3
    @py = 2
    @map = [
      " #####             #####      ",
      " #...########      #...####   ",
      " #..........#      #......#   ",
      " #...######.#      #..###.#   ",
      " #####    #.#      ######.####",
      "          #.#          #.....#",
      "          #.#          #.....#",
      "          #.############.....#",
      "          #..................#",
      "          ####.###############",
      "##########   #.#     #....#   ",
      "#........##  #.#     #.#..#   ",
      "#..####...#  #.#     #.#..#   ",
      "#.........#  #.#     #.###### ",
      "#.........#  #.#     #......# ",
      "##.########  #.#     #......# ",
      " #.#         #.#     #####.## ",
      " #.#         #.#         #.#  ",
      " #.#   #######.#         #.#  ",
      " #.#   #.......#         #.#  ",
      " #.#   #.....#.#         #.#  ",
      " #.#   #.....#.#         #.#  ",
      " #.#   #.....#.#         #.#  ",
      " #.#   #.....#.#         #.#  ",
      " #.#   #######.#         #.#  ",
      " #.#         #.###########.#  ",
      " #.#         #.............#  ",
      " #.#############.###########  ",
      " #...............#            ",
      " #################            "
    ]
    update_fov
  end

  def width
    @map[0].length
  end

  def height
    @map.length
  end

  def get_tile x, y
    return nil if x<0 || y<0
    return AT_TILE if x==@px && y==@py

    char = @map[y][x]
    case char
    when "."
      FLOOR_TILE
    when "#"
      WALL_TILE
    else
      UT::NULLTILE
    end
  rescue
    nil
  end

  def move_player dx, dy
    destination = get_tile @px+dx, @py+dy
    if destination == FLOOR_TILE
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
    do_fov @px, @py, 7
  end

  def blocked? x, y
    return true if x < 0 || y < 0
    return @map[y][x] == "#"
  end

  def light x, y
    @mask[[x,y]] = true
  end
end
