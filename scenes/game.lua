local composer = require("composer")
local scene = composer.newScene()

local Tile = require("classes.tile")
local size = composer.getVariable('levelSize')

local imageSheet
local boardSize = size * size
local tileSize = 720 / size
local moves = 0
local time = 0
local movesText = ''
local timeText = ''
local gameTimer
local isGameTimerActive = false
local isGameOver = false
local tiles = {}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function shuffle()
  for index = 1, boardSize * 10, 1 do
    for i = 1, size, 1 do
      for j = 1, size, 1 do
        if (tiles[i][j]:getIsEmpty()) then
          local directions = {}
          local positions = {}
  
          if (i - 1 >= 1) then
            table.insert(directions, 'down')
            positions['down'] = { i - 1, j }
          end
  
          if (i + 1 <= size) then
            table.insert(directions, 'up')
            positions['up'] = { i + 1, j }
          end
  
          if (j - 1 >= 1) then
            table.insert(directions, 'right')
            positions['right'] = { i, j - 1 }
          end
  
          if (j + 1 <= size) then
            table.insert(directions, 'left')
            positions['left'] = { i, j + 1 }
          end
  
          local direction = directions[math.random(#directions)]
          local ni = positions[direction][1]
          local nj = positions[direction][2]
          local temp = tiles[ni][nj]
  
          tiles[ni][nj]:move(direction, false)
          tiles[ni][nj] = tiles[i][j]
          tiles[ni][nj]:setIsEmpty(true)
          tiles[i][j] = temp
          tiles[i][j]:setIsEmpty(false)
        end
      end
    end
  end
end

local function timerListener(event)
  time = time + 1
  timeText.text = 'Time: '..time..'s'
end

local function checkTilePositions()
  local counter = 1

  for i = 1, size, 1 do
    for j = 1, size, 1 do
      if (tiles[i][j]:getPosition() ~= counter) then
        return
      end

      counter = counter + 1
    end
  end

  isGameOver = true
end

local function updateMoves()
  checkTilePositions()

  moves = moves + 1
  movesText.text = 'Moves: '..moves
end

local function startGameTimer()
  if (not isGameTimerActive) then
    isGameTimerActive = true

    timer.resume(gameTimer)
  end
end

local function handleOnTap(event)
  if (event.phase == "ended" and not isGameOver) then
    local sprite = event.target
    local tileInstance = sprite.tileInstance
    local tilePosition = tileInstance:getPosition()
    local breakLoop

    startGameTimer()

    for i = 1, size, 1 do
      for j = 1, size, 1 do
        if (tiles[i][j]:getPosition() == tilePosition) then
          local temp = tiles[i][j]

          if (i - 1 >= 1) then
            if (tiles[i - 1][j]:getIsEmpty() == true) then
              tileInstance:move('up', true)
              tiles[i][j] = tiles[i - 1][j]
              tiles[i][j]:setIsEmpty(true)
              tiles[i - 1][j] = temp
              tiles[i - 1][j]:setIsEmpty(false)
              breakLoop = true
              updateMoves()
              break
            end
          end

          if (i + 1 <= size) then
            if (tiles[i + 1][j]:getIsEmpty() == true) then
              tileInstance:move('down', true)
              tiles[i][j] = tiles[i + 1][j]
              tiles[i][j]:setIsEmpty(true)
              tiles[i + 1][j] = temp
              tiles[i + 1][j]:setIsEmpty(false)
              breakLoop = true
              updateMoves()
              break
            end
          end

          if (j - 1 >= 1) then
            if (tiles[i][j - 1]:getIsEmpty() == true) then
              tileInstance:move('left', true)
              tiles[i][j] = tiles[i][j - 1]
              tiles[i][j]:setIsEmpty(true)
              tiles[i][j - 1] = temp
              tiles[i][j - 1]:setIsEmpty(false)
              breakLoop = true
              updateMoves()
              break
            end
          end

          if (j + 1 <= size) then
            if (tiles[i][j + 1]:getIsEmpty() == true) then
              tileInstance:move('right', true)
              tiles[i][j] = tiles[i][j + 1]
              tiles[i][j]:setIsEmpty(true)
              tiles[i][j + 1] = temp
              tiles[i][j + 1]:setIsEmpty(false)
              breakLoop = true
              updateMoves()
              break
            end
          end
        end
      end

      if breakLoop then
        break
      end
    end
  end
end

local function handleGameOver(event, sceneGroup)
  if (isGameOver) then
    isGameTimerActive = false
    timer.pause(gameTimer)

    for i = 1, size, 1 do
      for j = 1, size, 1 do
        tiles[i][j]:hideNumber()

        if (i == size and j == size) then
          local x = display.contentCenterX - tileSize / 2 - (tileSize * size / 2) + (tileSize * j)
          local y = display.contentCenterY - tileSize / 2 - (tileSize * size / 2) + (tileSize * i) + 172 -- TODO

          tiles[i][j]:addSprite(sceneGroup, imageSheet, i * j, x, y)
        end
      end
    end
  end
end

local function handleResetButtonTap()
  composer.removeScene("scenes.game")
  composer.gotoScene("scenes.level_menu")
end

-- create()
function scene:create(event)
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen

  local sheetOptions = {
    width = tileSize,
    height = tileSize,
    numFrames = size * size
  }

  local level = composer.getVariable('level')
  local imagePath = 'assets/images/levels/level_'..level..'.png'
  imageSheet = graphics.newImageSheet(imagePath, sheetOptions)
  local heightOffset = 172
  local background = display.newImage(sceneGroup, 'assets/images/ui/background.png')
  background.x = display.contentCenterX
  background.y = display.contentCenterY + heightOffset
  -- local referenceText = display.newText(sceneGroup, 'Reference', 500, 50, "assets/fonts/oswald.ttf", 32)
  -- referenceText:setFillColor(75 / 255, 61 / 255, 68 / 255)
  local referenceBackground = display.newImage(sceneGroup, 'assets/images/ui/reference_background.png')
  referenceBackground.x = 510
  referenceBackground.y = 200
  local referenceImage = display.newImage(sceneGroup, imagePath)
  referenceImage:translate(510, 200)
  referenceImage:scale(0.5, 0.5)
  movesText = display.newText(sceneGroup, 'Moves: '..moves, 150, 125, "assets/fonts/oswald.ttf", 42)
  movesText:setFillColor(75 / 255, 61 / 255, 68 / 255)
  timeText = display.newText(sceneGroup, 'Time: '..time.. 's', 150, 200, "assets/fonts/oswald.ttf", 42)
  timeText:setFillColor(75 / 255, 61 / 255, 68 / 255)
  local resetButton = display.newText(sceneGroup, "Back", 150, 275, "assets/fonts/oswald.ttf", 42)
  resetButton:addEventListener('tap', handleResetButtonTap)
  resetButton:setFillColor(75 / 255, 61 / 255, 68 / 255)
  local counter = 1
  gameTimer = timer.performWithDelay(1000, timerListener, -1)

  timer.pause(gameTimer)

  for i = 1, size, 1 do
    tiles[i] = {}

    for j = 1, size, 1 do
      local tile = Tile:new()
      
      tile:setPosition(counter)

      if (i == size and j == size) then
        tile:setIsEmpty(true)
        tiles[i][j] = tile

        break
      end

      local x = display.contentCenterX - tileSize / 2 - (tileSize * size / 2) + (tileSize * j)
      local y = display.contentCenterY - tileSize / 2 - (tileSize * size / 2) + (tileSize * i) + heightOffset

      tile:addTile(sceneGroup, imageSheet, counter, x, y, tileSize,
        function(event)
          handleOnTap(event)
          handleGameOver(event, sceneGroup)
        end)

      tiles[i][j] = tile

      counter = counter + 1
    end
  end

  shuffle()
end

-- show()
function scene:show(event)
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end

-- hide()
function scene:hide(event)
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is on screen (but is about to go off screen)
	elseif ( phase == "did" ) then
		-- Code here runs immediately after the scene goes entirely off screen
	end
end

-- destroy()
function scene:destroy(event)
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
  timer.cancel(gameTimer)
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
