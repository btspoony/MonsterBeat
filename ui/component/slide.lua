module(..., package.seeall)

local ui			= require( utils.uipath('component/ui') )

local cancelMove, slideTo, sliding
local imgNum, images
local imageHolder, hitarea

local onBack


-- define constants
local IMAGE_GAP = 60
local SENSITIVITY_DRAG = 0.5
local SENSITIVITY_SLIDE = 0.5
local SENSITIVITY_TAP = 0.01
local SLIDE_WIDTH = 300

-- Class Pic
local function Pic( imgSrc )
	local g = ui.newButton{
		default = imgSrc,
		over = imgSrc,
		onRelease = function( e )
			onBack()
		end
	}
	
	local black = display.newRect( 0,0, g.width, g.height )
	black:setFillColor( 0, 0, 0 , 255 )
	black.alpha = 0
	
	local isHighlight = false
	local isTouchEnabled = false
	
	g:insert( black, true )
	
	
	function g:touchEnabled( boo )
		isTouchEnabled = boo
		if ( isTouchEnabled ) then
			print('f')
			self:addEventListener( 'touch', self )
		else
			self:removeEventListener( 'touch', self )
		end
	end
	
	function g:highlight( boo )
		isHighlight = boo
		
		if ( isHighlight ) then
			if ( black.alpha == 0 ) then return end
			transition.to( black, { alpha = 0, time = 300 } )
		else
			local alpha = 1.5 - self.xScale / self.oxScale
			if ( alpha > 1 ) then alpha = 1 end
			transition.to( black, { alpha = alpha, time = 300 } )
		end
	end
	
	function g:hitTest( x, y )
		local bounds = self.contentBounds
		return  ( x >= bounds.xMin )
			and ( x <= bounds.xMax )
			and ( y >= bounds.yMin )
			and ( y <= bounds.yMax )
	end
	
	function g:destroy()
		self:touchEnabled( false )
	end
	
	g:touchEnabled( false )
	
	return g
end
-- Class Pic end

-- Slide
local function enable()
	hitarea:addEventListener( 'touch', hitarea )
	Runtime:addEventListener( 'enterFrame', sliding )
	images[ imgNum ]:touchEnabled( false )
end

local function disable()
	hitarea:removeEventListener( 'touch', hitarea )
	Runtime:removeEventListener( 'enterFrame', sliding )
	images[ imgNum ]:touchEnabled( true )
end

