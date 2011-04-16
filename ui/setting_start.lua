module(..., package.seeall)

layout=
{
	-- properties
	type = "group",
	-- ui children
	children=
	{
		{
			type = "background",
			src = res.getArt('ui','start/bg.png'),
		},
		{
			type = "start_slide",
			name = 'slider',
			
			hideYPos = display.contentHeight * .28,
			showYPos = display.contentHeight * .65,
			
			x = display.contentWidth * .5,
			y = display.contentHeight * .65,
		},
	}
	-- event handlers
}
