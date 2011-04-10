module(..., package.seeall)

initParam = {
	bg = "main01.png",
	level = "chef_01_130",
	subLevel = 1,
	mode = "normal",
	startAtBegin = true,
}

currentGame = {
	hp = 100,
	comboHits = 0,
	hitType = 'none',
	fever = false,
	score = 0,
}

itemPosLib = {
	['A'] = {
		tX = display.contentWidth*.1,
		tY = display.contentHeight*.5,
		r = 20,
		oX = -20,
		oY = (math.random()*.5+.5) * display.contentHeight,
	},
	['B'] = {
		tX = display.contentWidth*.3,
		tY = display.contentHeight*.3,
		r = 20,
		oX = -20,
		oY = (math.random()*.5+.5) * display.contentHeight,
	},	
	['C'] = {
		tX = display.contentWidth*.5,
		tY = display.contentHeight*.2,
		r = 20,
		oX = math.random()*display.contentWidth,
		oY = display.contentHeight + 20,
	},	
	['D'] = {
		tX = display.contentWidth*.7,
		tY = display.contentHeight*.3,
		r = 20,
		oX = display.contentWidth + 20,
		oY = (math.random()*.5+.5) * display.contentHeight,
	},
	['E'] = {
		tX = display.contentWidth*.9,
		tY = display.contentHeight*.5,
		r = 20,
		oX = display.contentWidth + 20,
		oY = (math.random()*.5+.5) * display.contentHeight,
	},
}