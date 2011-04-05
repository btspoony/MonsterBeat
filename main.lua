--[[
	Abstract: KungFuChefs

	Version: 1.0
--]]

-- Hide Status Bar
display.setStatusBar( display.HiddenStatusBar )

-- preloading all assets
require('preloader')

-- referecens
local uiManager = require( utils.uipath('manager') )

-- start
local initer = {}
function initer:start()
	uiManager.pushUI( uiManager.getUI( utils.uipath('setting_logo') ) )
	Runtime:addEventListener("enterFrame", initer)
end

function initer:enterFrame( e )
	Runtime:removeEventListener("enterFrame", initer)
	timer.performWithDelay( 1000, initer, 1 )
end

function initer:timer( e )
	uiManager.pushUI( uiManager.getUI( utils.uipath('setting_mainmenu') ) )
end

-- setup all ui first show logo UI
initer:start()

utils.Stats()