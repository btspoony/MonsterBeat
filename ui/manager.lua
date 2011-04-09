module(..., package.seeall)

local assets = 		require( utils.uipath('assets') )
local controller = 	require( utils.uipath('controller') )

local _uiList = {}
local _uiListIndex = 0
local _currentUI
local _uiCache = {}

------------------------------------------ Push UI
-- push ui
function pushUI( ui )
	_currentUI = ui
	
	_uiListIndex = _uiListIndex + 1
	_uiList[ _uiListIndex ] = _currentUI
	display.getCurrentStage():insert( _currentUI )

	print('push', _currentUI)
	-- utils.printTable( _currentUI )

	-- TODO debug
	-- _currentUI:dispatchEvent( { name = "pushToStage", target = _currentUI } )
	
	return ui
end

------------------------------------------ Pop UI
-- pop ui
function popUI( clean )
	if _uiListIndex < 1 then return nil end

	local ui = _uiList[ _uiListIndex ]
	if clean then _uiCache[ ui._layout ] = nil end

	print('pop', ui)
	
	_uiList[ _uiListIndex ] = nil
	_uiListIndex = _uiListIndex - 1
	if _uiListIndex > 0 then _currentUI = _uiList[ _uiListIndex ]
	else _currentUI = nil end
	-- TODO debug
	--ui:dispatchEvent({ name='popFromStage', target = ui })

	return ui
end

------------------------------------------ Get Current UI
-- current ui
function getCurrentUI()
	return _currentUI
end

------------------------------------------ Create UI From Setting
local factory, create
-- get a ui from setting
function getUI( setting )
	local layout = _G[ setting ].layout
	
	if not _uiCache[ layout ] then
		_uiCache[ layout ] = create( layout )
	end
	
	return _uiCache[ layout ]
end
-- ui factory
function factory( a_type )
	if assets[ a_type ] then return assets[ a_type ]() end
	if layout[ a_type ] then return layout[ a_type ]() end
	
	error('Unknow type:'..a_type)
end
-- create component or layout
function create( layout )
	-- create component
	local comp = factory( layout.type )

	-- setup (dirty) properties
	comp._layout = layout

	for i,v in pairs( layout ) do
		comp[i] = v
	end
	-- register events
	if layout.eventHandlers then
		for i,v in pairs( layout.eventHandlers ) do
			comp:addEventListener( i, controller[ v ] )
		end
	end
	-- create children
	if comp.insert then
		if layout.children then
			for i,v in ipairs( layout.children ) do
				comp:insert( create( v ) )
			end
		end
	end
	-- adjust
	if comp.adjust then
		comp:adjust()
	end

	-- return component
	return comp
end

