-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")

display.setStatusBar(display.HiddenStatusBar)
display.setDefault( "background", 209 / 255, 177 / 255, 135 / 255)
math.randomseed(os.time())
composer.gotoScene("scenes.menu")
