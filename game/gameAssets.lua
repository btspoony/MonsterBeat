-- copy needed functions to local scope
local ipairs = ipairs

module (..., package.seeall)

--[[
	throwable part
--]]
local throwables = require('model/throwables')

--[[
param: 
	type
	count
	name
]] 	
function geneThrowable( param , container)
	-- init item Group
	local itemGroup = layout.group()
	container:insert(itemGroup)
	
	-- Type Check
	local itemLib = nil
	if(param.type == 'things') then
		itemLib = throwables.things
	else
		itemLib = throwables.food
	end
	
	-- prepare to gene items
	math.randomseed(os.time())
	local function createItem(group, src)
		local left = math.random(10)
		local top = math.random(10)
		local newItem = display.newImage( group, src, left, top)
		
		if(math.random()>.7) then
			newItem.alpha = math.random() * .3+ .7
		end
		
		return newItem
	end
	-- new item creation
	local itemNew = nil
	local count = param.count or 1
	if param.name ~= nil then
		for i,v in ipairs(itemLib) do
			if itemLib[i].name == param.name then
				for n=1,count do
					createItem(itemGroup, res.getArt('things', itemLib[i].asset..itemLib[i].ext))
				end
				break
			end
		end
	else
		local itemMax = #itemLib
		for n=1,count do
			local r = math.random(1, itemMax)
			createItem(itemGroup, res.getArt('things', itemLib[r].asset..itemLib[r].ext))
		end
	end

	return itemGroup
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