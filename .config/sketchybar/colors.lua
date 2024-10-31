return {
  black = 0xff181819,
  white = 0xffe2e2e3,
  red = 0xfffc5d7c,
  green = 0xff9ed072,
  blue = 0xff76cce0,
  yellow = 0xffe7c664,
  orange = 0xfff39660,
  magenta = 0xffb39df3,
  grey = 0xff7f8490,
  transparent = 0x00000000,
  borderpink = 0xFFE6BEBF,

  bar = {
    bg = 0xff000000,
    border = 0xFFE6BEBF,
  },
  popup = {
    bg = 0xFF1E1E2E,
    border = 0xFFE6BEBF,
  },
  bg1 = 0xFF1E1E2E,
  bg2 = 0xFF1E1E2E,

  with_alpha = function(color, alpha)
    if alpha > 1.0 or alpha < 0.0 then return color end
    return (color & 0x00ffffff) | (math.floor(alpha * 255.0) << 24)
  end,
}
