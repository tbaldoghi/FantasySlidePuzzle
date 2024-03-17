local composer = require("composer")
local widget = require("widget")
local Button = require("classes.button")

local scene = composer.newScene()

local pageSize = 6
local pageCount = 5
local currentPage = composer.getVariable('currentPage')

local levelButtons = {}

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoLevel(event, level)
  composer.setVariable('level', level)
  composer.gotoScene("scenes.game")
end

local function addLevelButtons(sceneGroup)
  local page = pageSize * currentPage

  for i = 1, pageSize do
    local level = i + page
    local x, y = 0, 0
    local imagePath = 'assets/images/levels/level_'..level..'.png'
    local buttonGroup = display.newGroup()
    local levelBackground = display.newImage(sceneGroup, 'assets/images/ui/level_background.png')
    local levelImage = display.newImage(sceneGroup, imagePath)

    levelImage:scale(0.35, 0.35)

    local difficulty = composer.getVariable('difficulty')
    local result = database:levelsSelect(level, difficulty)
    local isPlayable = result['is_playable']
    local xOffset = 150
    local yOffset = 150

    if (i % 2 == 0) then
      x = display.contentCenterX + xOffset
      y =  180 + yOffset * (i - 1)
    else
      x = display.contentCenterX - xOffset
      y =  180 + yOffset * i
    end

    levelImage:translate(x, y)
    levelBackground:translate(x, y)

    buttonGroup:insert(levelBackground)
    buttonGroup:insert(levelImage)
    sceneGroup:insert(buttonGroup)

    if isPlayable == 1 then
      buttonGroup:addEventListener("tap",
        function(event)
          gotoLevel(event, i + page)
        end
      )
    elseif isPlayable == 0 then
      levelImage.fill.effect = "filter.grayscale"
    end

    levelButtons[i] = buttonGroup
  end
end

local function removeLevelButtons()
  for i = 1, #levelButtons, 1 do
    levelButtons[i]:removeSelf()
  end
end

local function handlePreviousButtonOnTap(event, sceneGroup)
  if (event.phase == "ended") then
    if (currentPage - 1 >= 0) then
      removeLevelButtons()
      currentPage = currentPage - 1
      composer.setVariable('currentPage', currentPage)
      addLevelButtons(sceneGroup)
    end
  end
end

local function handleNextButtonOnTap(event, sceneGroup)
  if (event.phase == "ended") then
    if (currentPage + 1 < pageCount) then
      removeLevelButtons()
      currentPage = currentPage + 1
      composer.setVariable('currentPage', currentPage)
      addLevelButtons(sceneGroup)
    end
  end
end

local function handleBackButtonOnTap(event)
  composer.removeScene("scenes.level_menu")
  composer.gotoScene("scenes.menu")
end

-- create()
function scene:create(event)
	local sceneGroup = self.view

	-- Code here runs when the scene is first created but has not yet appeared on screen
  local title = display.newText(sceneGroup, "First Chapter, Druidstone", display.contentCenterX, 100, "assets/fonts/oswald.ttf", 64)

  title:setFillColor(75 / 255, 61 / 255, 68 / 255)

  local options = {
    width = 78,
    height = 78,
    numFrames = 2,
    sheetContentWidth = 156,
    sheetContentHeight = 78
  }

  local previousButtonSheet = graphics.newImageSheet("assets/images/ui/arrow_left.png", options)
  local nextButtonSheet = graphics.newImageSheet("assets/images/ui/arrow_right.png", options)

  local previousButton = widget.newButton(
    {
        sheet = previousButtonSheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = function(event)
          handlePreviousButtonOnTap(event, sceneGroup)
        end
    }
  )

  local nextButton = widget.newButton(
    {
        sheet = nextButtonSheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = function(event)
          handleNextButtonOnTap(event, sceneGroup)
        end
    }
  )

  previousButton.x = display.contentCenterX - 248
  previousButton.y = display.contentHeight - 100
  nextButton.x = display.contentCenterX + 248
  nextButton.y = display.contentHeight - 100

  local backButton = Button:new()
  backButton:addButton(sceneGroup, 'Back', display.contentCenterX, display.contentHeight - 100, handleBackButtonOnTap, true)

  sceneGroup:insert(previousButton)
  sceneGroup:insert(nextButton)

  addLevelButtons(sceneGroup)
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
function scene:destroy( event )
	local sceneGroup = self.view
	-- Code here runs prior to the removal of scene's view
end

-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
