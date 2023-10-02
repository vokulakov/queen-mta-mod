setDevelopmentMode(true)

local xmlFuelingData = xmlLoadFile("assets/garageData.xml")
for ID, node in ipairs(xmlNodeGetChildren(xmlFuelingData)) do
	local x = tonumber(xmlNodeGetAttribute(node, 'x'))
	local y = tonumber(xmlNodeGetAttribute(node, 'y'))
	local z = tonumber(xmlNodeGetAttribute(node, 'z'))
		
	createBlip(x, y, z, 47, 0, 245, 120, 66, 255, 0, 450)
end

--
totalsPrice		= nil
totalsLitres	= nil
fuelType		= 'АИ-92'

local function startVehicleFill()
	local veh = getPedOccupiedVehicle(localPlayer)

	if not veh or getVehicleEngineState(veh) then
		return triggerEvent('queenNotification.addNotification', localPlayer, 'Заглушите двигатель.', 2, true)
	end

	if (getElementData(veh, "fuel") == getElementData(veh, "fuelMax")) then
		--return triggerEvent('queenNotification.addNotification', localPlayer, 'Бак полный! Куда заливать?', 1, true)
	end

	UI.setVisibleWindow(true)
	triggerEvent('queenVehicleFuel.showPressButton', localPlayer, false)

	toggleAllControls(false, true, true)
end

function onVehicleFill()
	if totalsLitres == 0 then return end

	local veh = getPedOccupiedVehicle(localPlayer)
	if not veh then return end

	local vehicleFuel = getElementData(veh, 'queenVehicle.fuel')
	local vehicleFuelMax = getElementData(veh, 'queenVehicle.fuelMax')
	local veh_fuel_type = getElementData(veh, 'queenVehicle.typeOfFuel')

	--outputDebugString(veh_fuel_type..' '..Config.fuelSetting[fuelType].type)
	if string.find(veh_fuel_type, tostring(Config.fuelSetting[fuelType].type)) == nil then
		triggerEvent('queenNotification.addNotification', localPlayer, 'Выбранный вид топлива не\nподходит для вашего транспорта.', 2)
		return
	end

	if getPlayerMoney(localPlayer) < totalsPrice then
		--outputChatBox('У вас недостаточно средств.', 170, 0, 0)
		triggerEvent('queenNotification.addNotification', localPlayer, 'У вас недостаточно средств.', 2)
		return
	end

	local total_fuel = math.ceil(vehicleFuelMax - vehicleFuel)
	if total_fuel < totalsLitres or vehicleFuel == vehicleFuelMax then
		totalsLitres = total_fuel
		totalsPrice = math.floor(totalsLitres*Config.fuelSetting[fuelType].price)
		
		if totalsPrice == 0 then
			--outputChatBox('Бак полный!', 170, 0, 0)
			triggerEvent('queenNotification.addNotification', localPlayer, 'Бак полный!', 2)
			return
		end
	end

	UI.startFuelProcess()
	UI.PROCESS.SOUND = exports.queenSounds:playSound('azs_zapravka')
	guiSetVisible(UI.bg, false)

	setTimer(UI.stopFuelProcess, 8000, 1, veh, totalsLitres, totalsPrice)
end

addEvent('queenVehicleFuel.showPressButton', true)
addEventHandler('queenVehicleFuel.showPressButton', root, function(isVisible)
	if isVisible and not isElement(UI.btn_press) then
		UI.btn_press = exports.queenNotification:drawHelpButton(sW/2-170/2, sH-200/2, 170, 'Заправить', 15, 0.7, 'b_e')
		bindKey("e", "down", startVehicleFill)
	else
		if isElement(UI.btn_press) then
			destroyElement(UI.btn_press)
			unbindKey("e", "down", startVehicleFill)
		end
	end
end)

-- Процесс заправки
UI.PROCESS = {
	TXT_FUELCAN 		= dxCreateTexture("assets/img/gui_oils_fuelcan.png"),
	TXT_FUELCAN_ACTIVE 	= dxCreateTexture("assets/img/gui_oils_fuelcan_active.png"),
	SHADER 				= exports.queenShaders:createShader("mask3d.fx"),

	FONT 				= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 14, false, "draft"),

	PROGRESS 			= nil,
	SOUND 				= nil,
	TIMER 				= nil
}

dxSetShaderValue(UI.PROCESS.SHADER, "sPicTexture", UI.PROCESS.TXT_FUELCAN_ACTIVE)
dxSetShaderValue(UI.PROCESS.SHADER, "sMaskTexture", UI.PROCESS.TXT_FUELCAN)
dxSetShaderValue(UI.PROCESS.SHADER, "gUVRotAngle", 0)

function UI.drawFuelProcess()
	dxDrawImage(sW/2-200/2, sH/2-200/2, 200, 200, UI.PROCESS.TXT_FUELCAN)

	if not isTimer(UI.PROCESS.TIMER) then 
		UI.PROCESS.TIMER = setTimer(function() 
			UI.PROCESS.PROGRESS = UI.PROCESS.PROGRESS + 0.05 
		end, 500, 1) 
	end

	dxSetShaderValue(UI.PROCESS.SHADER, "gUVPosition", 0, UI.PROCESS.PROGRESS)
	dxDrawImage(sW/2-200/2, sH/2-200/2, 200, 200, UI.PROCESS.SHADER, 0, 0, 0, tocolor(255, 168, 0, 255))

	dxDrawText ("Ожидайте идет заправка...", sW/2-120, sH/2+80, 100, 20, tocolor(255, 255, 255, 255), 1, UI.PROCESS.FONT) 
end

function UI.stopFuelProcess(veh, litres, price)
	removeEventHandler("onClientRender", root, UI.drawFuelProcess)
	triggerEvent("queenShaders.blurShaderStop", localPlayer)
	triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, true)

	if isElement(UI.PROCESS.SOUND) then
		stopSound(UI.PROCESS.SOUND)
	end

	UI.setVisibleWindow(false)
	triggerServerEvent('queenVehicleFuel.onVehicleRefuel', localPlayer, veh, litres, price)
end

function UI.startFuelProcess()
	triggerEvent("queenShaders.blurShaderStart", localPlayer) -- включаем размытие
	triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, false) -- скрываем hud

	UI.PROCESS.PROGRESS = -0.4
	addEventHandler('onClientRender', root, UI.drawFuelProcess)
end