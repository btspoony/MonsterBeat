module(..., package.seeall)

-- Reference 
local uiManager 	= require( utils.uipath('manager') )
local layout 		= require('layout')

-- Tab Button Something...
local function TabButtonHandler( self, e )
	local phase = e.phase
	local normal = self[1]
	local toggle = self[2]
	local onRelease = self.onRelease
		
	if( phase == "began" ) then
		-- Subsequent touch events will target button even if they are outside the contentBounds of button
		display.getCurrentStage():setFocus( self )
		self.isFocus = true
	elseif( self.isFocus ) then
		local bounds = self.contentBounds
		local x,y = e.x,e.y
		local isWithinBounds =  bounds.xMin <= x
							and bounds.xMax >= x 
							and bounds.yMin <= y 
							and bounds.yMax >= y

		if( phase == "ended" or phase == "cancelled" ) then 
			
			-- normal.isVisible = not normal.isVisible
			-- toggle.isVisible = not toggle.isVisible

			if "ended" == phase then
				-- Only consider this a "click" if the user lifts their finger inside button's contentBounds
				if isWithinBounds then
					if onRelease then
						onRelease( e )
					end
				end
			end
			
			-- Allow touch events to be sent normally to the objects they "hit"
			display.getCurrentStage():setFocus( self, nil )
			self.isFocus = false
		end
	end
	
	return true
end

local function TabButton( args )
	-- arguments references
	local normal = display.newImage( args.normal )
	local toggle = display.newImage( args.toggle )
	local onRelease = args.onRelease or function() return true end
	
	-- create button
	local btn = display.newGroup()
	btn:insert( normal )
	btn:insert( toggle )
	
	btn.onRelease = onRelease
	btn.touch = TabButtonHandler
	btn:addEventListener( 'touch', btn )
	
	function btn:enable()
		normal.isVisible = true
		toggle.isVisible = false
	end
	
	function btn:disable()
		normal.isVisible = false
		toggle.isVisible = true
	end
	
	-- override removeSelf
	local removeSelf = btn.removeSelf
	function btn:removeSelf()
		self:removeEventListener( 'touch', self )
		removeSelf( self )
	end
	
	-- init
	btn:enable()
	return btn
end

-- Tab Window

function new( args )
	-- arguments references
	local tabs = args.tabs
	local background = display.newImage( args.background )
	local onChange = args.onChange or function() return true end
	-- variables
	local currentIndex = 0
	local isShow = false
	local contentHolder, btnHolder
	
	-- create tab window
	local g = layout.group()
	g.showYPos = 0		-- default, set by setting_start
	g.hideYPos = -200	-- default, set by setting_start
	function g:show()
		self:hide()
		btnHolder[ currentIndex ]:disable()
		isShow = true
		transition.to( self, { y = self.showYPos, time = 800, transition = easing.outQuad } )
	end
	
	function g:hide()
		isShow = false
		for i=1, btnHolder.numChildren do
			btnHolder[i]:enable()
		end
		transition.to( self, { y = self.hideYPos, time = 800, transition = easing.outQuad } )
	end
	
	-- create content holder is a group
	contentHolder = layout.group()
	
	-- create tab buttons holder is a hgroup
	btnHolder = layout.hgroup()
	btnHolder.gap = 1
	btnHolder.y = background.height - 1
	
	-- handler of tab button release
	function tabBtnRelaseHandler( e )
		local oldIndex = currentIndex
		local newIndex = e.target.index
		currentIndex = newIndex
		
		-- highlight the clicking btn
		for i=1, btnHolder.numChildren do
			local btn = btnHolder[i]
			if( btn == e.target ) then
				
				btn:enable()
			end
		end
		
		print( 'click tab' .. tostring( newIndex ) )
		
		-- change content and dispatch event onChange
		if ( oldIndex ~= newIndex ) then
			for i = 1, contentHolder.numChildren do
				contentHolder[i]:removeSelf()
			end
			local content = uiManager.getUI( tabs[ newIndex ].content )
			contentHolder:insert( content )
		end
		
		-- show / hide
		if ( oldIndex == newIndex ) and isShow then
			g:hide()
		else
			g:show()
		end
		
		-- dispatch event
		onChange{ target = g, isShow = isShow }
	end
	
	-- create tab buttons
	for i=1, #tabs do
		local tabBtn = TabButton{
			normal = tabs[i].btn_normal,
			toggle = tabs[i].btn_toggle,
			onRelease = tabBtnRelaseHandler,
		}
		tabBtn.index = i
		
		btnHolder:insert( tabBtn )
	end
	
	btnHolder:adjust()
	
	-- init the tab window
	g:insert( background )
	g:insert( btnHolder )
	g:insert( contentHolder )
	
	return g
end
