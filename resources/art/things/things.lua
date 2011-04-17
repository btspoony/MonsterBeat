-- This file is for use with Corona Game Edition
--
-- This file is automatically generated with PhysicsEdtior (http://physicseditor.de). Do not edit
--
-- Usage example:
--			local scaleFactor = 1.0
--			local physicsData = (require "shapedefs").physicsData(scaleFactor)
--			local shape = display.newImage("objectname.png")
--			physics.addBody( shape, physicsData:get("objectname") )
--

-- copy needed functions to local scope
local unpack = unpack
local pairs = pairs
local ipairs = ipairs

module(...)

function physicsData(scale)
	local physics = { data =
	{ 
		
		["flying_01"] = {
			
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -19, 41  ,  -26.5, 36.5  ,  4.5, 27.5  ,  -1.5, 41.5  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   22, -37  ,  24.5, -28.5  ,  19, 19  ,  -25.5, 11.5  ,  -35.5, 0.5  ,  -33.5, -7.5  ,  2, -39  ,  11, -43  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   19, 19  ,  24.5, -28.5  ,  31, -28  ,  37.5, -22.5  ,  34.5, 11.5  ,  31.1666641235352, 18.1666660308838  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -36.5, -22.5  ,  -26, -38  ,  -14, -41  ,  2, -39  ,  -33.5, -7.5  ,  -38, -12  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -25.5, 11.5  ,  19, 19  ,  4.5, 27.5  ,  -26.5, 36.5  ,  -30.5, 22.5  }
				}  
		}
		
		, 
		["flying_02"] = {
			
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -9, -22  ,  7, -27  ,  23.5, -0.5  ,  20.5, 9.5  ,  1, 26  ,  -13, 24  ,  -24.5, 11.5  ,  -23.5, -6.5  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -24.5, 11.5  ,  -13, 24  ,  -20.5, 19.5  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   21, -19  ,  23.5, -0.5  ,  7, -27  ,  15, -25  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   1, 26  ,  20.5, 9.5  ,  7.5, 23.5  }
				}  
		}
		
		, 
		["flying_03"] = {
			
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   69, -16.5  ,  51, -15.5  ,  24, -23.5  ,  61, -33.5  ,  67, -33.5  ,  73.5, -28  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -70.5, 13  ,  -27, 31.5  ,  -74.5, 31  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -70.5, -5  ,  -28, -15.5  ,  -18.5, 11  ,  -18.5, 19  ,  -27, 31.5  ,  -70.5, 13  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -28, -15.5  ,  -70.5, -5  ,  -74.5, -15  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   1, 0.5  ,  -17.5, -6  ,  24, -23.5  ,  51, -15.5  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -18.5, 11  ,  -17.5, -6  ,  1, 0.5  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -18.5, 11  ,  -28, -15.5  ,  -17.5, -6  }
				}  
		}
		
		, 
		["flying_04"] = {
			
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   45, -45  ,  41, -35  ,  6.5, -22.5  ,  30.5, -52.5  ,  42.5, -51.5  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -43, 39  ,  -44, 11  ,  17, -11  ,  22, 9  ,  16, 31  ,  3, 45  ,  -14, 51  ,  -35.5, 49.5  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   6.5, -22.5  ,  17, -11  ,  -44, 11  ,  -38, -1  ,  -17.5, -19.5  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -44, 11  ,  -43, 39  ,  -46, 27  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   6.5, -22.5  ,  34.5, -32.5  ,  17, -11  }
				}  
		}
		
		, 
		["flying_05"] = {
			
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -47, -12  ,  -34.5, -29.5  ,  -16.5, -38.5  ,  1, -41  ,  -18.5, 38.5  ,  -30.5, 33.5  ,  -43, 22  ,  -50, 8  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   40, 25  ,  28.5, 34.5  ,  9.5, 40.5  ,  -18.5, 38.5  ,  13.5, -40.5  ,  31.5, -33.5  ,  49, -10  ,  48, 10  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   49, -10  ,  31.5, -33.5  ,  44, -22  }
				}  ,
				{
					density = 3, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -18.5, 38.5  ,  1, -41  ,  13.5, -40.5  }
				}  
		}
		
		, 
		["flying_06"] = {
			
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -36.5, -3.5  ,  -18, -25  ,  -1.5, -29  ,  8.5, -28.5  ,  31.5, 23.5  ,  9, 36  ,  -15.5, 33  ,  -31.5, 19.5  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   35, -7.5  ,  36.5, 11.5  ,  31.5, 23.5  ,  8.5, -28.5  ,  24, -23  }
				}  ,
				{
					density = 2, friction = 0, bounce = 0, isSensor=true, 
					filter = { categoryBits = 1, maskBits = 65535 },
					shape = {   -18, -25  ,  -36.5, -3.5  ,  -29.5, -17  }
				}  
		}
		
	} }

	-- apply scale factor
	local s = scale or 1.0
	for bi,body in pairs(physics.data) do
		for fi,fixture in ipairs(body) do
			for ci,coordinate in ipairs(fixture.shape) do
				fixture.shape[ci] = s * coordinate
			end
		end
	end
	
	function physics:get(name)
		return unpack(self.data[name])
	end
	
	return physics;
end

