--[[ 
	Desc: This is the Level Manager to trigger game object
	Func: The function loadLevel() returns a level object with all level function
	Date: 2011.03.27 Tang Bo Hao
		2011.05.07 Chen Ran
--]]
module(..., package.seeall)


-- Private member
local MUSIC_CHANNEL = 1
local BIT_OFFSET = 2


-- Audio settings
audio.reserveChannels(MUSIC_CHANNEL)


-- Level Manager 
function loadLevel( name )
	-- Init the return value of level
	local level = {}
	
	-- properties
	level.info = require("level/" .. name).getLevelData()
	level.music = audio.loadStream("level/"..name..".ogg")
	level.enable = false
	level.lastTick = 0
	level.tick = 60 * 1000 / level.info.bpm


	--set level's tick function
	function level:timer( event )

		-- turn off timer when disabled
		if( not self.enable ) then
			timer.cancel( event.source ) 
			return
		end

		-- record the tick
		self.lastTick = event.time

		-- tick
		local evt = { name="spawn", target=self, time=self.lastTick }
		self.spawnCB(evt)

		self.timerSource = timer.performWithDelay( self.tick, self, 1 )
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
 	function level:startLevel( param )
 		-- only stoped level can be started
 		if( self.enable == true ) then
 			return nil
 		end
 		
 		-- init
		self.enable = true
		self.spawnCB = param.onSpawn
		self.completeCB = param.onComplete
		self.lastTick = system.getTimer()

		-- start music 
		local this = self
		audio.play(self.music, {channel=MUSIC_CHANNEL, loops=0,
		 		onComplete = function(event) this:onComplete() end})

		-- start the tick 
	 	self.timerSource = timer.performWithDelay( self.tick, self, 1 )
 	end
	
 	-- Stop Level
 	function level:stopLevel() 
 		-- only started level can be stoped
 		if( self.enable == false ) then
 			return nil
 		end
 		
 		-- disable the level and reset		
		self.enable = false
		
		-- stop music if not stoped
		if audio.isChannelPlaying(MUSIC_CHANNEL) then
			audio.stop(MUSIC_CHANNEL)
		end

		-- stop the tick
		timer.cancel( self.timerSource )
 	end
 	
 	-- Pause Level
 	function level:pauseLevel() 
 		-- only started level can be paused
 		if( self.enable == false ) then
 			return nil
 		end
 		
 		-- disable the level
		self.enable = false
		self.pauseTime = system.getTimer()
		
		-- pause music if playing
		if audio.isChannelPlaying(MUSIC_CHANNEL) then
			audio.pause(MUSIC_CHANNEL)
		end

		-- stop the tick
		timer.cancel( self.timerSource )
	end
 	
 	-- Resume Level
 	function level:resumeLevel()
 		-- only stoped level can be started
 		if( self.enable == false ) then
 			self.enable = true
			
			-- resume music if paused
			if audio.isChannelPaused(MUSIC_CHANNEL) then
				audio.resume(MUSIC_CHANNEL)
			end

			-- start the tick 
			local t = system.getTimer()
			self.lastTick = self.lastTick + t - self.pauseTime
		 	self.timerSource = timer.performWithDelay( t - self.lastTick, self, 1 )
 		end
 	end


	-- dispose level
	function level:dispose()
		timer.cancel( self.timerSource )
		self.timerSource = nil
		self.info = nil
		audio.dispose(self.music)
		self.music = nil
		self.enable = nil
		self.completeCB = nil
	end
	
	return level
end
