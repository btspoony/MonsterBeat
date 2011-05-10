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
	level.startTime = 0
	level.pauseDuration = 0
	level.lastTick = 0
	level.tickTime = 60 * 1000 / level.info.bpm


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

		self.timerSource = timer.performWithDelay( self.tickTime, self, 1 )
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
		self.startTime = system.getTimer()
		self.pauseDuration = 0

		-- start music 
		local this = self
		audio.play(self.music, {channel=MUSIC_CHANNEL, loops=0,
		 		onComplete = function(event) this:onComplete() end})

		-- start the tick 
	 	self.timerSource = timer.performWithDelay( self.tickTime, self, 1 )
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
			local dt = t - self.pauseTime
			self.lastTick = self.lastTick + dt
			self.pauseDuration = self.pauseDuration + dt
		 	self.timerSource = timer.performWithDelay( t - self.lastTick, self, 1 )
 		end
 	end

	-- check the gesture is happend in beat
	function level:inBeat( time )
		local time = time - self.startTime - self.pauseDuration

		-- math.round
		local i,f = math.modf( time / self.tickTime )
		if ( f >= 0.5 ) then i = i + 1 end

		local t = i * self.tickTime

		local result = ( time > ( t - 200 ) ) and ( time < ( t + 200 ) )
		print("TTTTTTTT", 'time='..time, 't='..t, 'result='..tostring(result));
		return result, i
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
