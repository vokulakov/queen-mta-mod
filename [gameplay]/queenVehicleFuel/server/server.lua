local REFILLS = { }

local vehiclesData = { }
local vehicleTaimer = { }

local queenVehicleFuel = {}

addEventHandler("onResourceStart", resourceRoot, function()

	-- ГЕНЕРАЦИЯ ЗАПРАВОК [НАЧАЛО] --
	local xmlFuelingData = xmlLoadFile("assets/garageData.xml")
	for ID, node in ipairs(xmlNodeGetChildren(xmlFuelingData)) do
		
		local moreKids = xmlNodeGetChildren(node)
		for i, v in ipairs(moreKids) do
			REFILLS[ID] = { }
			local mx = tonumber(xmlNodeGetAttribute(v, 'x'))
			local my = tonumber(xmlNodeGetAttribute(v, 'y'))
			local mz = tonumber(xmlNodeGetAttribute(v, 'z'))

			REFILLS[ID][i] = { }
			--REFILLS[ID][i].pickup = createPickup(mx, my, mz, 3, 1650, 0)
			REFILLS[ID][i].colSphere = createColSphere(mx, my, mz, 2)

			--setElementData(REFILLS[ID][i].pickup, 'queenVehicleFuel.isRefills', true)
			addEventHandler("onColShapeHit", REFILLS[ID][i].colSphere, queenVehicleFuel.onVehicleColSphereHit)
			addEventHandler("onColShapeLeave", REFILLS[ID][i].colSphere, queenVehicleFuel.onVehicleColSphereLeave)
		end
	end
	xmlUnloadFile(xmlFuelingData)
	-- ГЕНЕРАЦИЯ ЗАПРАВОК [КОНЕЦ] --

	local xmlVehiclesData = xmlLoadFile("assets/carData.xml")
    for i, node in ipairs(xmlNodeGetChildren(xmlVehiclesData)) do
        vehiclesData[tonumber(xmlNodeGetAttribute(node, 'id'))] = {}
		vehiclesData[tonumber(xmlNodeGetAttribute(node, 'id'))].fuel = tonumber(xmlNodeGetAttribute(node, 'fuel'))
		vehiclesData[tonumber(xmlNodeGetAttribute(node, 'id'))].typeOfFuel = xmlNodeGetAttribute(node, 'type')
    end
	xmlUnloadFile(xmlVehiclesData)

	for _, veh in ipairs(getElementsByType("vehicle")) do 
		queenVehicleFuel.setVehicleFuel(veh)
	end

end)

local function onVehicleColShphereEvent(vehicle, state)
	local driver = getVehicleOccupant(vehicle)

	if not driver then 
		return 
	end

	toggleControl(driver, 'vehicle_look_left', not state)
	toggleControl(driver, 'vehicle_look_right', not state)

	triggerClientEvent(driver, 'queenVehicleFuel.showPressButton', driver, state)
end

function queenVehicleFuel.onVehicleColSphereHit(vehicle)
	if getElementType(vehicle) == 'player' then return end

	onVehicleColShphereEvent(vehicle, true)
end

function queenVehicleFuel.onVehicleColSphereLeave(vehicle)
	if getElementType(vehicle) == 'player' then return end

	onVehicleColShphereEvent(vehicle, false)
end
-----------------------------------
-- РАБОТА С ТРАНСПОРТОМ [НАЧАЛО] --
-----------------------------------
function queenVehicleFuel.setVehicleFuel(veh)
	if isTimer(vehicleTaimer[veh]) then return end
	if getVehicleType(veh) ~= 'Automobile' and getVehicleType(veh) ~= 'Bike' and getVehicleType(veh) ~= 'Monster Truck' and getVehicleType(veh) ~= 'Quad' then return end
	local model = getElementModel(veh)
	if not vehiclesData[model] then model = 0 end

	setElementData(veh, 'queenVehicle.fuel', getElementData(veh, 'queenVehicle.fuel') or vehiclesData[model].fuel)
	setElementData(veh, 'queenVehicle.fuelMax', getElementData(veh, 'queenVehicle.fuelMax') or vehiclesData[model].fuel)
	setElementData(veh, 'queenVehicle.typeOfFuel', getElementData(veh, 'queenVehicle.typeOfFuel') or vehiclesData[model].typeOfFuel)

	vehicleTaimer[veh] = setTimer(queenVehicleFuel.fuelUse, 1000, 1, veh)
end

function queenVehicleFuel.fuelUse(veh)
	if not veh then return end
	
	local newX, newY, newZ = getElementPosition(veh)
	local oldX = getElementData(veh, 'queenVehicle.oldX') or newX
	local oldY = getElementData(veh,'queenVehicle.oldY') or newY
	local oldZ = getElementData(veh, 'queenVehicle.oldZ') or newZ

	local vel = (getDistanceBetweenPoints2D(oldX, oldY, newX, newY))
	if vel == 0 then queenVehicleFuel.takeCarFuel(veh, 0.005) end

	local oldX = setElementData(veh, 'queenVehicle.oldX', newX)
	local oldY = setElementData(veh, 'queenVehicle.oldY', newY)
	local oldZ = setElementData(veh, 'queenVehicle.oldZ', newZ)

	queenVehicleFuel.takeCarFuel(veh, math.floor(vel)/Config.coeff)
	
	vehicleTaimer[veh] = setTimer(queenVehicleFuel.fuelUse, 1000, 1, veh)
end

function queenVehicleFuel.takeCarFuel(veh, amount)
	if getVehicleEngineState(veh) then
		local fuel = getElementData(veh, 'queenVehicle.fuel')
		if not fuel then return end
		if fuel <= 0 then setVehicleEngineState(veh, false) end
		fuel = fuel - amount
		if fuel < 0 then fuel = 0 end
		setElementData(veh, 'queenVehicle.fuel', fuel)
	end
end

local function destroyVehicleFuel()
	if getElementType(source) ~= 'vehicle' then return end
	if isTimer(vehicleTaimer[source]) then
		killTimer(vehicleTaimer[source])
	end
end
addEventHandler("onVehicleExplode", root, destroyVehicleFuel)
addEventHandler("onElementDestroy", root, destroyVehicleFuel)

local function startFuelUse(p, seat)
    if seat ~= 0 then return end
	queenVehicleFuel.setVehicleFuel(source)
end
addEventHandler("onVehicleEnter", root, startFuelUse)

function queenVehicleFuel.addCarFuel(veh, amount, money)
	if not veh then return end
	setElementData(veh, 'queenVehicle.fuel', getElementData(veh, 'queenVehicle.fuel') + amount)
	takePlayerMoney(source, money)
	--outputChatBox('Вы заправили '..amount..' л на '..money..' ₽', source, 0, 255, 0)
	triggerClientEvent(source, 'queenNotification.addNotification', source, 'Вы заправили '..amount..' л на $'..money, 1, false)
end
addEvent('queenVehicleFuel.onVehicleRefuel', true)
addEventHandler('queenVehicleFuel.onVehicleRefuel', root, queenVehicleFuel.addCarFuel)
----------------------------------
-- РАБОТА С ТРАНСПОРТОМ [КОНЕЦ] --
----------------------------------