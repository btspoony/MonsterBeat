-- config.lua

application =
{
	content =
	{
		width = 320,
		height = 480,
		-- scale = "zoomEven", -- zoom to fill screen, possibly cropping edges
		scale = "zoomStretch", -- non-uniformly scales up content to fill screen.
		-- scale = "letterbox", -- uniformly scales up content as much as possible, but still showing all content on the screen.
		-- scale = "none", -- turns off dynamic content scaling (default)

		fps = 30,

		antialias = false
	},
}