--[[ 
	Desc: This is the Level Manager to trigger game object
	Func: The function loadLevel() returns a level object with all level function
	Date: 2011.03.27 Tang Bo Hao
--]]
module(..., package.seeall)

-- Private member
local MUSIC_CHANNEL = 1
local BIT_OFFSET = 1

-- Audio settings
audio.reserveChannels(MUSIC_CHANNEL)

-- Level Manager 
function loadLevel(levelname)
	-- Init the return value of level
	local level = {}
	
	-- properties
	level.info = require("level/"..levelname).getLevelData()
	level.music = audio.loadStream("level/"..levelname..".ogg")
	level.enable = false
	level.counter = 0
	
	--set level's tick function
	function level:timer(event)
		-- Add Counter
		local delta = event.time - self.lastTick
		self.counter = self.counter + delta
		self.lastTick = event.time
		
		-- Check if can spawn and then dispatch level event
		local tickCount = math.floor(self.counter/(60*1000/self.info.bpm))
		local levelDetail = self.info.levels[self.currLevel]
		local blockCount = math.floor(tickCount / levelDetail.blockHitsMax)+1
		local hitCount = tickCount % levelDetail.blockHitsMax+1-BIT_OFFSET
		print("Block "..blockCount.." - Hit "..hitCount)
		
		-- Bit check
		local bitBlock = levelDetail.hits[blockCount]
		if(bitBlock ~= nil) then 
			local testHit = bitBlock[hitCount]
	
			if(testHit ~= nil) then
				local evt = { name="spawn", target=self, position=testHit}
				self.spawnCB(evt)
			end
		end
		
		-- turn off when level finished
		if( self.counter >= self.info.time*1000) then
			self.enable = false
		end
		
		-- turn off timer when disabled
		if( self.enable == false ) then
			timer.cancel( event.source ) 
		end
	end
	
	function level:onComplete(event)
	--[[ 
		event has
		channel, handlem, completed
	--]]
		self:stopLevel()
		
		if self.completeCB ~= nil then
			self.completeCB()
		end
	end
 	
 	-- Start Level and Register to call timer method
 	function level:startLevel(index, param)
 		-- only stoped level can be started
 		if( self.enable == true or self.counter > 0) then
 			return nil
 		end
 		
 		-- init
		self.enable = true
		self.counter = 0
		self.lastTick = system.getTimer()
		self.currLevel = index
		self.spawnCB = param["spawn"]
		self.completeCB = param["complete"]
		print("Starting Level-"..self.currLevel)

		-- start music 
		local this = self
		audio.play(self.music, {channel=MUSIC_CHANNEL, loops=0,
		 		onComplete = function(event) this:onComplete() end})
		
		-- start the tick 
	 	timer.performWithDelay( (60*1000/self.info.bpm), self, 0 )
	 	
		return self.info.levels[i]
 	end
	
 	-- Stop Level
 	function level:stopLevel() 
 		-- only started level can be stoped
 		if( self.enable == false) then
 			return nil
 		end
 		
 		-- disable the level and reset		
		self.enable = false
		self.counter = 0
		
		-- stop music if not stoped
		if audio.isChannelPlaying(MUSIC_CHANNEL) then
			audio.stop(MUSIC_CHANNEL)
		end
 	end
 	
 	-- Pause Level
 	function level:pauseLevel() 
 		-- only started level can be paused
 		if( self.enable == false) then
 			return nil
 		end
 		
 		-- disable the level
		self.enable = false
		self.pauseTime = system.getTimer()
		
		-- pause music if playing
		if audio.isChannelPlaying(MUSIC_CHANNEL) then
			audio.pause(MUSIC_CHANNEL)
		end
	end
 	
 	-- Resume Level
 	function level:resumeLevel()
 		-- only stoped level can be started
 		if( self.enable == false and self.counter ~= 0) then
 			self.enable = true
			
			-- resume music if paused
			if audio.isChannelPaused(MUSIC_CHANNEL) then
				audio.resume(MUSIC_CHANNEL)
			end
			
			-- start the tick 
			self.lastTick = self.lastTick + system.getTimer() - self.pauseTime
		 	timer.performWithDelay( (60*1000/self.info.bpm), self, 0 )
 		end
 	end
	
	-- dispose level
	function level:dispose()
		self.info = nil
		audio.dispose(self.music)
		self.music = nil
		self.enable = nil
		self.counter = nil
		self.lastTick = nil
		self.currLevel = nil
		self.spawnCB = nil
		self.completeCB = nil
	end
	
	return level
end