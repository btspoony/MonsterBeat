module(..., package.seeall)

-- Reference 
local uiManager = require( utils.uipath('manager') )
local gameManager	= require( utils.gamepath('gameManager') )

-- main menu
mainmenu_play = {}
function mainmenu_play.onRelease( e )
	uiManager.pushUI( uiManager.getUI( utils.uipath('setting_start') ) )
end

-- start
start_slide = {}
function start_slide.onSelect( e )
	local ui = uiManager.getUI( utils.uipath('setting_ready') )
	ui.isVisible = true
	uiManager.pushUI( ui )
end

-- ready
ready_chooser = {}
function ready_chooser.onSelect( e )
	-- pop all UIs to prepare game starting
	local ui = uiManager.popUI( true )
	while ui do
		ui:removeSelf()
		ui = uiManager.popUI( true )
	end
	--
	uiManager.pushUI( uiManager.getUI( utils.uipath('setting_game') ) )
end

ready_back = {}
function ready_back.onRelease( e )
	uiManager.popUI().isVisible = false
end

-- game
game_main = {}
function game_main.onRelease( e )
	-- remove game
	uiManager.popUI( true ):removeSelf()
	
	local ui
	if e.x > display.contentWidth * .5 then
		ui = uiManager.getUI( utils.uipath('setting_lose') )
	else
		ui = uiManager.getUI( utils.uipath('setting_win') )
	end

	-- push win/lose
	uiManager.pushUI( ui )
end

game_pause = {}
function game_pause.onRelease( e )
	uiManager.pushUI( uiManager.getUI( utils.uipath('setting_pause') ) )
	--TODO pause game
	gameManager.pauseGame()
end

-- pause
pause_back = {}
function pause_back.onRelease( e )
	local pauseUI = uiManager.popUI( true )
	pauseUI:removeSelf()
	--TODO resume game
	gameManager.resumeGame()
end

-- win
win_back = {}
function win_back.onRelease( e )
	uiManager.popUI( true ):removeSelf()
	
	uiManager.pushUI( uiManager.getUI( utils.uipath('setting_start') ) )
end

-- lose
lose_back = {}
function lose_back.onRelease( e )
	uiManager.popUI( true ):removeSelf()
	uiManager.pushUI( uiManager.getUI( utils.uipath('setting_start') ) )
end