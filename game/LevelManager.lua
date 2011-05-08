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
		self.completeCB = param.onComplete
		

		self.startTime = system.getTimer()
		self.pauseDuration = 0

		-- start music 
		local this = self
		audio.play(self.music, {channel=MUSIC_CHANNEL, loops=0,
		 		onComplete = function(event) this:onComplete() end})

 	end
	
 	-- Stop Level
 	function level:stopLevel() 
 		-- only started level can be stoped
 		if( self.enable == false) then
 			return nil
 		end
 		
 		-- disable the level and reset		
		self.enable = false
		
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
 		if( self.enable == false) then
 			self.enable = true
			gesture.enabled( true )
			npc.enabled( true )
			
			-- resume music if paused
			if audio.isChannelPaused(MUSIC_CHANNEL) then
				audio.resume(MUSIC_CHANNEL)
			end

			local dt = system.getTimer() - self.pauseTime
			self.pauseDuration = self.pauseDuration + dt

 		end
 	end


	-- check the gesture is happend in beat
	function level:inBeat( time )
		local time = time - self.startTime - self.pauseDuration
		
		-- math.round
		local t,f = math.modf( time / self.info.mpb )
		if ( f < 0.5 ) then t = t * self.info.mpb
		else t = ( t + 1 ) * self.info.mpb end
		
		
		local result = ( time > ( t - 200 ) ) and ( time < ( t + 200 ) )
		print("TTTTTTTT", 'time='..time, 't='..t, 'result='..tostring(result));
		return result
	end
	
	-- dispose level
	function level:dispose()
		self.info = nil
		audio.dispose(self.music)
		self.music = nil
		self.enable = nil
		self.completeCB = nil
	end
	
	return level
end
