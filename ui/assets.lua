module(..., package.seeall)

local ui			= require( utils.uipath('component/ui') )
local slide			= require( utils.uipath('component/slide') )
local list			= require( utils.uipath('component/simplelist') )
local tabwindow		= require( utils.uipath('component/tabwindow') )
local controller	= require( utils.uipath('controller') )
local gameModel		= require( utils.modelpath('game') )
local gameManager	= require( utils.gamepath('GameManager') )


-- logo
function logo()
	return display.newImage( res.getArt('ui','logo/logo.png') )
end

-- main menu
function mainmenu_play()
	local btn = ui.newButton{
		default = res.getArt('ui',"mainmenu/btn_play.png"),
		over = res.getArt('ui',"mainmenu/btn_play.png"),
		--onPress = controller.mainmenu_play,
		onRelease = controller.mainmenu_play.onRelease,
		--text = "Button 1 Label",
		--emboss = true
	}
	return btn
end

-- start
function start_slide()
	local imgs = {
		res.getArt('ui','start/feena1.JPG'),
		res.getArt('ui','start/feena2.JPG'),
		res.getArt('ui','start/feena3.JPG'),
		res.getArt('ui','start/feena4.JPG'),
		res.getArt('ui','start/feena5.JPG'),
		res.getArt('ui','start/feena6.JPG'),
		res.getArt('ui','start/feena7.JPG'),
		res.getArt('ui','start/feena8.JPG'),
	}
	local g = slide.new{ 
		imageSet = imgs,
		onSelect = controller.start_slide.onSelect,
		onBack   = controller.ready_back.onRelease;
	}
	return g
end


-- ready
function ready_chooser()
	-- setup some data
	local data = {}
	for i=1, 4 do
		data[i] = math.min( i, 3 )
	end
	
	-- create the list
	local list = list.newList{
		data			= data,
		default			= res.getArt('ui',"ready/listItemBg.png"),
		over			= res.getArt('ui',"ready/listItemBg_over.png"),
		onRelease		= controller.ready_chooser.onSelect,
	}
	return list
end

function ready_back()
	local btn = ui.newButton{
		default = res.getArt('ui',"ready/back.png"),
		over = res.getArt('ui',"ready/back.png"),
		--onPress = controller.mainmenu_play,
		onRelease = controller.ready_back.onRelease,
		--text = "Button 1 Label",
		--emboss = true
	}
	return btn
end

-- game 
function game_main()
	local canvas = gameManager.loadGame( gameModel.initParam )
	return canvas
end

function game_pause()
	local btn = ui.newButton{
		default = res.getArt('ui',"game/pause.png"),
		over = res.getArt('ui',"game/pause.png"),
		--onPress = controller.mainmenu_play,
		onRelease = controller.game_pause.onRelease,
		--text = "Button 1 Label",
		--emboss = true
	}
	return btn
end

-- pause
function pause_cover()
	local rect = display.newRect( 0, 0, display.contentWidth , display.contentHeight )
	rect:setFillColor( 0, 0, 0, 100 )
	return rect
end

function pause_resume()
	local btn = ui.newButton{
		default = res.getArt('ui',"pause/resume.png"),
		over = res.getArt('ui',"pause/resume.png"),
		onRelease = controller.pause_resume.onRelease,
	}
	return btn
end

function pause_again()
	local btn = ui.newButton{
		default = res.getArt('ui',"pause/again.png"),
		over = res.getArt('ui',"pause/again.png"),
		onRelease = controller.pause_again.onRelease,
	}
	return btn
end

function pause_back()
	local btn = ui.newButton{
		default = res.getArt('ui',"pause/back.png"),
		over = res.getArt('ui',"pause/back.png"),
		--onPress = controller.mainmenu_play,
		onRelease = controller.pause_back.onRelease,
		--text = "Button 1 Label",
		--emboss = true
	}
	return btn
end

-- win
function win_background()
	local bg = display.newImage( res.getArt('ui',"win/background.jpg") )
	return bg
end

function win_score()
	local txt = display.newText( 'default', 0,0, native.systemFont, 12 )
	txt.text = tostring( 0 )
	return txt
end

function win_back()
	local btn = ui.newButton{
		default = res.getArt('ui',"win/back.png"),
		over = res.getArt('ui',"win/back.png"),
		--onPress = controller.mainmenu_play,
		onRelease = controller.win_back.onRelease,
		--text = "Button 1 Label",
		--emboss = true
	}
	return btn
end

-- lose
function lose_background()
	local bg = display.newImage( res.getArt('ui',"lose/background.jpg") )
	return bg
end

function lose_score()
	local txt = display.newText( 'default', 0,0, native.systemFont, 12 )
	txt.text = tostring( 0 )
	return txt
end

function lose_back()
	local btn = ui.newButton{
		default = res.getArt('ui',"lose/back.png"),
		over = res.getArt('ui',"lose/back.png"),
		--onPress = controller.mainmenu_play,
		onRelease = controller.lose_back.onRelease,
		--text = "Button 1 Label",
		--emboss = true
	}
	return btn
end

-- profile
function profile_tabwindow()
	local tabs = {
		{
			btn_normal = res.getArt('ui', 'profile/normal1.png'),
			btn_toggle = res.getArt('ui', 'profile/toggle1.png'),
			content = utils.uipath('setting_profile1'),
		},
		{
			btn_normal = res.getArt('ui', 'profile/normal1.png'),
			btn_toggle = res.getArt('ui', 'profile/toggle1.png'),
			content = utils.uipath('setting_profile2'),
		},
		{
			btn_normal = res.getArt('ui', 'profile/normal1.png'),
			btn_toggle = res.getArt('ui', 'profile/toggle1.png'),
			content = utils.uipath('setting_profile3'),
		},
		{
			btn_normal = res.getArt('ui', 'profile/normal1.png'),
			btn_toggle = res.getArt('ui', 'profile/toggle1.png'),
			content = utils.uipath('setting_profile4'),
		},
	}
	local tabwindow = tabwindow.new{
		background = res.getArt('ui', 'profile/bg.png'),
		tabs = tabs,
		onChange = controller.profile_tabwindow.onChange,
	}
	return tabwindow
end

