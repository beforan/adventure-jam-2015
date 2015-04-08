local theme = {}

local fonts = {
  chivo = {
    [16] = love.graphics.newFont("assets/fonts/Chivo-Regular.ttf", 16)
  },
  chivoblack = {
    [18] = love.graphics.newFont("assets/fonts/Chivo-Black.ttf", 18),
    [38] = love.graphics.newFont("assets/fonts/Chivo-Black.ttf", 38)
  }
}

theme.fonts = {
  verbLine = fonts.chivo[16],
  verbButton = fonts.chivoblack[38],
  actorSay = fonts.chivoblack[18]
}

theme.colors = {
  button = {
    back = {
      normal = { 3, 17, 31, 255 },
      hover = { 6, 39, 69, 255 }
    },
    text = {
      normal = { 0, 119, 255, 255 },
      hover = { 101, 173, 255, 255 }
    }
  }
  --verbLine = {}
}

return theme