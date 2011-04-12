module(..., package.seeall)

layout=
{
	-- properties
	type = "group",
	-- ui children
	children=
	{
		{
			type = "game_main",
		},
		{
			type = "game_pause",
			x = display.contentWidth-25,
			y = 25,
		},
	},
	-- event handlers
}
