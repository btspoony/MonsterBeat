module(..., package.seeall)

layout=
{
	-- properties
	type = "group",
	-- ui children
	children=
	{
		{
			type = "pause_cover",
		},
		{
			type = "group",
			name = "holder",
			
			x = display.contentWidth * .5,
			y = -180,
			
			hideYPos = -180,
			showYPos = display.contentHeight * .5,
			
			children = 
			{
				{
					type = "background",
					src = res.getArt( 'ui', 'pause/background.PNG' ),
					x = 0,
					y = 0,
				},
				{
					type = "hgroup",
					x = -85,
					y = 130,
					gap = 45,
					children = 
					{
						{
							type = "pause_back",
						},
						{
							type = "pause_again",
						},
						{
							type = "pause_resume",
						},
					},
				}
			},
			
		},
	},
	-- event handlers
}
