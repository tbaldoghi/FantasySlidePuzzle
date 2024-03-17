-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

local composer = require("composer")
admob = require("plugin.admob")
local Database = require("classes.database")

local function adListener(event)
  if ( event.phase == "init" ) then
    print(event.provider)
    admob.load("interstitial", { adUnitId="app_id" })
    admob.load("banner", { adUnitId="app_id" })
  end
end

admob.init(adListener, { appId="app_id", testMode = true })

database = Database:new()
database:initialize()

display.setStatusBar(display.HiddenStatusBar)
display.setDefault( "background", 209 / 255, 177 / 255, 135 / 255)
composer.setVariable('adCount', 0)
composer.setVariable('currentPage', 0)
math.randomseed(os.time())
composer.gotoScene("scenes.menu")
