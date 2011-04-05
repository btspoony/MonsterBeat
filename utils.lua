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

-- display the fps and texture memory useage
function Stats( params )
	local stage 
	
	if( params and params.stage ) then stage = params.stage
	else stage = display.getCurrentStage() end
	
	
	local fps = 0
	
	local g = display.newGroup()
	
	-- create the background
	local bg = display.newRect( 0,0, 200, 30 )
	bg:setFillColor( 0, 0, 32, 200 )
	bg.strokeWidth = 1
	bg:setStrokeColor( 64, 64, 64 )
	g:insert( bg )
	
	-- create the text field
	local txt = display.newText( ' ', 0,0, native.systemFont, 12 )
	txt:setTextColor( 255, 255, 255 )
	g:insert( txt )
	
	-- fps
	function g:enterFrame( e )
		fps = fps + 1
	end
	
	-- update
	function g:timer( e )
		stage:insert( g ) -- top the group
		txt.text = 'FPS: ' .. fps .. '\n' .. 'Texture Memory: ' .. system.getInfo( 'textureMemoryUsed' )
		txt:setReferencePoint( display.TopLeftReferencePoint )
		txt.x = 4
		txt.y = 4
		bg:setReferencePoint( display.TopLeftReferencePoint )
		bg.x = 0
		bg.y = 0
		self:setReferencePoint( display.BottomLeftReferencePoint )
		self.x = 0
		self.y = display.contentHeight
		fps = 0
	end
	
	-- initialize
	g:timer()
	Runtime:addEventListener( 'enterFrame', g )
	timer.performWithDelay( 1000, g, 0 )
	
	return g
end
