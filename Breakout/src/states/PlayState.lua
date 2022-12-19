PlayState = Class{__includes = BaseState}
function PlayState:enter(params)
  self.paddle = params.paddle
  self.health = params.health
  self.score = params.score
  self.bricks = params.bricks
  self.ball = params.ball
  self.balls = {}
  self.level = params.level
  self.highScores = params.highScores
  self.ball.dx = math.random(-200, 200)
  self.ball.dy = math.random(-50, -60)
  self.up = 0
  self.power = {}
  self.pause = false
  self.timer = 0
  table.insert(self.balls, self.ball)
  bigpaddle = false
end

function PlayState:update(dt)
  if self.pause then
    if love.keyboard.wasPressed('space') then
      self.pause = false
      gSounds['pause']:play()
    else
      return
    end
  elseif love.keyboard.wasPressed('space') then
    self.pause = true
    gSounds['pause']:play()
    return
  end
  self.paddle:update(dt)
  --self.ball:update(dt)
  for k, ball in pairs(self.balls) do
    ball:update(dt)
    if ball.y + 7 < self.paddle.y then
      if ball:collides(self.paddle) then
        if ball.y < self.paddle.y + 10 then
          self.y = self.paddle.y - 10
          ball.dy = -ball.dy
          if ball.x < self.paddle.x + (self.paddle.width / 2) and self.paddle.dx < 0 then
            ball.dx = -50 + -(8 * (self.paddle.x + self.paddle.width / 2 - ball.x))
          elseif ball.x > self.paddle.x + (self.paddle.width / 2) and self.paddle.dx > 0 then
            ball.dx = 50 + (8 * math.abs(self.paddle.x + self.paddle.width / 2 - ball.x))
          end
          if math.abs(ball.dy) < 100 then
            if ball.dy < 0 then
              ball.dy = -100
            else
              ball.dy = 100
            end
          end
          if math.abs(ball.dx) > 100 then
            if ball.dx < 0 then
              ball.dx = -100
            else
              ball.dx = 100
            end
          end
          gSounds['paddle-hit']:play()
        end
      end
    end
    for k, brick in pairs(self.bricks) do
      if brick.inPlay and ball:collides(brick) then
        brick:hit()
        local powerup = math.random(5) == 1 and true or false
        if powerup then
          table.insert(self.power, PowerUp(math.random(7,10), brick))
        end
        if self:checkVictory() then
          gSounds['victory']:play()
          gStateMachine:change('victory', {
            level = self.level,
            ball = self.ball,
            paddle = self.paddle,
            health = self.health,
            score = self.score,
            highScores = self.highScores
          })
        end
        self.score = self.score + (brick.tier * 200 + brick.colour * 25)
        self.up = self.up + (brick.tier * 200 + brick.colour * 25)
        if self.up > 10000 then
          self.health = math.min(self.health + 1, 8)
          self.up = 0
        end
        local shift_x, shift_y = 0, 0
        if (ball.x + ball.width / 2) < (brick.x + brick.width / 2) then
          shift_x = (ball.x + ball.width) - brick.x
        else
          shift_x = ball.x - (brick.x + brick.width)
        end
        if (ball.y + ball.height / 2) < (brick.y + brick.height / 2) then
          shift_y = (ball.y + ball.height) - brick.y
        else
          shift_y = ball.y - (brick.y + brick.height)
        end
        local min_shift = math.min(math.abs(shift_x), math.abs(shift_y))
        if math.abs(shift_x) == math.abs(shift_y) then
          goto continue
        elseif math.abs(shift_x) == min_shift then
          shift_y = 0
        else
          shift_x = 0
        end
        ::continue::
        ball.x = ball.x + shift_x
        ball.y = ball.y + shift_y
        if shift_x ~= 0 then
          ball.dx = -ball.dx
        end
        if shift_y ~= 0 then
          ball.dy = -ball.dy
        end
        if math.abs(ball.dy) > 100 then
          if ball.dy < 0 then
            ball.dy = -100
          else
            ball.dy = 100
          end
        end
        if math.abs(ball.dx) > 100 then
          if ball.dx < 0 then
            ball.dx = -100
          else
            ball.dx = 100
          end
        end
        break
      end
    end
    if #self.balls == 1 then
      if ball.y >= VIRTUAL_HEIGHT then
        self.health = self.health - 1
        if self.health > 0 then
          gStateMachine:change('serve', {
            paddle = self.paddle,
            score = self.score,
            health = self.health,
            bricks = self.bricks,
            level = self.level,
            highScores = self.highScores
          })
        else
          gStateMachine:change('gameover', {
            score = self.score,
            highScores = self.highScores
          })
        end
      end
    else
      if ball.y >= VIRTUAL_HEIGHT then
        table.remove(self.balls, k)
      end
    end
  end
  for l, powerups in pairs(self.power) do
    powerups:update(dt)
  end
  for k, powerups in pairs(self.power) do
    if powerups:collides(self.paddle) then
      if powerups.skin == 7 then
        self.health = math.min(self.health + 1, 8)
      end
      if powerups.skin == 8 then
        if bigpaddle == false then
          self.paddle.size = 3
          self.paddle.width = 96
          self.timer = 0
        end
      end
      if powerups.skin == 9 then
        local newBall = Ball(5)
        newBall.x = self.paddle.x + (self.paddle.width / 2) - 4
        newBall.y = self.paddle.y - 9
        newBall.dx = math.random(-200, 200)
        newBall.dy = math.random(-50, -60)
        table.insert(self.balls, newBall)
      end
      if powerups.skin == 10 then
        self.health = self.health - 2
        self.paddle.size = 4
        self.paddle.width = 128
        bigpaddle = true
      end
      table.remove(self.power, k)
      gSounds['brick-hit-2']:play()
    end
    if powerups.remove then
      table.remove(self.power, k)
    end
  end
  self.timer = self.timer + dt
  if bigpaddle == false then
    if self.timer >= 10 then
      self.paddle.size = 2
      self.paddle.width = 64
    end
  end
  --for k, brick in pairs(self.bricks) do
    --if brick.inPlay and self.ball:collides(brick) then
      --brick:hit()
      --local powerup = math.random(5) == 1 and true or false
      --if powerup then
        --table.insert(self.power, PowerUp(math.random(7,9), brick))
      --end
      --if self:checkVictory() then
        --gSounds['victory']:play()
        --gStateMachine:change('victory', {
          --level = self.level,
          --ball = self.ball,
          --paddle = self.paddle,
          --health = self.health + 1,
          --score = self.score,
          --highScores = self.highScores
        --})
      --end
      --self.score = self.score + (brick.tier * 200 + brick.colour * 25)
      --self.up = self.up + (brick.tier * 200 + brick.colour * 25)
      --if self.up > 10000 then
        --self.health = self.health + 1
        --self.up = 0
      --end
      --local shift_x, shift_y = 0, 0
      --if (self.ball.x + self.ball.width / 2) < (brick.x + brick.width / 2) then
        --shift_x = (self.ball.x + self.ball.width) - brick.x
      --else
        --shift_x = self.ball.x - (brick.x + brick.width)
      --end
      --if (self.ball.y + self.ball.height / 2) < (brick.y + brick.height / 2) then
        --shift_y = (self.ball.y + self.ball.height) - brick.y
      --else
        --shift_y = self.ball.y - (brick.y + brick.height)
      --end
      --local min_shift = math.min(math.abs(shift_x), math.abs(shift_y))
      --if math.abs(shift_x) == math.abs(shift_y) then
        --goto continue
      --elseif math.abs(shift_x) == min_shift then
        --shift_y = 0
      --else
        --shift_x = 0
      --end
      --::continue::
      --self.ball.x = self.ball.x + shift_x
      --self.ball.y = self.ball.y + shift_y
      --if shift_x ~= 0 then
        --self.ball.dx = -self.ball.dx
      --end
      --if shift_y ~= 0 then
        --self.ball.dy = -self.ball.dy
      --end


      --if self.ball.x + 2 < brick.x and self.ball.dx > 0 then
        --self.ball.dx = self.ball.dx
        --self.ball.x = brick.x - 8
      --elseif self.ball.x + 6> brick.x + brick.width and self.ball.dx < 0 then
        --self.ball.dx = - self.ball.dx
        --self.ball.x = brick.x + 32
      --elseif self.ball.y < brick.y then
        --self.ball.dy = -self.ball.dy
        --self.ball.y = brick.y - 8
      --else
        --self.ball.dy = -self.ball.dy
        --self.ball.y = brick.y + 16
      --end


      --if math.abs(self.ball.dy) > 100 then
        --if self.ball.dy < 0 then
          --self.ball.dy = -100
        --else
          --self.ball.dy = 100
        --end
      --end
      --if math.abs(self.ball.dx) > 100 then
        --if self.ball.dx < 0 then
          --self.ball.dx = -100
        --else
          --self.ball.dx = 100
        --end
      --end
      --break
    --end
  --end
  --if self.ball.y >= VIRTUAL_HEIGHT then
    --self.health = self.health - 1
    --if self.health > 0 then
      --gStateMachine:change('serve', {
        --paddle = self.paddle,
        --score = self.score,
        --health = self.health,
        --bricks = self.bricks,
        --level = self.level,
        --highScores = self.highScores
      --})
    --else
      --gStateMachine:change('gameover', {
        --score = self.score,
        --highScores = self.highScores
      --})
    --end
  --end
  if love.keyboard.wasPressed('escape') then
    gStateMachine:change('paddle-select', {
      highScores = self.highScores
    })
  end
end

function PlayState:render()
  for k, brick in pairs(self.bricks) do
    brick:render()
    love.graphics.setColor(1, 1, 1, 1)
  end
  for l, powerups in pairs(self.power) do
    powerups:render()
  end
  self.paddle:render()
  for k, ball in pairs(self.balls) do
    ball:render()
  end
  renderScore(self.score)
  renderHealth(self.health)
  if self.pause then
    love.graphics.setFont(gFonts['largefont'])
    love.graphics.printf("PAUSED", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, 'center')
  end
end

function PlayState:checkVictory()
  for k, brick in pairs(self.bricks) do
    if brick.inPlay then
      return false
    end
  end
  return true
end
