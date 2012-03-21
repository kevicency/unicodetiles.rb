#encoding: utf-8

class Dungeon
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
  end

  def width
    @map[0].length
  end

  def height
    @map.length
  end

  def get_tile x,y
    return UT::NULLTILE if x<0 || y<0
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
    UT::NULLTILE
  end

  def move_player dx, dy
    destination = get_tile @px+dx, @py+dy
    @px,@py = @px+dx, @py+dy if destination == FLOOR_TILE
  end
end
