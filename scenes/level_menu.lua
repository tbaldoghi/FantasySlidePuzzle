local composer = require("composer")
local widget = require("widget")
local scene = composer.newScene()

local level_data = require("data.level_data")

local pageSize = 5
local currentPage = 0

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
  -- composer.setVariable('levelSize', levelSize)
  composer.gotoScene("scenes.game")
end

local function addLevelButtons(sceneGroup)
  local page = pageSize * currentPage

  for i = 1, pageSize do
    local buttonGroup = display.newGroup()
    local levelText = display.newText(buttonGroup, "Level "..i + page, display.contentCenterX - 175, 200 + 150 * i, "assets/fonts/oswald.ttf", 24)
    local levelName = display.newText(buttonGroup, level_data[i + page]['name'], display.contentCenterX - 150, 200 + 150 * i + 35, "assets/fonts/oswald.ttf", 42)

    levelText:setFillColor(75 / 255, 61 / 255, 68 / 255)
    levelName:setFillColor(75 / 255, 61 / 255, 68 / 255)

    sceneGroup:insert(buttonGroup)
    buttonGroup:addEventListener("tap",
      function(event)
        gotoLevel(event, i + page)
      end
    )

    levelButtons[i] = buttonGroup
  end
end

local function removeLevelButtons()
  for i = 1, #levelButtons, 1 do
    levelButtons[i]:removeSelf()
  end
end

local function handleBackButtonOnTap(event, sceneGroup)
  if (event.phase == "ended") then
    removeLevelButtons()
    currentPage = currentPage - 1
    addLevelButtons(sceneGroup)
  end
end

local function handleNextButtonOnTap(event, sceneGroup)
  if (event.phase == "ended") then
    -- TODO
    removeLevelButtons()
    currentPage = currentPage + 1
    addLevelButtons(sceneGroup)
  end
end

-- create()
function scene:create(event)
	local sceneGroup = self.view

	-- Code here runs when the scene is first created but has not yet appeared on screen
  local title = display.newText(sceneGroup, "First Chapter, Druidstone", 500, 80, "assets/fonts/oswald.ttf", 64)

  title:setFillColor(75 / 255, 61 / 255, 68 / 255)
	title.x = display.contentCenterX
	title.y = 200

  local options = {
    width = 78,
    height = 78,
    numFrames = 2,
    sheetContentWidth = 156,
    sheetContentHeight = 78
  }

  local backButtonSheet = graphics.newImageSheet("assets/images/ui/arrow_left.png", options)
  local nextButtonSheet = graphics.newImageSheet("assets/images/ui/arrow_right.png", options)

  local backButton = widget.newButton(
    {
        sheet = backButtonSheet,
        defaultFrame = 1,
        overFrame = 2,
        onEvent = function(event)
          handleBackButtonOnTap(event, sceneGroup)
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

  backButton.x = display.contentCenterX - 248
  backButton.y = display.contentHeight - 128
  nextButton.x = display.contentCenterX + 248
  nextButton.y = display.contentHeight - 128

  sceneGroup:insert(backButton)
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
