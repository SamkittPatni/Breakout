PowerUp = Class{}
function PowerUp:init(skin, brick)
  self.width = 16
  self.height = 16
  self.dx = 0
  self.dy = 60
  self.skin = skin
  self.x = brick.x + 8
  self.y = brick.y + 16
  self.remove = false
end

function PowerUp:collides(target)
  if self.x > target.x + target.width or self.x + self.width < target.x then
    return false
  end
  if self.y > target.y + target.height or self.y + self.height < target.y then
    return false
  end
  return true
end

function PowerUp:update(dt)
  self.y = self.y + self.dy * dt
  if self.y > VIRTUAL_HEIGHT then
    self.remove = true
  end
end

function PowerUp:render()
  love.graphics.draw(gTextures['powerups'], gFrames['powerups'][self.skin], self.x, self.y)
end
