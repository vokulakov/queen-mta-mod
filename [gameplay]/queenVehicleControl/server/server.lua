local function playerBindKey(plr)
	bindKey(plr, "k", "down", doToggleLocked) -- закрытие дверей
	bindKey(plr, "l", "down", doToggleLights) -- фары
	bindKey(plr, "2", "down", doToggleEngine) -- двигатель
end

addEventHandler("onResourceStart", resourceRoot, function()
	for _, p in ipairs(getElementsByType("player")) do
		playerBindKey(p)
	end
end)

addEventHandler("onPlayerJoin", root, function()
	playerBindKey(source)
end)

local lights = { }

local function setVehicleLightOn(veh, rl, gl, bl)

	if rl <= lights[veh].color.r and rl <= 245 then rl = rl + 10
	else rl = lights[veh].color.r
	end

	if gl <= lights[veh].color.g and gl <= 245 then gl = gl + 10 
	else gl = lights[veh].color.g
	end

	if bl <= lights[veh].color.b and bl <= 245 then bl = bl + 10
	else bl = lights[veh].color.b  
	end

	setVehicleHeadLightColor(veh, rl, gl, bl)

	if rl == lights[veh].color.r and gl == lights[veh].color.g and bl == lights[veh].color.b then
		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end
		return
	end

	lights[veh].timer = setTimer(setVehicleLightOn, 50, 1, veh, rl, gl, bl)
end

local function setVehicleLightOff(veh, rl, gl, bl)

	if rl >= 15 then rl = rl - 15
	else rl = 0
	end

	if gl >= 15 then gl = gl - 15 
	else gl = 0
	end

	if bl >= 15 then bl = bl - 15
	else bl = 0
	end

	setVehicleHeadLightColor(veh, rl, gl, bl)

	if rl == 0 and gl == 0 and bl == 0 then
		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end
		setVehicleOverrideLights(veh, 1)
		return
	end

	lights[veh].timer = setTimer(setVehicleLightOff, 50, 1, veh, rl, gl, bl)
end

function doToggleLights(player)
	local veh = getPedOccupiedVehicle(player)
	if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then return end

	if not lights[veh] then
		lights[veh] = { }
		lights[veh].state = 0
	end

	if lights[veh].state == 0 then

		local rl, gl, bl = getVehicleHeadLightColor(veh)

		if lights[veh].color then
			rl, gl, bl = lights[veh].color.r, lights[veh].color.g, lights[veh].color.b
		end
		
		if rl == 0 and gl == 0 and bl == 0 then
			rl = 255 gl = 255 bl = 255
		end

		lights[veh].color = {r = rl, g = gl, b = bl}

		setVehicleHeadLightColor(veh, 0, 0, 0)
		setVehicleOverrideLights(veh, 2)

		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end

		lights[veh].state = 1
	elseif lights[veh].state == 1 then
		setVehicleOverrideLights(veh, 2)
		setVehicleHeadLightColor(veh, 0, 0, 0)

		-- ИМИТАЦИЯ РАЗЖИГАНИЯ КСЕНОНА --
		lights[veh].timer = setTimer(setVehicleLightOn, 50, 1, veh, 0, 0, 0)
		---------------------------------

		lights[veh].state = 2
	elseif lights[veh].state == 2 then
		if isTimer(lights[veh].timer) then
			killTimer(lights[veh].timer)
			lights[veh].timer = nil
		end

		lights[veh].timer = setTimer(setVehicleLightOff, 50, 1, veh, lights[veh].color.r, lights[veh].color.g, lights[veh].color.b)
		
		lights[veh].state = 0
	end
	
	triggerClientEvent(player, 'queenVehicleControl.doToggleLights', player)
end

function doToggleLocked(player)
	local veh = getPedOccupiedVehicle(player)
	if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then return end

	if isVehicleLocked(veh) then
        setVehicleLocked(veh, false) 
    else                           
        setVehicleLocked(veh, true)
    end

    triggerClientEvent(player, 'queenVehicleControl.doToggleLocked', player)
end

function doToggleEngine(player)
	local veh = getPedOccupiedVehicle(player)
	if not veh or getPedOccupiedVehicleSeat(player) ~= 0 then return end

	if getVehicleEngineState(veh) then
		setVehicleEngineState(veh, false)
		if getElementData(veh, "queenVehicle.cruiseSpeedEnabled" ) then
			triggerClientEvent (player, "queenVehicleControl.toggleCruiseSpeed", player) 
		end
		--triggerEvent('exv_fueling.onPlayerEngineSwitch', player, veh) -- EXPORT К СИСТЕМЕ ЗАПРАВКИ
	else
		triggerClientEvent(player, 'queenVehicleControl.doToggleEngine', player)
		setTimer(setVehicleEngineState, 1200, 1, veh, true)
	end

end
