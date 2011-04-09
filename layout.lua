module(..., package.seeall)

function group()
	local g = display.newGroup()
	
	-- test code
	-- local bg = display.newRect( 0,0, display.contentWidth, display.contentHeight )
	-- bg:setFillColor( 0, 0, 255, 255 )
	-- g:insert( bg )
	-- test code
	
	-- override
	local removeSelf = g.removeSelf
	function g:removeSelf()
		local i = g.numChildren
		while i > 0 do
			if g[i] then
				local child = g[i]
				
					-- if child.cleanUp then child:cleanUp()
				-- elseif child.destroy then child:destroy()
				-- elseif child.dispose then child:dispose() end
				
				child:removeSelf()
			end
			
			i = i - 1
		end
		removeSelf( g )
	end
	
	return g
end


function background( layout )
	return display.newImage( layout.src )
end