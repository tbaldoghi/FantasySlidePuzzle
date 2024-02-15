local composer = require( "composer" )
local scene = composer.newScene()

-- -----------------------------------------------------------------------------------
-- Code outside of the scene event functions below will only be executed ONCE unless
-- the scene is removed entirely (not recycled) via "composer.removeScene()"
-- -----------------------------------------------------------------------------------

-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------

local function gotoLevelMenu(event, difficulty)
  composer.setVariable('levelSize', difficulty)
	composer.gotoScene("scenes.level_menu")
end

-- create()
function scene:create(event)
	local sceneGroup = self.view
	-- Code here runs when the scene is first created but has not yet appeared on screen
  local title = display.newText(sceneGroup, "Select Difficulty", 500, 80, "assets/fonts/oswald.ttf", 64)

	title:setFillColor(75 / 255, 61 / 255, 68 / 255)
	title.x = display.contentCenterX
	title.y = 200

	local easyButton = display.newText(sceneGroup, "Easy", display.contentCenterX, 400, "assets/fonts/oswald.ttf", 42)
	local normalButton = display.newText(sceneGroup, "Normal", display.contentCenterX, 500, "assets/fonts/oswald.ttf", 42)
	local hardButton = display.newText(sceneGroup, "Hard", display.contentCenterX, 600, "assets/fonts/oswald.ttf", 42)

	easyButton:setFillColor(75 / 255, 61 / 255, 68 / 255)
  easyButton:addEventListener("tap",
    function(listenerEvent)
      gotoLevelMenu(listenerEvent, 4)
    end
  )
  normalButton:setFillColor(75 / 255, 61 / 255, 68 / 255)
  normalButton:addEventListener("tap",
    function(listenerEvent)
      gotoLevelMenu(listenerEvent, 6)
    end
  )
  hardButton:setFillColor(75 / 255, 61 / 255, 68 / 255)
  hardButton:addEventListener("tap",
    function(listenerEvent)
      gotoLevelMenu(listenerEvent, 8)
    end
  )
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
