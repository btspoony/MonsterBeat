module (..., package.seeall)

--[[	
	Private Group
--]]
-- Managers
local gestureManager = require( utils.gamepath('GestureManager') )
local actionManager = require( utils.gamepath('ActionManager') )
local levelManager = require( utils.gamepath('LevelManager') )


-- Basic Gameplay

actionManager.registerAction( 'hadogen',  { gestureManager.G_DOT,
											gestureManager.G_DOT,
											gestureManager.G_LINE } )
actionManager.registerAction( 'hoyugen',  { gestureManager.G_DOT,
											gestureManager.G_LINE,
											gestureManager.G_DOT } )
actionManager.registerAction( 'malisgu',  { gestureManager.G_LINE,
											gestureManager.G_LINE,
											gestureManager.G_DOT } )

-- handle action of player or npc
local function handleAction( action )
	currentGame.avsb:A2B( { name = action } )
end
local function handleNPC( action )
	currentGame.avsb:B2A( { name = action } )
end


--[[
gesture struct
	gesture.name
	gesture.beginTime
	gesture.endTime
	gesture.data
--]]
-- gesture feedback
local function feedback_dot( parent, data )
	local dot = display.newCircle( data[1].x, data[1].y, 2 )
	transition.to( dot, { width = 15, height = 15, alpha = 0,
		onComplete = function() dot:removeSelf() end
	} )
end
local function feedback_line( parent, data )
	local line = display.newLine( data[1].x, data[1].y, data[1].x, data[1].y )
	for i=2, #data do
		line:append( data[i].x, data[i].y )
	end
	transition.to( line, { alpha = 0,
		onComplete = function() line:removeSelf() end
	} )
end
local function feedback( gesture )
	if ( gesture.name == gestureManager.G_DOT ) then
		feedback_dot( currentGame.gameContent.ui, gesture.data )
	else
		feedback_line( currentGame.gameContent.ui, gesture.data )
	end
end

-- handle gesture generating
local gestures = {}
local function handleGesture( gesture )
	-- draw feedback
	feedback( gesture )
	
	-- bad beat
	local result, index = currentGame.level:inBeat( gesture.endTime )
	if ( not result ) then
		gestures = {}
		return
	end
	
	-- no continuous beats
	local length = #gestures
	if ( length > 0 ) then
		if ( gestures[ length ]._beatIndex + 1 ~= index ) then
			gestures = {}
		end
	end


	-- dirty ref
	gesture._beatIndex = index
	-- record gesture
	table.insert( gestures, gesture )
	
	-- limit
	length = #gestures
	if ( length < actionManager.minCommandLength ) then return end
	if ( length > actionManager.maxCommandLength ) then table.remove( gestures, 1 ) end
	
	length = #gestures
	
	print("!!!!!!!!!!!!!!")
	local sss = ''
	for i=1, length do
		sss = sss .. gestures[i].name
	end
	print("gestures:", sss)
	print("##############")

	-- check action
	local count,i,j
	for count = actionManager.minCommandLength,
			actionManager.maxCommandLength do
		for i=1, length - count + 1 do
			-- get gesture.name
			local commands = {}
			for j=i, i + count - 1 do
				table.insert ( commands, gestures[ j ].name )
			end

			-- get matched action
			local action = actionManager.getMatchedAction( commands )
			if ( action ) then
				handleAction( action )
				gestures = {}
				return
			end
		end
	end
end


local function handleEnterFrame( e )
	if( math.random() < .01 ) then
		handleNPC( 'fire ball' )
	end
end

local function onSpawn( event )
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
	

	-- temporory
	currentGame.avsb = require(utils.gamepath('AvsB')).init( content )

	-- load level
	currentGame.level = levelManager.loadLevel( param.level )
	-- init gesture
	currentGame.gesture = gestureManager.init{
		hitarea = content.ui:getChildByName('hitarea'),
		onGesture = function( gesture ) handleGesture( gesture ) end
	}
	-- init npc
	currentGame.npc = function()
		handleNPC()
	end

	
	-- If game should start at beginning
	if(param.startAtBegin) then
		-- Level Start
		startGame()
	end
	
	return currentGame.gameContent
end

-- Start
function startGame()
	if currentGame == nil or currentGame.status ~= "ready" then
		return nil
	end
	
	-- Start Game Level
	currentGame.level:startLevel{ onSpawn = onSpawn, onComplete = onComplete }
	
	currentGame.status = "started"

	Runtime:addEventListener( 'enterFrame', handleEnterFrame )
end

-- Game Control
function pauseGame()
	currentGame.level:pauseLevel()
	Runtime:removeEventListener( 'enterFrame', handleEnterFrame )
end

function resumeGame()
	currentGame.level:resumeLevel()
	Runtime:addEventListener( 'enterFrame', handleEnterFrame )
end

function quitGame()
	-- Clear Game
	Runtime:removeEventListener( 'enterFrame', handleEnterFrame )
	
	currentGame.param = nil
	currentGame.status = nil
	currentGame.level:dispose()
	currentGame.level = nil
	currentGame.gesture.dispose()
	currentGame.gesture = nil
	currentGame.avsb = nil
	currentGame.npc = nil
	
	-- remove GameContent
	currentGame.gameContent:removeSelf()
	currentGame.gameContent=nil
	currentGame = nil
end
