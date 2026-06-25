display.setStatusBar( display.HiddenStatusBar )
display.setDefault("background", 1, 1, 1)

local composer = require("composer")
local loadsave = require("loadsave")
local Leaderboard = require("Leaderboard")
setup    = require("setup")
composer.recycleOnSceneChange = true

math.randomseed( os.time() )

local soundPool = {}
soundPool["select"] = audio.loadSound("sounds/select.mp3")
soundPool["score"] = audio.loadSound("sounds/point.mp3")
soundPool["plank"] = audio.loadSound("sounds/plank.mp3")
soundPool["gameover"] = audio.loadSound("sounds/gameover.mp3")
audio.setVolume(0.6, {channel = 1})
audio.setVolume(1, {channel = 2})
audio.setVolume(1, {channel = 3})
audio.setVolume(1, {channel = 4})

function playSound(name)
	if soundPool[name] ~= nil then 
		audio.play(soundPool[name])
	end
end

local backgroundMusicChannel
local backgroundMusicSounds = {}
if (backgroundMusic == true) then
   for i=1, backgroundMusicNumber do
         backgroundMusicSounds["bg" .. i] = audio.loadStream("sounds/bg" .. i ..".mp3")
   end
end
function playBackgroundMusic()
   if (backgroundMusic == true) then
      backgroundMusicChannel = audio.play( backgroundMusicSounds["bg" .. math.random(1,backgroundMusicNumber)], { channel=5, loops=-1 } )
   end
end

function stopBackgroundMusic()
   if (backgroundMusic == true) then
         audio.stop( backgroundMusicChannel )
   end
end

_G.saveDataTable		= {}
_G.bottomSide = display.contentHeight-display.screenOriginY -2

local function systemEvents( event )
   print("systemEvent " .. event.type)
   if ( event.type == "applicationSuspend" ) then
      print( "suspending..........................." )
   elseif ( event.type == "applicationResume" ) then
      print( "resuming............................." )
   elseif ( event.type == "applicationExit" ) then
      print( "exiting.............................." )
   elseif ( event.type == "applicationStart" ) then
      if useLeaderboard == true then
		Leaderboard.init()
	end
   end
   return true
end

Runtime:addEventListener( "system", systemEvents )
if loadsave.fileExists("stickhero.json", system.DocumentsDirectory) then
	saveDataTable = loadsave.loadTable("stickhero.json")
else
	saveDataTable.bestScore = 0
	loadsave.saveTable(saveDataTable, "stickhero.json")
end
saveDataTable = loadsave.loadTable("stickhero.json")
_G.bestScore = saveDataTable.bestScore	
composer.gotoScene( "scenes.menu", "fade", 400 )
