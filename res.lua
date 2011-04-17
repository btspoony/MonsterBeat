module (..., package.seeall)

-- get res files
function getArt(package, name)
	return 'resources/art/'..package..'/'..name
end

-- TODO
function getSound()
end

-- get Phycis
function physicsFile()
	return 'resources/art/things/things'
end