function new( args )
	-- default arguments
	local imageSet 		= args.imageSet
	local onSelect		= args.onSelect
	onBack = args.onBack
	
	-- create slide main group
	local g = display.newGroup()
	
	-- create hitarea that is group self
	hitarea = g
	
	-- create images
	imageHolder = display.newGroup()
	g:insert( imageHolder )
	
	imageHolder.slidePos = 0
	
	images = {}
	for i = 1,#imageSet do
		local p = Pic( imageSet[i] )
		imageHolder:insert(p)
		images[i] = p
		
		p.oxScale = p.xScale
		p.oyScale = p.yScale
		p.x = ( i - 1 ) * IMAGE_GAP
	end
	
	-- init slide pose
	sliding()
	
	-- init
	imgNum = 1
	
	enable()
	
	-- hitTest with depth order
	local function hitTest( x, y )
		
		for i=imgNum, #images do
			local boo = images[ i ]:hitTest( x, y )
			if ( boo ) then return i end
		end
		
		for i=imgNum-1, 1, -1 do
			local boo = images[ i ]:hitTest( x, y )
			if ( boo ) then return i end
		end
		
		return -1
	end
	
	local startPos, prevPos, dragSpeed, touchTime
	
	function hitarea:touch ( e ) 
		local phase = e.phase
		
		print("slides", phase)
		if ( phase == "began" ) then
			-- Subsequent touch events will target button even if they are outside the contentBounds of button
			display.getCurrentStage():setFocus( self )
			self.isFocus = true

			startPos = e.x
			prevPos = e.x
			dragSpeed = 0
			touchTime = e.time
			
		elseif( self.isFocus ) then
		
			if ( phase == "moved" ) then
			
				if tween then transition.cancel(tween) end
				
				dragSpeed = e.x - prevPos
				prevPos = e.x
				
				imageHolder.slidePos = imageHolder.slidePos - dragSpeed * SENSITIVITY_DRAG
				
			elseif ( phase == "ended" or phase == "cancelled" ) then
			
				local dis = e.x - startPos
				local dt = e.time - touchTime
				local v = dis / dt
				
				print( 'v='..v )
				
				-- locate slide
				local num = math.floor( ( imageHolder.slidePos + imageHolder[1].width * .5 ) / IMAGE_GAP )
				slideTo( num )
				
				-- ???
				if ( phase == "cancelled" ) then		
					cancelMove()
				end
				
				-- Allow touch events to be sent normally to the objects they "hit"
				display.getCurrentStage():setFocus( nil )
				self.isFocus = false
				
				if 'ended' == phase then
					if math.abs( v ) < SENSITIVITY_TAP then
						local num = hitTest( e.x, e.y )
						if ( num == imgNum ) then
							if onSelect then onSelect( e ) end
						elseif ( num ~= -1 ) then
							slideTo( num )
						end
					end
				end
			end
		end
					
		return true
		
	end

	------------------------
	-- Define public methods
	
	-- concrete effect functions
	function g:rise( args )
		local moveY = args.moveY or -200
		local onComplete = args.onComplete
		
		for i = 1, #images do
			local p = images[ i ]
			
			if ( i == imgNum ) then
				p:highlight( true )
			else
				p:highlight( false )
			end
		end
		
		transition.to( images[ imgNum ], {
			y = moveY - self.y, -- minus self.y 
			time = 800,
			onComplete = onComplete,
			transition = easing.outQuad
		} )
		
		disable()
	end
	
	function g:back( args )
		local moveY = args.moveY or 0
		local onComplete = args.onComplete
		
		for i = 1, #images do
			local p = images[ i ]
			p:highlight( true )
		end
		
		transition.to( images[ imgNum ], { 
			y = moveY - self.y, -- minus self.y 
			time = 500, 
			onComplete = onCompletem,
			transition = easing.outQuad
		} )
		
		enable()
	end
	
	-- slide to immediately
	function g:jumpToImage(num)
		slideTo( num )
	end
	
	-- clean up resources
	function g:cleanUp()
		print("slides cleanUp")
		hitarea:removeEventListener( 'touch', hitarea )
		Runtime:removeEventListener( 'enterFrame', sliding )
		if tween then transition.cancel( tween ) end
		for i = 1, #images do
			images[i]:destroy()
		end
	end
	
	-- override removeSelf
	local removeSelf = g.removeSelf;
	function g:removeSelf()
		g:cleanUp()
		removeSelf( g )
	end

	return g	
end


function cancelMove()
	slideTo( imgNum )
end


function slideTo( num )		
	if num < 1 then num = 1
	elseif num > #images then num = #images end
	
	imgNum = num
	
	local pos = IMAGE_GAP * ( imgNum - 1 )
	
	tween = transition.to( imageHolder, {time=400, slidePos=pos, transition=easing.outExpo } )
end

function sliding( e )
	-- moving
	for i=1, #images do
		local p = images[i]
		
		imageHolder.x = -imageHolder.slidePos
		
		local dx = p.x - imageHolder.slidePos
		local ra = dx / SLIDE_WIDTH
		local sc = ra
		if ( sc < 0 ) then sc = -sc end
		
		local xs = p.oxScale - p.oxScale * sc
		local ys = p.oyScale - p.oyScale * sc
		if ( 0 == xs ) then xs = 0.0001 end
		if ( 0 == ys ) then ys = 0.0001 end
		p.xScale = xs
		p.yScale = ys
		p.rotation = ra * 57.3
		p.y = sc * 55
	end
	
	-- depth sort
	local tmp = {}
	for i=1, #images do
		tmp[i] = images[i]
	end
	table.sort( tmp, function (a,b) return a.xScale < b.xScale end )
	for i=1, #tmp do
		imageHolder:insert( tmp[ i ] )
	end
end
