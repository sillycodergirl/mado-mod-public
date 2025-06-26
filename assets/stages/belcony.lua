--=============================================================
-- Set Beat Zoom
--=============================================================
local bopIntensDef = {0.015,0.03}
local bopIntensMult = 1
local bopSpeed = 4

function onCreate()
	makeLuaSprite('room', 'stages/mado_room/room', -1400, -390);
	scaleObject('room', 0.84, 0.84)
	addLuaSprite('room', false);

	makeAnimatedLuaSprite('television', 'stages/mado_room/television', -980, 420)
	addAnim('off')
	addAnim('nosignal')
	addAnim('aztecrave')
	addAnim('eye')
	addAnim('static')
	scaleObject('television', 0.84, 0.84)
	addLuaSprite('television', false)
	playAnim('television', 'off')

	makeAnimatedLuaSprite('micget', 'stages/mado_room/yume_textbox', -89, 400)
	addAnimationByPrefix('micget', 'textbox', 'textbox', 24, false)

	-- nexus
	makeLuaSprite('blue', '', -2000, -650)
	makeGraphic('blue', 4500, 1500, '000000')
	initLuaShader('earthbound')
	setSpriteShader('blue', 'earthbound')
	setScrollFactor('blue', 1, 1)

	makeLuaSprite('nexus', 'stages/nexus/nexus', -3420, -730)
	scaleObject('nexus', 1.1, 1.1)
	makeLuaSprite('bgDoors', 'stages/nexus/backdoors', -1520, 280)
	makeLuaSprite('fgDoors', 'stages/nexus/frontdoors', -1520, 880)
end

function onCreatePost()
	triggerEvent("Play Animation", 'idle-intro', 'dad')
end

function addAnim(name)
	addAnimationByPrefix('television', name, 'tv_'..name, 24, true)
end

function onUpdate(elapsed)
	setShaderFloat('blue', 'iTime', os.clock())
end

function onBeatHit()
	if curBeat == 24 then
		addLuaSprite('micget')
		playAnim('micget', 'textbox')
		-- 44 frames / 24 fps + a couple extra milliseconds for viewing pleasure
		runTimer('hideText', 1.87)
	end
	if curBeat == 350 then
		triggerEvent('Move Camera', 'true');
		
	end
	if curBeat == 352 then
		triggerEvent("Play Animation", "eyepalm", 'dad')
		doTweenZoom('twnz', 'camGame', 0.9, 60 / bpm, 'cubeOut')
		doTweenAlpha('twna1', 'room', 0, 0.5, 'cubeOut')
		doTweenAlpha('twna2', 'television', 0, 0.5, 'cubeOut')
	end
	if curBeat == 353 then
		setProperty('defaultCamZoom', 0.35)

		removeLuaSprite('room', true)
		removeLuaSprite('television', true)

		setProperty('blue.alpha', 0)
		setProperty('nexus.alpha', 0)
		setProperty('bgDoors.alpha', 0)
		setProperty('fgDoors.alpha', 0)

		addLuaSprite('blue')
		addLuaSprite('nexus')
		addLuaSprite('bgDoors')
		addLuaSprite('fgDoors', true)

		doTweenAlpha('twn1', 'blue', 1, 0.4, 'cubeOut')
		doTweenAlpha('twn2', 'nexus', 1, 0.4, 'cubeOut')
		doTweenAlpha('twn3', 'bgDoors', 1, 0.4, 'cubeOut')
		doTweenAlpha('twn4', 'fgDoors', 1, 0.4, 'cubeOut')
	end
	if curBeat == 416 then
		setProperty('defaultCamZoom', 0.48)
		doTweenAlpha('twn6', 'fgDoors', 0.6, 0.4, 'cubeOut')
	end
	if curBeat == 480 then
		makeLuaSprite('black', '',0,0)
		makeGraphic('black', screenWidth, screenHeight, '000000')
		setObjectCamera('black', 'other')
		setProperty('black.alpha', 0)
		addLuaSprite('black', true)

		doTweenAlpha('blacktwn', 'black', 1, (60/bpm)*4, 'linear')
	end
end

function onTimerCompleted(tag, loops, loopsLeft)
	if tag == 'hideText' then
		doTweenAlpha('textTween', 'micget', 0, 0.7)
	end
end

function onStepHit()
	if curStep == 91 then
		triggerEvent("Play Animation", 'micget', 'dad')
	end
end

--[[
	To not use an event, call the "Disable Event" event anywhere in your song to disable it
	and but the name of the event in value1
]]
local disabledEvents = {}
function onEventPushed(event, value1, value2, strumTime)
	if event == 'Disable Event' then
		disabledEvents.insert(value1)
	end
end
function hasItem(value, tbl)
	for _, v in ipairs(tbl ~= nil and tbl or {}) do
		if v == value then return true end
	end
	return false
end
--=============================================================
-- TV SWAP
--=============================================================
local tvSwap = {'static', 'nosignal', 'eye', 'aztecrave'}
local tvFrame = 0
function wrapNum(num, min, max)
	if num < min then
		return max
	elseif num > max then
		return min
	else
		return num
	end
end
function getTableLen(tbl) -- So ig i cant do this normally with dictionary i love lua so much <3 | Returns the length of a table
    local counter = 0
    for i, v in pairs (tbl) do
        counter = counter + 1
    end
    return counter
end


--=============================================================

local eventCode = {
	['TV Swap'] = function()
		local new = wrapNum(tvFrame + 1, 1, getTableLen(tvSwap))
		tvFrame = new
		local anim = tvSwap[tvFrame]
		playAnim('television', anim)
	end,
	['Flash Camera'] = function(v1)
		cameraFlash('hud', 'FFFFFF', tonumber(v1))
	end,
	['Flash Camera No UI'] = function(v1)
		cameraFlash('game', 'FFFFFF', tonumber(v1))
	end,
}

function onEvent(event, v1, v2, strumTime)
	if eventCode[event] ~= nil and not hasItem(event, disabledEvents) then
		eventCode[event](v1, v2)
	end
end

luaDebugMode = true