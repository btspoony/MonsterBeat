module(..., package.seeall)

layout=
{
	-- properties
	type = "group",
	-- ui children
	children=
	{
		{
			type = "win_background",
			x = display.contentWidth  * .5,
			y = display.contentHeight * .5,
		},
		{
			type = "win_score",
			x = display.contentWidth  * .5,
			y = display.contentHeight * .7,
			size = 12,
		},
		{
			type = "win_back",
			x = 10,
			y = 10,
		},
	},
	-- event handlers
}
