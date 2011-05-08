module (..., package.seeall)

-- define constants
G_DOT = '.'
G_LINE = '-'

-- private
local disX, disY
local prevX, prevY
local beginTime

local onGestureCB

local data

local function handleTouch( self, e )
	local phase = e.phase
		
	if ( 'began' == phase ) then
		self._isFocus = true
		display.getCurrentStage():setFocus( self )
		
		prevX, prevY = e.x, e.y
		disX, disY = 0, 0
		beginTime = e.time
		data = { { x = e.x, y = e.y } }
		
	elseif ( self._isFocus ) then
		if ( 'moved' == phase ) then
			local dx = e.x - prevX
			local dy = e.y - prevY
			prevX, prevY = e.x, e.y
			disX = disX + math.abs( dx )
			disY = disY + math.abs( dy )
			
			table.insert( data, { x = e.x, y = e.y } )
			
		elseif ( 'ended' == phase or 'cancelled' == phase ) then
			local name
			if ( disX > 3 or disY > 3 ) then
				name = G_LINE
			else
				name = G_DOT
			end
			
			print("!! Gesture !!", name )
			onGestureCB{ name = name, endTime = e.time, beginTime = beginTime, data = data }
			
			display.getCurrentStage():setFocus( self )
			self._isFocus = false
		end
	end
end


function init( param )
	local gesture = {}
	
	onGestureCB = param.onGesture
	
	gesture.hitarea = param.hitarea
	gesture.hitarea.touch = handleTouch
	gesture.hitarea:addEventListener( 'touch', gesture.hitarea )

	function gesture:dispose()
		self.hitarea:removeEventListener( 'touch', self.hitarea )
		self.hitarea = nil
		self.onGestureCB = nil
	end
	
	return gesture
end
