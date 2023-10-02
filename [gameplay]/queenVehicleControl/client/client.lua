local SOUNDS = { }

addEvent('queenVehicleControl.doToggleLights', true)
addEventHandler('queenVehicleControl.doToggleLights', root, function()
	if isElement(SOUNDS.light) then
		destroyElement(SOUNDS.light)
	end

	SOUNDS.light = exports.queenSounds:playSound('veh_lightswitch')
end)

addEvent('queenVehicleControl.doToggleLocked', true)
addEventHandler('queenVehicleControl.doToggleLocked', root, function()
	if isElement(SOUNDS.lock) then
		destroyElement(SOUNDS.lock)
	end

	SOUNDS.lock = exports.queenSounds:playSound('veh_doorlock')
end)

addEvent('queenVehicleControl.doToggleEngine', true)
addEventHandler('queenVehicleControl.doToggleEngine', root, function()
	if isElement(SOUNDS.engine) then
		destroyElement(SOUNDS.engine)
	end

	SOUNDS.engine = exports.queenSounds:playSound('veh_starter_car')
end)
