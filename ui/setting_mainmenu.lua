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
			src = res.getArt('ui','mainmenu/bg.png'),
		},
		{
			type = "mainmenu_play",
			x = display.contentWidth  * .5,
			y = display.contentHeight * .5,
		},
	}
	-- event handlers
}
