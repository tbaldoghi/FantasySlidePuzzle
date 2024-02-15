local composer = require("composer")
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoChapterMenu()
  composer.gotoScene("scenes.chapter_menu")
end

local function gotoSettings()
	composer.gotoScene("scenes.settings")
end

-- create()
function scene:create( event )
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local title = display.newText(sceneGroup, "Fantasy Slide Puzzle", 500, 80, "assets/fonts/oswald.ttf", 64)
  
	title:setFillColor(75 / 255, 61 / 255, 68 / 255)
  title.x = display.contentCenterX
  title.y = 200

  local playButton = display.newText(sceneGroup, "Play", display.contentCenterX, 500, "assets/fonts/oswald.ttf", 42)
  local settingsButton = display.newText(sceneGroup, "Settings", display.contentCenterX, 600, "assets/fonts/oswald.ttf", 42)

  playButton:setFillColor(75 / 255, 61 / 255, 68 / 255)
  playButton:addEventListener("tap", gotoChapterMenu)
	settingsButton:setFillColor(75 / 255, 61 / 255, 68 / 255)
	settingsButton:addEventListener("tap", gotoSettings)
end

-- show()
function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase

	if ( phase == "will" ) then
		-- Code here runs when the scene is still off screen (but is about to come on screen)
	elseif ( phase == "did" ) then
		-- Code here runs when the scene is entirely on screen
	end
end

-- hide()
function scene:hide( event )
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
scene:addEventListener("create", scene)
scene:addEventListener("show", scene)
scene:addEventListener("hide", scene)
scene:addEventListener("destroy", scene)
-- -----------------------------------------------------------------------------------

return scene
