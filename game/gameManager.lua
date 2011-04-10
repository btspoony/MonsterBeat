module (..., package.seeall)

--[[	
	Private Group
--]]

-- Managers
local levelManager = require(utils.gamepath( 'LevelManager' ))
local sfxManager = require(utils.gamepath( 'sfxManager' ))
local gameAssets = require(utils.gamepath( 'gameAssets' ))

-- Model
local gameEntity = require(utils.modelpath('game'))

-- Basic Gameplay
local function onSpawn(event)
	-- init item
	local itemParam = {}
	local newItem = nil
	
	-- set item param
	if math.random()>0.5 then itemParam.type ="things" else itemParam.type ="food" end
	
	-- create item
	newItem = gameAssets.geneThrowable(itemParam, currentGame.canvas)
	newItem:setReferencePoint(display.CenterReferencePoint)
	
	-- get some info
	local tick = (60*1000/currentGame.level.info.bpm)
	print(tick)
	local itemPosInfo = gameEntity.itemPosLib[event.position]
	
	if itemPosInfo == nil then
		newItem:removeSelf()
		return false
	end
	
	newItem.x = itemPosInfo.oX
	newItem.y = itemPosInfo.oY
	
	transition.to(newItem, {
		time = tick*1.75,
		x = itemPosInfo.tX,
		y = itemPosInfo.tY,
		transition=easing.inOutExpo,
		onComplete = function( evt )
			-- remove shape in tick time
			local function removeSelf()
				newItem:removeSelf()
			end
			timer.performWithDelay(tick*.5, removeSelf)
		end
	})
	
	print("Current Position: "..event.position)
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

	local gameCanvas = layout.group() -- Game Canvas
	currentGame.canvas = gameCanvas
	currentGame.level = levelManager.loadLevel(param.level) -- Level init
	
	-- Set background
	local gamebg = display.newImage( res.getArt('bg', param.bg ))
	gameCanvas:insert(gamebg)
	
	-- Set Basic UI
	local gameUI = layout.group() -- Game UI
	currentGame.ui = gameUI
	gameUI = display.newText( "Score: 0", 10, 18, "Helvetica", 16 )
	
	-- If game should start at beginning
	if(param.startAtBegin) then
		-- Level Start
		startGame(param.subLevel)
	end
	
	return gameCanvas, gameUI, currentGame
end

-- Start
function startGame( level )
	if currentGame == nil or currentGame.status ~= "ready" then
		return nil
	end
	
	if level == nil	and currentGame.param then
		level = currentGame.param.subLevel
	end
	
	-- Start Game Level
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
	currentGame.ui:removeSelf()
	currentGame.ui =nil
	currentGame = nil;
end