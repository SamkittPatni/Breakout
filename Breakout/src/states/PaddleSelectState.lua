PaddleSelectState = Class{__includes = BaseState}

function PaddleSelectState:enter(params)
  self.highScores = params.highScores
end

function PaddleSelectState:init()
  self.currentPaddle = 1
end
function PaddleSelectState:update(dt)
  if love.keyboard.wasPressed('left') then
    if self.currentPaddle == 1 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle - 1
    end
  elseif love.keyboard.wasPressed('right') then
    if self.currentPaddle == 4 then
      gSounds['no-select']:play()
    else
      gSounds['select']:play()
      self.currentPaddle = self.currentPaddle + 1
    end
  end
  if love.keyboard.wasPressed('escape') then
    gSounds['wall-hit']:play()
    gStateMachine:change('start', {
      highScores = self.highScores
    })
  end
  if love.keyboard.wasPressed('space') then
    gSounds['confirm']:play()
    gStateMachine:change('serve', {
      paddle = Paddle(self.currentPaddle),
      bricks = LevelMaker.createMap(1),
      health = 3,
      score = 0,
      level = 1,
      highScores = self.highScores
    })
  end
end

function PaddleSelectState:render()
  love.graphics.setFont(gFonts['mediumfont'])
  love.graphics.printf("Select your Paddle with left or right", 0, VIRTUAL_HEIGHT / 4, VIRTUAL_WIDTH, 'center')
  love.graphics.setFont(gFonts['smallfont'])
  love.graphics.printf("(Press space to continue)", 0, VIRTUAL_HEIGHT / 3, VIRTUAL_WIDTH, 'center')
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][2], VIRTUAL_WIDTH - VIRTUAL_WIDTH / 4, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
  love.graphics.draw(gTextures['arrows'], gFrames['arrows'][1], VIRTUAL_WIDTH / 4 - 24, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3)
  love.graphics.draw(gTextures['main'], gFrames['paddles'][2 + 4 * (self.currentPaddle - 1)], VIRTUAL_WIDTH / 2 - 32, VIRTUAL_HEIGHT - VIRTUAL_HEIGHT / 3 )
end
