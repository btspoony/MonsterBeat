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
	
	gameManager.pauseGame()
	
	local pauseUI = uiManager.getCurrentUI()
	local holder = pauseUI:getChildByName( 'holder' )
	transition.to( holder, { y = holder.showYPos, 
							time = 300,
							transition = easing.outQuad,
	} )
end

-- pause
pause_back = {}
function pause_back.onRelease( e )
	local pauseUI = uiManager.popUI( true )
	pauseUI:removeSelf()
	local game = uiManager.popUI( true )
	game:removeSelf()
	--TODO destroy game
	uiManager.getUI( utils.uipath('setting_start') )
end

pause_resume = {}
function pause_resume.onRelease( e )
	function complete()
		local pauseUI = uiManager.popUI( true )
		pauseUI:removeSelf()

		gameManager.resumeGame()
	end
	
	local pauseUI = uiManager.getCurrentUI()
	local holder = pauseUI:getChildByName( 'holder' )
	transition.to( holder, { y = holder.hideYPos, 
							time = 300,
							transition = easing.inOutQuad,
							onComplete = complete
	} )
end

pause_again = {}
function pause_again.onRelease( e )
	--TODO again game
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