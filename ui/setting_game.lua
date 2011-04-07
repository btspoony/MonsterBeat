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
			x = display.contentWidth-20,
			y = 20,
		},
	},
	-- event handlers
}
