-- slideView.lua
-- 
-- Version 1.0 
--
-- Copyright (C) 2010 ANSCA Inc. All Rights Reserved.
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy of 
-- this software and associated documentation files (the "Software"), to deal in the 
-- Software without restriction, including without limitation the rights to use, copy, 
-- modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, 
-- and to permit persons to whom the Software is furnished to do so, subject to the 
-- following conditions:
-- 
-- The above copyright notice and this permission notice shall be included in all copies 
-- or substantial portions of the Software.
-- 
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
-- INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR 
-- PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE 
-- FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR 
-- OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER 
-- DEALINGS IN THE SOFTWARE.

module(..., package.seeall)

-- local screenW, screenH = display.contentWidth, display.contentHeight
-- local viewableScreenW, viewableScreenH = display.viewableContentWidth, display.viewableContentHeight
-- local screenOffsetW, screenOffsetH = display.contentWidth -  display.viewableContentWidth, display.contentHeight - display.viewableContentHeight

local imgNum = nil
local images = nil
local nextImage, prevImage, cancelMove, slideTo, sliding
local hitarea, imageHolder
-- local imageNumberText, imageNumberTextShadow
local startPos, prevPos


local RADIUS_X = 640
local RADIUS_Y = 50
local INC_ROT = 10
local INC_RAD = math.rad( INC_ROT )
local START_RAD = -math.pi / 2


