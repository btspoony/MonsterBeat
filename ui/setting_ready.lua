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
			src = res.getArt('ui','ready/bg.png'),
		},
		{
			type = "ready_chooser",
			x = display.contentWidth * .5,
			y = display.contentHeight * .35,
		},
		{
			type = "ready_back",
		},
	}
	-- event handlers
}
