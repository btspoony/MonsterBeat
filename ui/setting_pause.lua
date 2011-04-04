module(..., package.seeall)

layout=
{
	-- properties
	type = "group",
	-- ui children
	children=
	{
		{
			type = "pause_background",
			x = display.contentWidth  * .5,
			y = display.contentHeight * .5,
		},
		{
			type = "pause_back",
			x = display.contentWidth  * .5,
			y = display.contentHeight * .8,
		},
	},
	-- event handlers
}
