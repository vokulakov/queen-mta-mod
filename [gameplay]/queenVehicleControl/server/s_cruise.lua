addEvent("queenVehicleControl.enableVehicleCruiseSpeed", true)
addEventHandler ("queenVehicleControl.enableVehicleCruiseSpeed", getRootElement (), function (state) 
	if state then 
		setElementSyncer (source, getVehicleController (source))
	else 		
		setElementSyncer (source, true)
	end
end)


addEventHandler("onVehicleStartExit", root, function(thePlayer, seat)
	if getElementData(source, "queenVehicle.cruiseSpeedEnabled") and seat == 0 then
		triggerClientEvent(thePlayer, "queenVehicleControl.toggleCruiseSpeed", thePlayer) 
	end
end)