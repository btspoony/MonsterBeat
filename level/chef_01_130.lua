--[[ 
	Desc: This file is for use with Corona Game Edition
	Func: The function getLevelData() returns a table suitable for importing  GameLevel
	Date: 2011.03.27 Tang Bo Hao
--]]

module(...)

function getLevelData()

	local sheet = {
		name = "Level1",
		bpm = 130,
		time = 138,
		levels = {
			
			-- level 1
			{
				name = "Step1",
				-- Hit Data
				blockHitsMax = 30,
				hits = {
					
					{
						[5] = "E",
						[7] = "A",
						[12] = "B",
						[15] = "D",
						[18] = "C",
						[20] = "E",
						[22] = "A",
						[25] = "B"
					},
										
					{
						[5] = "E",
						[7] = "A",
						[12] = "B",
						[15] = "D",
						[18] = "C",
						[20] = "E",
						[22] = "A",
						[25] = "B"
					},
								
					{
						[5] = "E",
						[7] = "A",
						[12] = "B",
						[15] = "D",
						[18] = "C",
						[20] = "E",
						[22] = "A",
						[25] = "B"
					},
										
					{
						[5] = "E",
						[7] = "A",
						[12] = "B",
						[15] = "D",
						[18] = "C",
						[20] = "E",
						[22] = "A",
						[25] = "B"
					},
										
					{
						[5] = "E",
						[7] = "A",
						[12] = "B",
						[15] = "D",
						[18] = "C",
						[20] = "E",
						[22] = "A",
						[25] = "B"
					},		
								
					{
						[5] = "E",
						[7] = "A",
						[12] = "B",
						[15] = "D",
						[18] = "C",
						[20] = "E",
						[22] = "A",
						[25] = "B"
					},
				},
			},			
			
			-- level 2
			{
				name = "Step2",
			},
					
			-- level 3
			{
				name = "Step3",
			},
						
			-- level 4
			{
				name = "Step4",
			}			
		
		}
	}

	return sheet
end