ServeState = Class{__includes = BaseState}
function ServeState:enter(params)
  self.paddle = params.paddle
  self.health = params.health
  self.score = params.score
  self.bricks = params.bricks
  self.level = params.level
  self.highScores = params.highScores
  self.ball = Ball()
  self.ball.skin = math.random(7)
  if self.ball.skin == 5 then
    self.ball.skin = 2
  end
end
function ServeState:update(dt)
  self.paddle:update(dt)
  self.ball.x = self.paddle.x + (self.paddle.width / 2) - 4
  self.ball.y = self.paddle.y - 9
  if love.keyboard.wasPressed('space') then
    gStateMachine:change('play', {
      paddle = self.paddle,
      score = self.score,
      health = self.health,
      bricks = self.bricks,
      ball = self.ball,
      level = self.level,
      highScores = self.highScores
    })
  end
  if love.keyboard.wasPressed('escape') then
    love.event.quit()
  end
end
function ServeState:render()
  self.paddle:render()
  self.ball:render()
  for k, brick in pairs(self.bricks) do
    brick:render()
    love.graphics.setColor(1, 1, 1, 1)
  end
  renderScore(self.score)
  renderHealth(self.health)
  love.graphics.setFont(gFonts['mediumfont'])
  love.graphics.printf("Press space to serve!", 0, VIRTUAL_HEIGHT / 2, VIRTUAL_WIDTH, 'center')
end
