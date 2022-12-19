GameOverState = Class{__includes = BaseState}

function GameOverState:enter(params)
  self.score = params.score
  self.highScores = params.highScores
end

function GameOverState:update(dt)
  if love.keyboard.wasPressed('space') then
    local highScore = false
    local highScoreIndex = 11
    for i = 10, 1, -1 do
      local score = self.highScores[i].score or 0
      if self.score > score then
        highScoreIndex = i
        highScore = true
      end
    end
    if highScore then
      gSounds['high-score']:play()
      gStateMachine:change('enter-high-scores', {
        highScores = self.highScores,
        score = self.score,
        scoreIndex = highScoreIndex
      })
    else
      gStateMachine:change('start', {
        highScores = self.highScores
      })
    end
  end
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end

function GameOverState:render()
  love.graphics.setFont(gFonts['largefont'])
  love.graphics.printf("GAME OVER!", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['mediumfont'])
  love.graphics.printf("SCORE: " .. tostring(self.score), 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
  love.graphics.printf("Press space!", 0, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
end
