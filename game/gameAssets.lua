-- copy needed functions to local scope
local ipairs = ipairs

module (..., package.seeall)

--[[
	init part
--]]
local throwables = require('model/throwables')
--Physic
local scaleFactor = 1.0
local physicsData = require(res.physicsFile()).physicsData(scaleFactor)

--[[
param: 
	type
	count
	name
]] 	
function geneThrowable( param , container)
	-- Type Check
	local itemLib = nil
	if(param.type == 'things') then
		itemLib = throwables.things
	else
		itemLib = throwables.food
	end
	
	-- prepare to gene items
	math.randomseed(os.time())
	local function createItem(group, itemInfo)
		--Create Item
		local left = math.random(10)
		local top = math.random(10)
		local newItem = display.newImage( group,
		 	res.getArt('things', itemInfo.asset..itemInfo.ext), left, top)
		group:insert(newItem)
		-- id
		newItem.itemID = "ID"..system.getTimer().."R"..math.random(99)
		
		-- Add Physic Body
		physics.addBody( newItem, physicsData:get(itemInfo.asset) )
		
		-- Create Shadow SFX
--		local spot = display.newCircle( xCenter, yCenter, radius )
		
		return newItem
	end
	-- new item creation
	local itemNew = nil
	if param.name ~= nil then
		for i,v in ipairs(itemLib) do
			if itemLib[i].name == param.name then
				itemNew = createItem(container, itemLib[i])
				break
			end
		end
	else
		local r = math.random(1, #itemLib)
		itemNew = createItem(container, itemLib[r])
	end

	return itemNew
end

function release( target )
	target:removeSelf()
end

--[[
	npc part
--]]
function geneNPC( name , container)
	-- init npc graphic
	local npc = display.newImage( container, res.getArt('chars',name))
	
	-- TODO Later should be a sprite with animation
	
	return npc
end