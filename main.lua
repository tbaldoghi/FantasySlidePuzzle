-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
local Database = require("classes.database")

database = Database:new()
database:initialize()

display.setStatusBar(display.HiddenStatusBar)
display.setDefault( "background", 209 / 255, 177 / 255, 135 / 255)
math.randomseed(os.time())
composer.gotoScene("scenes.menu")
