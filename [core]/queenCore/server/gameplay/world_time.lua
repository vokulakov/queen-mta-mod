local function setWorldTime()
	local TIME_HOUR, TIME_MINUTE = getTime()
	setTime(TIME_HOUR, TIME_MINUTE)
    setMinuteDuration(10000)
end
addEvent("queenCore.setWorldTime", true)
addEventHandler("queenCore.setWorldTime", root, setWorldTime)
