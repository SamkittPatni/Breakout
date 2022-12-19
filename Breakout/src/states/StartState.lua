StartState = Class{__includes = BaseState}
local highlighted = 1

function StartState:enter(params)
  self.highScores = params.highScores
end

function StartState:update(dt)
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
  if love.keyboard.wasPressed('up') or love.keyboard.wasPressed('down') then
    highlighted = highlighted == 1 and 2 or 1
    gSounds['paddle-hit']:play()
  end
  if love.keyboard.wasPressed('space') then
    if highlighted == 1 then
      gStateMachine:change('paddle-select', {
        highScores = self.highScores
      })
    else
      gStateMachine:change('high-scores', {
        highScores = self.highScores
      })
    end
  end
end

function StartState:render()
  love.graphics.setFont(gFonts['largefont'])
  love.graphics.printf('Breakout', 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['mediumfont'])
  if highlighted == 1 then
    love.graphics.setColor(103/255, 255, 255, 255)
  end
  love.graphics.printf("START", 0, VIRTUAL_HEIGHT / 2 + 70, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(1, 1, 1, 1)
  if highlighted == 2 then
    love.graphics.setColor(103/255, 255, 255, 255)
  end
  love.graphics.printf("HIGH SCORES", 0, VIRTUAL_HEIGHT / 2 + 90, VIRTUAL_WIDTH, 'center')
  love.graphics.setColor(1, 1, 1, 1)
end