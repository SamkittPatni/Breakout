paletteColors = {
    [1] = {
        ['r'] = 99/255,
        ['g'] = 155/255,
        ['b'] = 255/255
    },
    [2] = {
        ['r'] = 106/255,
        ['g'] = 190/255,
        ['b'] = 47/255
    },
    [3] = {
        ['r'] = 217/255,
        ['g'] = 87/255,
        ['b'] = 99/255
    },
    [4] = {
        ['r'] = 215/255,
        ['g'] = 123/255,
        ['b'] = 186/255
    },
    [5] = {
        ['r'] = 251/255,
        ['g'] = 242/255,
        ['b'] = 54/255
    }
}
Brick = Class{}
function Brick:init(x, y)
  self.tier = 1
  self.colour = 1
  self.x = x
  self.y = y
  self.width = 32
  self.height = 16
  self.inPlay = true
  self.psystem = love.graphics.newParticleSystem(gTextures['particle'], 64)
  self.psystem:setParticleLifetime(0.5, 1)
  self.psystem:setLinearAcceleration(-15, 0, 15, 80)
  self.psystem:setEmissionArea('normal', 10, 10)
end
function Brick:hit()
  self.psystem:setColors(
    paletteColors[self.colour].r,
    paletteColors[self.colour].g,
    paletteColors[self.colour].b,
    55 * (self.tier - 1),
    paletteColors[self.colour].r,
    paletteColors[self.colour].g,
    paletteColors[self.colour].b,
    0
  )
  self.psystem:emit(64)
  gSounds['brick-hit-2']:stop()
  gSounds['brick-hit-2']:play()
  if self.tier > 1 then
    self.tier = self.tier - 1
  else
    self.inPlay = false
  end
  if not self.inPlay then
    gSounds['brick-hit-1']:stop()
    gSounds['brick-hit-1']:play()
  end
end
function Brick:render()
  if self.inPlay then
    love.graphics.draw(gTextures['blocks'], gFrames['bricks'][self.tier], self.x, self.y) --+ ((self.colour - 1) * 4) + self.tier], self.x, self.y)
  end
end

function Brick:renderParticles()
    love.graphics.draw(self.psystem, self.x + 16, self.y + 8)
end
