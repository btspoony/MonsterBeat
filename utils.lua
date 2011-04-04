module(..., package.seeall)

-- print a table fully
-- useage:
-- printTable( {a={1,2,3}, b={m='1',n='2'}, x=0, y=0} )
function printTable( t, indent, cache )
	if not indent then indent = '' end
	if not cache then cache = {} end

	if cache[t] then return tostring(t) .. '(repeat)\n' end

	cache[t] = 1
	local output = tostring(t) .. '\n'

	for i,v in pairs(t) do
		if type(v) == 'table' then
			output = output .. indent .. i .. '=' .. printTable( v, indent .. '   ', cache )
		else
			output = output .. indent .. i .. '=' .. tostring(v) ..'(' .. type(v) .. ')\n'
		end
	end


	if indent == '' then print('<<PrintTable Begin>>\n'..output..'<<PrintTable End>>') end

	return output
end

-- pack ui enviroment path
function uipath( path )
	return 'ui/' .. path
end

-- pack model enviroment path
function modelpath( path )
	return 'model/' .. path
end

-- pack game enviroment path
function gamepath( path )
	return 'game/' .. path
end