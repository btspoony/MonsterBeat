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
local function onTouch( self, event )
	-- TODO
	print("Item("..self.itemID..") is touched")
	return true
end

local function onSpawn(event)
	-- init item
	local itemParam = {}
	local newItem = nil
	local game = currentGame.gameContent
	
	-- set item param
	if math.random()>0.5 then itemParam.type ="things" else itemParam.type ="food" end
	
	-- create item
	newItem = gameAssets.geneThrowable(itemParam, game.canvas)
	newItem:setReferencePoint(display.CenterReferencePoint)
	
	-- get some info
	local tick = (60*1000/currentGame.level.info.bpm)
	local itemPosInfo = gameEntity.itemPosLib[event.position]
	
	-- return false if nil
	if itemPosInfo == nil then
		newItem:removeSelf()
		return false
	end
	
	-- set position
	newItem.x = itemPosInfo.oX
	newItem.y = itemPosInfo.oY
	local targetX = itemPosInfo.tX
	local targetY = itemPosInfo.tY
	
	-- calculate the position
	local flyT = tick * 1.75 / 1000
	local vX = (targetX-newItem.x)/flyT
	local aY = math.abs(2*(targetY-newItem.y)/(flyT*flyT))
	local vY = aY * flyT
	print(" vX:"..vX.." aY:"..aY.." vY"..vY)
	
	newItem:applyForce(0,aY,newItem.x,newItem.y)
	newItem:setLinearVelocity(vX,vY)
	-- set Touch EventListener
	newItem.touch = onTouch
	newItem:addEventListener("touch",newItem)
	
	-- set target
	local target = display.newCircle( targetX, targetY, 13 )
	target:setFillColor(128,128,128)
	target.strokeWidth = 2
	target:setStrokeColor(256,256,256)
	physics.addBody(target, "static",
	 	{density = 1.0, friction = 0.3, bounce = 0.2, isSensor = true, radius = 15})
	target.itemID = newItem.itemID
	target.itemType = "T"
	game.hint:insert(target)
	
	-- collision
	local function onCollision(event)
		if ( event.phase == "ended" 
			and event.object1.itemID ~= nil 
			and event.object1.itemID == event.object2.itemID) then
				local targetObj, itemObj
				if event.object1.itemType ~= nil then
					targetObj, itemObj = event.object1, event.object2
				else
					targetObj, itemObj = event.object2, event.object1
				end
				targetObj:removeSelf()
				
				local function removeSelf()
					itemObj:removeSelf()
				end
				timer.performWithDelay(tick*.5, removeSelf)
        end
	end
	Runtime:addEventListener("collision",onCollision)
	
	print("Current Position: "..event.position)
	return true
end

local function onComplete( event )
	-- TODO
	print("Level Complete!")
	currentGame.gameContent:dispatchEvent{name="comlete", target=currentGame.gameContent}
end

--[[	
	Public Functions
--]]

-- record current Game
currentGame = nil

-- Load a game by param
function loadGame( param )
	-- Init physic
	physics.start()
	physics.setGravity( 0, 10 )
	physics.setDrawMode( "normal" )
	
	-- init Game
	currentGame = {} -- Game Data
	currentGame.status = "ready"
	currentGame.param = param
	
	-- SetLayers
	currentGame.gameContent = layout.group() -- main Game
	local content = currentGame.gameContent
	content.canvas = layout.group() -- Game Canvas
	content:insert(content.canvas)
	content.hint = layout.group() -- Game Hint Layer
	content:insert(content.hint)
	content.sfx = layout.group() -- Game SFX Layer
	content:insert(content.sfx)
	content.ui = layout.group() -- Game UI
	content:insert(content.ui)
	
	-- Set background
	local gamebg = display.newImage( res.getArt('bg', param.bg ))
	content.canvas:insert(gamebg)
	-- Set Basic UI
	content.ui:insert(display.newText( "Score: 0", 10, 18, "Helvetica", 16 ))
	
	-- Load the level
	currentGame.level = levelManager.loadLevel(param.level) -- Level init
	
	-- If game should start at beginning
	if(param.startAtBegin) then
		-- Level Start
		startGame(param.subLevel)
	end
	
	return currentGame.gameContent
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
	-- Clear Game
	currentGame.param = nil
	currentGame.status = nil
	currentGame.level:dispose()
	currentGame.level = nil
	
	-- remove GameContent
	currentGame.gameContent:removeSelf()
	currentGame.gameContent=nil
	currentGame = nil
	
	-- End physics
	physics.stop()
end