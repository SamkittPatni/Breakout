HighScoreState = Class{__includes = BaseState}

function HighScoreState:enter(params)
  self.highScores = params.highScores
end

function HighScoreState:update(dt)
  if love.keyboard.wasPressed('escape') then
    gSounds['wall-hit']:play()
    gStateMachine:change('start', {
      highScores = self.highScores
    })
  end
end

function HighScoreState:render()
  love.graphics.setFont(gFonts['largefont'])
  love.graphics.printf("High Scores", 0, 20, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['mediumfont'])
  for i = 1, 10 do
    local name = self.highScores[i].name or '---'
    local score = self.highScores[i].score or '---'
    love.graphics.printf(tostring(i) .. '.', 20, 60 + i * 13, 50, 'left')
    love.graphics.printf(name, VIRTUAL_WIDTH / 3, 60 + i * 13, 50, 'right')
    love.graphics.printf(tostring(score), VIRTUAL_WIDTH / 3, 60 + i * 13, VIRTUAL_WIDTH, 'center')
  end
  love.graphics.setFont(gFonts['smallfont'])
  love.graphics.printf("Press escape to return to the main menu!", 0, VIRTUAL_HEIGHT - 18, VIRTUAL_WIDTH, 'center')
end
