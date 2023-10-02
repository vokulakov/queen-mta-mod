local vehicles = { 
	[562] = {name = 'veh_horn_sound_a', distance = 100, volume = 1.3, cicle = true}, 
	[540] = {name = 'veh_horn_sound_b', distance = 100, volume = 1.3, cicle = true}, 
}

local isVehicleHorn = { }

local function addVehicleSound(veh, horn)
	if not veh then return end

	local x, y, z = getElementPosition(veh)
	--local sound = playSound3D(url, x, y, z, true)
	local sound = exports.queenSounds:playSound3D(horn.name, x, y, z, horn.cicle)

	setSoundVolume(sound, horn.volume)
	setSoundMaxDistance(sound, horn.distance) 
	attachElements(sound, veh)

	return sound
end

local function updateVehicleHorn(veh, state)
	if not veh then return end

	local horn = vehicles[getElementModel(veh)]
	if not horn then return end
	
	if not isVehicleHorn[veh] and state == 'down' then
		isVehicleHorn[veh] = { }

		isVehicleHorn[veh].sound = addVehicleSound(veh, horn)
		isVehicleHorn[veh].player = getVehicleOccupant(veh)
		return
	end
	
	if isVehicleHorn[veh] and state == 'up' then
		if isElement(isVehicleHorn[veh].sound) then
			stopSound(isVehicleHorn[veh].sound)
		end
		isVehicleHorn[veh] = nil
		return 
	end
end

local function onVehicleHorn(_, state)
	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	if isCursorShowing() then
		setElementData(veh, 'queenVehicleHorn.isVehicleHornState', 'up')
		return
	end

	setElementData(veh, 'queenVehicleHorn.isVehicleHornState', state)
end

addEventHandler("onClientElementDataChange", root, function(data, _, state)
	if not getElementType(source) == "vehicle" then return end
	if not vehicles[getElementModel(source)] then return end

	if isElementStreamedIn(source) and data == 'queenVehicleHorn.isVehicleHornState' then
		updateVehicleHorn(source, state)
	end
end)


-------------------------------------------------------------------------
addEventHandler("onClientResourceStart", resourceRoot, function ()
    local veh = getPedOccupiedVehicle(localPlayer)
    if veh and vehicles[getElementModel(veh)] and getPedOccupiedVehicleSeat(localPlayer) == 0 then
        toggleControl("horn", false)
        unbindKey('h', 'both', onVehicleHorn)
		bindKey('h', 'both', onVehicleHorn)
    end
end)

addEventHandler("onClientVehicleEnter", root, function(player, seat)
   	if (player ~= localPlayer) then return end

   	if seat == 0 then
        toggleControl("horn", false)

		if vehicles[getElementModel(source)] then
			unbindKey('h', 'both', onVehicleHorn)
			bindKey('h', 'both', onVehicleHorn)
		else
			toggleControl("horn", true)
			unbindKey('h', 'both', onVehicleHorn)
		end
	else 
		unbindKey('h', 'both', onVehicleHorn)
		setElementData(source, 'queenVehicleHorn.isVehicleHornState', 'up')
    end

end)

addEventHandler("onClientVehicleStartExit", root, function(player, seat)
	if (player == localPlayer and seat == 0) then 

		if vehicles[getElementModel(source)] then
			unbindKey('h', 'both', onVehicleHorn)
		end

		setElementData(source, 'queenVehicleHorn.isVehicleHornState', 'up')
	end
end)

function NEW_FUNCTION(vehicle)
	local driver = getVehicleOccupant(vehicle)
	local veh = getPedOccupiedVehicle(localPlayer)

	if not veh or not driver then
		return false
	end

	if not isVehicleHorn[vehicle] then 
		return
	end

	if getPedOccupiedVehicleSeat(localPlayer) == 0 then
		if isVehicleHorn[vehicle].player ~= driver then
			return false
		end
	end

	return true
end

addEventHandler("onClientElementDestroy", root, function()
    if source and getElementType(source) == "vehicle" then

		if not vehicles[getElementModel(source)] then
			return
		end

		if NEW_FUNCTION(source) then
 			unbindKey('h', 'both', onVehicleHorn)
		end

		setElementData(source, 'queenVehicleHorn.isVehicleHornState', 'up')
    end
end)

addEventHandler("onClientPlayerWasted", localPlayer, function()
	local veh = getPedOccupiedVehicle(localPlayer)

    if not veh or not vehicles[getElementModel(veh)] then
    	return
    end

    setElementData(veh, 'queenVehicleHorn.isVehicleHornState', 'up')
end)

addEventHandler("onClientElementModelChange", root, function(oldModel)
	if source and getElementType(source) == "vehicle" then
		if not vehicles[oldModel] then
			return
		end
		triggerServerEvent('queenVehicleHorn.breakModelChange', source, oldModel)
	end
end)



--[[
----------------- ЧИСТО ПОРЖАТЬ -------------------
local function playMusic()
	local veh = localPlayer.vehicle
	if not veh then return end
	local snd = playSound3D('http://d.zaix.ru/eGqu.mp3', 0, 0, 0, true)
	setSoundVolume(snd, 1.0)
	setSoundMaxDistance(snd, 40) 
	attachElements(snd, veh)
end
addCommandHandler('music', playMusic)
----------------------------------------------------
]]