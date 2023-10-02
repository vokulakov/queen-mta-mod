local AFK_TIMER 

local function msToTimeStr(ms)
	if not ms then
		return ''
	end
	
	if ms < 0 then
		return "0","00","00"
	end
	
	local centiseconds = tostring(math.floor(math.fmod(ms, 1000)/10))
	if #centiseconds == 1 then
		centiseconds = '0' .. centiseconds
	end
	local s = math.floor(ms / 1000)
	local seconds = tostring(math.fmod(s, 60))
	if #seconds == 1 then
		seconds = '0' .. seconds
	end
	local minutes = tostring(math.floor(s / 60))
	
	return minutes, seconds, centiseconds
end

addEventHandler("onClientMinimize", root, function() -- свернул игру
	setElementData(localPlayer, "queenPlayer.AFK", true)

	local s = 0

	AFK_TIMER = setTimer(function()
		s = s + 1000
		local m, s, c =  msToTimeStr(s)
		local time = tostring(m..":"..s)
		if tonumber(m) > 60 then
			time = tostring('60:00+')
		end

		setElementData(localPlayer, "queenPlayer.AFK_TIMER", time)
	end, 1000, 0)

end)

addEventHandler("onClientRestore", root, function() -- развернул игру
	setElementData(localPlayer, "queenPlayer.AFK", false)
	if not isTimer(AFK_TIMER) then return end
	killTimer(AFK_TIMER)
end)

