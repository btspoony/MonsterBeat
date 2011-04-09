module (..., package.seeall)

--[[	
	Private Group
--]]

-- Managers
local levelManager = require(utils.gamepath( 'LevelManager' ))
local sfxManager = require(utils.gamepath( 'sfxManager' ))
local gameAssets = require(utils.gamepath( 'gameAssets' ))

-- Basic Gameplay
local function onSpawn(event)
	local newShape = nil
	
	local pos = event.position
	if pos == "A" then
		newShape = display.newRect(0,0,50,200)
		newShape:setFillColor(50,50,50)
	elseif pos == "B" then
		newShape = display.newRect(50,0,50,200)
		newShape:setFillColor(100,50,50)
	elseif pos == "C" then
		newShape = display.newRect(100,0,50,200)
		newShape:setFillColor(150,50,50)
	elseif pos == "D" then
		newShape = display.newRect(150,0,50,200)
		newShape:setFillColor(200,50,50)
	elseif pos == "E" then
		newShape = display.newRect(200,0,50,200)
		newShape:setFillColor(250,50,50)
	end
	
	-- remove shape in 0.5s
	local function removeSelf()
		newShape:removeSelf()
	end
	timer.performWithDelay(500, removeSelf)
	
	print("Current Position: "..pos)
	return true
end

local function onComplete( event )
	-- TODO
	print("Level Complete!")
	currentGame.canvas:dispatchEvent{name="comlete", target=currentGame.canvas}
end

--[[	
	Public Functions
--]]

-- record current Game
currentGame = nil

-- Load a game by param
function loadGame( param )
	-- init Game
	currentGame = {} -- Game Data
	currentGame.status = "ready"
	currentGame.param = param

	local gameCanvas = layout.group()	-- Game Canvas
	currentGame.canvas = gameCanvas
	currentGame.level = levelManager.loadLevel(param.level) -- Level init
	
	-- Set background
	local gamebg = display.newImage( res.getArt('bg', param.bg ))
	gameCanvas:insert(gamebg)
	
	-- Set Basic UI
	-- TODO
	
	-- If game should start at beginning
	if(param.startAtBegin) then
		-- Level Start
		startGame(param.subLevel)
	end
	
	return gameCanvas, currentGame
end

-- Start
function startGame( level )
	if currentGame == nil or currentGame.status ~= "ready" then
		return nil
	end
	
	if level == nil	and currentGame.param then
		level = currentGame.param.subLevel
	end
	
	currentGame.level:startLevel(level,	{ ["spawn"] = onSpawn,["complete"] = onComplete })
	
	currentGame.status = "started"
end

-- Game Control
function pauseGame()
	currentGame.level:pauseLevel()
end

function resumeGame()
	currentGame.level:resumeLevel()
end

function quitGame()
	currentGame.param = nil
	currentGame.status = nil
	currentGame.level:dispose()
	currentGame.level = nil
	currentGame.canvas:removeSelf()
	currentGame.canvas =nil
	currentGame = nil;
end