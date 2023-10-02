
local sendingPause = 250

addEvent("exv_vehControl.setDoorRatio", true)
addEventHandler("exv_vehControl.setDoorRatio", resourceRoot, function(vehicle, door, ratio)
	if isElement(vehicle) then
		if (door == "bonnet") then
			setVehicleDoorOpenRatio(vehicle, 0, ratio, sendingPause)
			
		elseif (door == "doors") then
			setVehicleDoorOpenRatio(vehicle, 2, ratio, sendingPause)
			setVehicleDoorOpenRatio(vehicle, 3, ratio, sendingPause)
			setVehicleDoorOpenRatio(vehicle, 4, ratio, sendingPause)
			setVehicleDoorOpenRatio(vehicle, 5, ratio, sendingPause)
			
		elseif (door == "doorsF") then
			setVehicleDoorOpenRatio(vehicle, 2, ratio, sendingPause)
			setVehicleDoorOpenRatio(vehicle, 3, ratio, sendingPause)
			
		elseif (door == "doorsR") then
			setVehicleDoorOpenRatio(vehicle, 4, ratio, sendingPause)
			setVehicleDoorOpenRatio(vehicle, 5, ratio, sendingPause)
			
		elseif (door == "trunk") then
			setVehicleDoorOpenRatio(vehicle, 1, ratio, sendingPause)
			
		elseif (door == "doorLF") then
			setVehicleDoorOpenRatio(vehicle, 2, ratio, sendingPause)
			
		elseif (door == "doorRF") then
			setVehicleDoorOpenRatio(vehicle, 3, ratio, sendingPause)
			
		elseif (door == "doorLR") then
			setVehicleDoorOpenRatio(vehicle, 4, ratio, sendingPause)
			
		elseif (door == "doorRR") then
			setVehicleDoorOpenRatio(vehicle, 5, ratio, sendingPause)
			
		end
	end
end)
