module(..., package.seeall)


-- !! implement is temporory !!

function init( content )

	-- assets
	
	local function AvsB_A()
		local txt = display.newText( 'A', 0,0, native.systemFont, 48 )
		txt:setReferencePoint(display.CenterReferencePoint);
		txt.x = display.contentWidth * .3
		txt.y = display.contentHeight * .2
		return txt
	end

	local function AvsB_B()
		local txt = display.newText( 'B', 0,0, native.systemFont, 48 )
		txt:setReferencePoint(display.CenterReferencePoint);
		txt.x = display.contentWidth * .7
		txt.y = display.contentHeight * .2
		return txt
	end

	local function AvsB_Text()
		local txt = display.newText( ' ', 0,0, native.systemFont, 12 )
		txt:setReferencePoint(display.CenterReferencePoint);
		txt.x = display.contentWidth * .5
		txt.y = display.contentHeight * .5
		return txt
	end

	local function AvsB_Area()
		local rect = display.newRect( 0, 0, display.contentWidth , 160 )
		rect:setFillColor( 40, 40, 40 )
		rect.x = display.contentWidth * .5
		rect.y = display.contentHeight - 160 + 80
		rect.name = 'hitarea'
		return rect
	end
	
	-- effects

	local function shake( ob )
		local times = 8
		local ox = ob.x
		local oy = ob.y
		function f()
			times = times - 1
			if ( 0 == times ) then
				ob.x = ox
				ob.y = oy
			else
				ob.x = ob.x + math.random() * 8 - 4
				ob.y = ob.y + math.random() * 2 - 1
			end

		end
		timer.performWithDelay( 10, f, times )
	end
	
	local function highlight( parent )
		local rect = display.newRect( 0,0, display.contentWidth, display.contentHeight - 160 )
		rect.strokeWidth = 5
		rect:setStrokeColor( 255, 255, 255 )
		rect:setFillColor( 255, 255, 255, 0 )
		
		parent:insert( rect )
		
		local times = 5
		
		function f()
			times = times - 1
			if ( 0 == times ) then
				rect:removeSelf()
			else
				rect.alpha = times % 2
				print('remove')
			end
			print(times)
		end
		timer.performWithDelay( 50, f, times )
	end

	local function showTxt( list )
		if ( #list > 5 ) then
			table.remove( list, 1 )
		end

		return table.concat( list, '\n' )
	end
	
	-- init

	local avsb = {}

	local a = AvsB_A()
	local b = AvsB_B()
	local txt = AvsB_Text()
	local area = AvsB_Area()
	content.canvas:insert( a )
	content.canvas:insert( b )
	content.canvas:insert( txt )
	content.ui:insert( area )

	-- !! implement is temporory !!
	local list = {}
	function avsb:A2B( action )
		table.insert( list, 'A use ' .. action.name ..' to attck B' );
		txt.text = showTxt( list )
		shake( b )
		highlight( content.sfx )
	end

	function avsb:B2A( action )
		table.insert( list, 'B use ' .. action.name .. ' to attck A' );
		txt.text = showTxt( list )
		shake( a )
	end
	
	return avsb
end

