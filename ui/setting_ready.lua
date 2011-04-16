module(..., package.seeall)

layout=
{
	-- properties
	type = "group",
	-- ui children
	children=
	{
		-- {
			-- type = "background",
			-- src = res.getArt('ui','ready/bg.png'),
		-- },
		{
			type = "ready_chooser",
			name = 'list',
			
			x = display.contentWidth * .5,
			y = display.contentHeight * .45,
		},
		{
			type = "ready_back",
			
			x = 30,
			y = 30,
		},
	}
	-- event handlers
}
