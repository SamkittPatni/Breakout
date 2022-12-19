VictoryState = Class{__includes = BaseState}

function VictoryState:enter(params)
  level1 = params.level
  self.score = params.score
  self.health = params.health
  self.paddle = params.paddle
  self.ball = params.ball
  self.highScores = params.highScores
end

function VictoryState:update(dt)
  self.paddle:update(dt)
  self.ball.x = (self.paddle.x) + (self.paddle.width / 2) - 4
  self.ball.y = self.paddle.y - 8
  if love.keyboard.wasPressed('space') then
    gStateMachine:change('serve', {
      level = level1 + 1,
      paddle = self.paddle,
      bricks = LevelMaker.createMap(level1 + 1),
      health = self.health,
      score = self.score,
      highScores = self.highScores
    })
  end
end

function VictoryState:render()
  self.paddle:render()
  self.ball:render()
  renderHealth(self.health)
  renderScore(self.score)
  love.graphics.setFont(gFonts['largefont'])
  love.graphics.printf("Level " .. tostring(level1) .. " complete!", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['mediumfont'])
  love.graphics.printf('Press Space to serve!', 0, VIRTUAL_HEIGHT / 2,VIRTUAL_WIDTH, 'center')
end
