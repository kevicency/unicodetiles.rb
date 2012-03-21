class Shader
  attr_accessor :light_color, :light_intensity, :max_dist

  def initialize options = {}
    self.light_color = options[:light_color] || Gosu::Color.new(0xFFFF2F00)
    self.light_intensity = options[:light_intensity] || 0.7
    self.max_dist = options[:max_dist] || 5
    @time = 0
    @x = 0
    @y = 0
  end

  def apply tile, x, y
    anim = @time/1000.0
    anim = (anim - anim.floor - 0.5).abs + 0.5
    dist = distance @x, @y, x, y
    return tile if dist > max_dist
    factor = (1.0 - (dist / max_dist)) * light_intensity * anim
    r = (blend light_color.red, tile.foreground.red, factor).round
    g = (blend light_color.green, tile.foreground.green, factor).round
    b = (blend light_color.blue, tile.foreground.blue, factor).round
    argb = Integer("0xFF%02X%02X%02X" % [r, g, b])
    shaded = tile.clone
    shaded.foreground = Gosu::Color.new argb
    shaded
  end

  def update delta
    @time += delta
  end

  def center x, y
    @x, @y = x, y
  end

  private

  def distance x1, y1, x2, y2
    Math.sqrt((x2-x1)**2 + (y2-y1)**2)
  end

  def blend a, b, f
    a*f + b*(1.0-f)
  end
end
