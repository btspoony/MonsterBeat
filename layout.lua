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
		for i = self.numChildren, 1, -1 do
			if self[i].removeSelf then
				self[i]:removeSelf()
			end
		end
		removeSelf( self )
	end
	
	function g:getChildByName( name )
		for i, v in ipairs( self._layout.children ) do
			if name == v.name then
				return self[i]
			end
		end
		
		return nil
	end
	
	return g
end

function hgroup()
	local g = group()
	
	function g:adjust()
		local gap = g.gap or 5
		
		for i=2, self.numChildren do
			-- guess the registration point is always at center
			g[i].x = g[i - 1].x + ( g[i - 1].width + g[i].width ) * .5 + gap
		end
	end
	
	return g
end

function background( layout )
	return display.newImage( layout.src )
end