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
			x = display.contentWidth * .5,
			y = display.contentHeight * .65,
		},
	}
	-- event handlers
}
