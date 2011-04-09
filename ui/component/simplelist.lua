module(..., package.seeall)
 
--properties

local currentTarget, detailScreen, velocity, currentDefault, currentOver, prevY
local startTime, lastTime, prevTime = 0, 0, 0
 
--methods
 
function showHighlight(event)
    local timePassed = system.getTimer() - startTime
 
    if timePassed > 100 then 
        print("highlight")
        currentDefault.isVisible = false
        currentOver.isVisible = true
        Runtime:removeEventListener( "enterFrame", showHighlight )
    end
end
  
function newListItemHandler(self, event) 
        local t = currentTarget --could use self.target.parent possibly
        local phase = event.phase
        print("simple list: ".. phase)
 
        local default = self.default
        local over = self.over

		local result = true        
        
        if( phase == "began" ) then
            -- Subsequent touch events will target button even if they are outside the contentBounds of button
            display.getCurrentStage():setFocus( self )
            self.isFocus = true
			
			startPos = event.y

            if over then
                currentDefault = default
                currentOver = over
                startTime = system.getTimer()
                Runtime:addEventListener( "enterFrame", showHighlight )
            end
             
        elseif( self.isFocus ) then
 
            if( phase == "moved" ) then     
  
                Runtime:removeEventListener( "enterFrame", showHighlight )
                if over then 
                    default.isVisible = true
                    over.isVisible = false
                end
  
            elseif( phase == "ended" or phase == "cancelled" ) then 

                local dragDistance = event.y - startPos

                local bounds = self.contentBounds
                local x, y = event.x, event.y
                local isWithinBounds = bounds.xMin <= x and bounds.xMax >= x and bounds.yMin <= y and bounds.yMax >= y
        
                -- Only consider this a "click", if the user lifts their finger inside button's contentBounds
                if isWithinBounds and (dragDistance < 10 and dragDistance > -10 ) then
                    result = self.onRelease(event)
                end
 
                -- Allow touch events to be sent normally to the objects they "hit"
                display.getCurrentStage():setFocus( nil )
                self.isFocus = false
 
                if over then 
                    default.isVisible = true
                    over.isVisible = false
                    Runtime:removeEventListener( "enterFrame", showHighlight )
                end 
            end
        end
        
        return result
end
 
function newListItem(params)
        local data = params.data
        local default = params.default
        local over = params.over
        local onRelease = params.onRelease
        local callback = params.callback 
        local id = params.id
 
        local thisItem = display.newGroup()
		
		-- create item background
        if params.default then
			default = display.newImage( params.default )
			thisItem:insert( default )
			thisItem.default  = default
        end
        
        if params.over then
			over = display.newImage( params.over )
			over.isVisible = false
			thisItem:insert( over )
			thisItem.over = over 
        end
		
		-- create item label, just supports id < 10
		local label = display.newImage( res.getArt( 'ui', 'ready/number' .. id .. '.png' ) )
		label.x = default.width * .33
		label.y = default.height * .5
		thisItem:insert( label )
		
		-- create stars, affected by data
		local star
		for i = 1, data, 1 do
			star = display.newImage( res.getArt( 'ui', 'ready/star.png' ) )
			star.x = default.width + 17 - star.width * ( i - 1 )
			star.y = default.height * .76
			thisItem:insert( star )
		end
 
        thisItem.id = id
        thisItem.data = data
        thisItem.onRelease = onRelease		
		
        thisItem.touch = newListItemHandler
        thisItem:addEventListener( "touch", thisItem )
        
        return thisItem
end
 
function newList(params) 
        local data = params.data
        local default = params.default
        local over = params.over
        local onRelease = params.onRelease
		
		
        --setup the list view
        local listView = display.newGroup()
        local prevY, prevH = 0, 0
		
        
        --iterate over the data and add items to the list view
		local thisItem
		for i=1, #data do
			thisItem = newListItem{
				data = data[i],
				default = default,
				over = over,
				onRelease = onRelease,
				id = i
			}

			listView:insert( thisItem )     

			thisItem.y = prevY + prevH

			--save the Y and height 
			prevY = thisItem.y
			prevH = thisItem.height		
		end --for
        
		-- align by top center
        listView.x = -thisItem.default.width * .5
        listView.y = 0
        
		-- container
		local g = display.newGroup()
		
		function g:cleanUp()
			print("tableView cleanUp")
            Runtime:removeEventListener( "enterFrame", showHighlight )
			local i
			for i = listView.numChildren, 1, -1 do
				--test
				listView[i]:removeEventListener("touch", newListItemHandler)
				listView:remove(i)
				listView[i] = nil
			end
		end
		
		
		local removeSelf = g.removeSelf;
		function g:removeSelf()
			g:cleanUp()
			removeSelf( g )
		end
		g:insert( listView )
		
        return g
end

--look for an item in a table
function in_table ( e, t )
	for _,v in pairs(t) do
		if (v==e) then return true end
	end
	return false
end

