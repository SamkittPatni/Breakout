require 'src/Dependencies'


-- Function tot create main layout --
function love.load()
  love.graphics.setDefaultFilter('nearest', 'nearest')
  math.randomseed(os.time())
  love.window.setTitle('Breakout')

  -- Initialising fonts --
  gFonts = {
    ['smallfont'] = love.graphics.newFont('fonts/font.ttf', 8),
    ['mediumfont'] = love.graphics.newFont('fonts/font.ttf', 16),
    ['largefont'] = love.graphics.newFont('fonts/font.ttf', 32)
  }

  -- Initialising images --
  gTextures = {
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['main'] = love.graphics.newImage('graphics/breakout.png'),
    ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
    ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
    ['particle'] = love.graphics.newImage('graphics/particle.png'),
    ['blocks'] = love.graphics.newImage('graphics/brickbreaker.png'),
    ['powerups'] = love.graphics.newImage('graphics/breakout2.png')
  }

  -- Initialframes for the images --
  gFrames = {
    ['paddles'] = GenerateQuadsPaddles(gTextures['main']),
    ['balls'] = GenerateQuadsBalls(gTextures['main']),
    ['bricks'] = GenerateQuadsBricks2(gTextures['blocks']),
    ['hearts'] = GenerateQuads(gTextures['hearts'], 10, 9),
    ['arrows'] = GenerateQuads(gTextures['arrows'], 24, 24),
    ['powerups'] = GenerateQuadsPowerUps(gTextures['powerups'])
  }

  -- Initialising sounds --
  gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
  }
  --gSounds['music']:play()
  --gSounds['music']:setLooping(true)
  push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
    vsync = true,
    fullscreen = false,
    resizable = true
  })

  -- Initialising all the states --
  gStateMachine = StateMachine {
    ['start'] = function() return StartState() end,
    ['play'] = function() return PlayState() end,
    ['serve'] = function() return ServeState() end,
    ['gameover'] = function() return GameOverState() end,
    ['victory'] = function() return VictoryState() end,
    ['high-scores'] = function() return HighScoreState() end,
    ['enter-high-scores'] = function() return EnterHighScoreState() end,
    ['paddle-select'] = function() return PaddleSelectState() end
  }
  gStateMachine:change('start', {
    highScores = loadHighScores()
  })
  love.graphics.setFont(gFonts['smallfont'])
  love.keyboard.keysPressed = {}
end

-- Function to allow resizing of the window --
function love.resize(w, h)
  push:resize(w, h)
end

-- Function to detect if a key is pressed --
function love.keypressed(key)
  love.keyboard.keysPressed[key] = true
end

-- Function to detect if a key was pressed --
function love.keyboard.wasPressed(key)
  if love.keyboard.keysPressed[key] then
    return true
  else
    return false
  end
end

-- Function that updates the statemachine continuously to check for state changes --
function love.update(dt)
  gStateMachine:update(dt)
  love.keyboard.keysPressed = {}
end

-- Function to render everything onto the screen --
function love.draw()
  push:apply('start')
  local backgroundWidth = gTextures['background']:getWidth()
  local backgroundHeight = gTextures['background']:getHeight()
  love.graphics.draw(gTextures['background'], 0, 0, 0, VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))
  gStateMachine:render()
  displayFPS()
  push:apply('end')
end

-- Function that displays the frames per second --
function displayFPS()
  love.graphics.setFont(gFonts['smallfont'])
  love.graphics.setColor(0, 255, 0, 255)
  love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 5, 5)
end

function renderScore(score)
  love.graphics.setFont(gFonts['smallfont'])
  love.graphics.print("SCORE: ", VIRTUAL_WIDTH - 60, 5)
  love.graphics.printf(tostring(score), VIRTUAL_WIDTH - 50, 5,40, 'right')
end

function renderHealth(health)
  local healthX = VIRTUAL_WIDTH - 160
  for i = 1, health do
    love.graphics.draw(gTextures['hearts'], gFrames['hearts'][1], healthX, 4)
    healthX = healthX + 11
  end
  --for i = 1, 3 - health do
    --love.graphics.draw(gTextures['hearts'], gFrames['hearts'][2], healthX, 4)
    --healthX = healthX + 11
  --end
end

-- Function that loads new highscores into the system --
function loadHighScores()
  love.filesystem.setIdentity('breakout')

  -- If the file doesn't have any information, we fill it with default highscore values --
  if not love.filesystem.getInfo('breakout.lst') then
    local scores = ''
    for i = 10, 1, -1 do
      scores = scores .. 'SAM\n'
      scores = scores .. tostring(i * 1000) .. '\n'
    end
    love.filesystem.write('breakout.lst', scores)
  end

  local name = true
  local currentName = nil
  local counter = 1
  local scores = {}
  for i = 1, 10 do
    scores[i] = {
      name = nil,
      score = nil
    }
  end
  for line in love.filesystem.lines('breakout.lst') do
    if name then
      scores[counter].name = string.sub(line, 1, 3)
    else
      scores[counter].score = tonumber(line)
      counter = counter + 1
    end
    name = not name
  end
  return scores
end
