module(..., package.seeall)

layout=
{
	-- properties
	type = "group",
	-- ui children
	children=
	{
		{
			type = "lose_background",
			x = display.contentWidth  * .5,
			y = display.contentHeight * .5,
		},
		{
			type = "lose_score",
			x = display.contentWidth  * .5,
			y = display.contentHeight * .7,
			size = 12,
		},
		{
			type = "lose_back",
			x = 10,
			y = 10,
		},
	},
	-- event handlers
}
