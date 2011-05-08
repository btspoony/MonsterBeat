module (..., package.seeall)


-- public 
minCommandLength = 999
maxCommandLength = 0

local actionMap = {}

--[[
	register action
	@param name
	@param commands
--]]
function registerAction( name, commands )
	actionMap[ name ] = commands
	
	local length = #commands
	if ( length < minCommandLength ) then
		minCommandLength = length
	elseif ( length > maxCommandLength ) then
		maxCommandLength = length
	end
end

local function match( a, b )
	if ( #a ~= #b ) then
		return false;
	end
	
	for i=0, #a do
		if ( a[i] ~= b[i] ) then
			return false
		end
	end
	
	return true
end

function getMatchedAction( commands )
	for i, v in pairs( actionMap ) do
		if ( match( v, commands ) ) then
			return i
		end
	end
	
	return nil
end