function new( args )
	local imageSet 		= args.imageSet
	local onSelect		= args.onSelect

	local g = display.newGroup()
	
	-- create hitarea
	local hitarea = g
	-- hitarea = display.newRect( 0, 0, screenW, screenH-(top+bottom) )
	-- hitarea:setFillColor(0, 0, 0)
	-- g:insert(hitarea)
	
	-- create images
	imageHolder = display.newGroup()
	g:insert( imageHolder )
	
	-- local h = viewableScreenH - ( top + bottom ) 
	-- imageHolder.x = screenW * .5
	-- imageHolder.y = h * .5
	imageHolder.slidePos = 0
	
	images = {}
	for i = 1,#imageSet do
		local p = display.newImage(imageSet[i])
		-- if p.width > viewableScreenW or p.height > h then
			-- if p.width/viewableScreenW > p.height/h then 
					-- p.xScale = viewableScreenW/p.width
					-- p.yScale = viewableScreenW/p.width
			-- else
					-- p.xScale = h/p.height
					-- p.yScale = h/p.height
			-- end		 
		-- end
		imageHolder:insert(p)
		images[i] = p
		
		p.oxScale = p.xScale
		p.oyScale = p.yScale
	end
	
	-- init slide pose
	sliding()
	
	-- create nar text display
	-- local defaultString = "1 of " .. #images

	-- local navBar = display.newGroup()
	-- g:insert(navBar)
	
	-- local navBarGraphic = display.newImage("start/navBar.png", 0, 0, false)
	-- navBar:insert(navBarGraphic)
	-- navBarGraphic.x = viewableScreenW*.5
	-- navBarGraphic.y = 0
			
	-- imageNumberText = display.newText(defaultString, 0, 0, native.systemFontBold, 14)
	-- imageNumberText:setTextColor(255, 255, 255)
	-- imageNumberTextShadow = display.newText(defaultString, 0, 0, native.systemFontBold, 14)
	-- imageNumberTextShadow:setTextColor(0, 0, 0)
	-- navBar:insert(imageNumberTextShadow)
	-- navBar:insert(imageNumberText)
	-- imageNumberText.x = navBar.width*.5
	-- imageNumberText.y = navBarGraphic.y
	-- imageNumberTextShadow.x = imageNumberText.x - 1
	-- imageNumberTextShadow.y = imageNumberText.y - 1
	
	-- navBar.y = math.floor(navBar.height*0.5)
	
	-- function setSlideNumber()
		-- print("setSlideNumber", imgNum .. " of " .. #images)
		-- imageNumberText.text = imgNum .. " of " .. #images
		-- imageNumberTextShadow.text = imgNum .. " of " .. #images
	-- end
	
	-- init
	imgNum = 1
	
	-- g.x = 0
	-- g.y = top + display.screenOriginY
	
	Runtime:addEventListener( 'enterFrame', sliding )
	
	hitarea:addEventListener( "touch", hitarea )
	
	local dragSpeed = 0
	local touchTime = 0
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
				
				imageHolder.slidePos = imageHolder.slidePos + dragSpeed * .001
				-- imgNum = - math.floor( imageHolder.slidePos / INC_RAD ) + 1
				-- if imgNum < 1 then
					-- imgNum = 1
				-- elseif imgNum > #images then
					-- imgNum = #images
				-- end
				
			elseif ( phase == "ended" or phase == "cancelled" ) then
				
				local dragDistance = e.x - startPos
				print("dragDistance: " .. dragDistance)
				print("dragSpeed: " .. dragSpeed)
				local bounds = images[ imgNum ].contentBounds
				local x, y = e.x, e.y
				local isTapCurrent =( x >= bounds.xMin )
								and ( x <= bounds.xMax )
								and ( y >= bounds.yMin )
								and ( y <= bounds.yMax )
				
				if (dragDistance < -40 and imgNum < #images) then
					nextImage()
					isTapCurrent = false
				elseif (dragDistance > 40 and imgNum > 1) then
					prevImage()
					isTapCurrent = false
				else
					cancelMove()
				end
				
				if ( phase == "cancelled" ) then		
					cancelMove()
					isTapCurrent = false
				end
				
				-- Allow touch events to be sent normally to the objects they "hit"
				display.getCurrentStage():setFocus( nil )
				self.isFocus = false
				
				if 'ended' == phase and isTapCurrent == true then
					if onSelect then
						if (math.abs(dragSpeed) < 1) and (e.time - touchTime) < 500 then
							onSelect( e )
						end
					end
				end
			end
		end
					
		return true
		
	end

	------------------------
	-- Define public methods
	
	function g:jumpToImage(num)
		slideTo( num )
	end

	function g:cleanUp()
		print("slides cleanUp")
		hitarea:removeEventListener( 'touch', hitarea )
		Runtime:removeEventListener( 'enterFrame', sliding )
		if tween then transition.cancel( tween ) end
	end
	
	local removeSelf = g.removeSelf;
	function g:removeSelf()
		g:cleanUp()
		removeSelf( g )
	end

	return g	
end




function nextImage()
	slideTo( imgNum + 1 )
end


function prevImage()
	slideTo( imgNum - 1 )
end


function cancelMove()
	slideTo( imgNum )
end



function slideTo( num )		
	if num < 1 then num = 1
	elseif num > #images then num = #images end
	
	imgNum = num
	-- setSlideNumber()
	
	local pos = -INC_RAD * ( imgNum - 1 )
	
	tween = transition.to( imageHolder, {time=400, slidePos=pos, transition=easing.outExpo } )
end


function sliding( e )
	for i=1, #images do
		local p = images[i]
		
		local r = imageHolder.slidePos + INC_RAD * ( i - 1 )
		
		local pcos = math.cos( r + START_RAD )
		local psin = math.sin( r + START_RAD )
		local scale = -psin
		if 0 == scale then scale = .00001 end
		
		p.x = pcos * RADIUS_X
		p.y = psin * RADIUS_Y
		p.rotation = pcos * INC_ROT
		p.xScale = p.oxScale * scale
		p.yScale = p.xScale
	end
	
	local tmp = {}
	for i=1, #images do
		tmp[i] = images[i]
	end
	table.sort( tmp, function (a,b) return a.xScale < b.xScale end )
	
	for i=1, #tmp do
		imageHolder:insert( tmp[ i ] )
	end
end
