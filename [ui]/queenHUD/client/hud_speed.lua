local posX, posY

Speed = {}
Speed.visible = false

local speedStart 
local maskSpeedShader
local maskTahometerShader 
local maskFuelShader 

local circleTexturesSpeed = {}
local circleTexturesTaxometr = {}

local smothedRotation = 0

local function drawIndicator(veh)

	if getElementData(veh, "leftflash_v") or getElementData(veh, "allflash_v") then
		dxDrawImage(posX-202+162/2-36, posY-45-15, 26, 26, TXT.turnlight_l_a)
	else
		dxDrawImage(posX-202+162/2-36, posY-45-15, 26, 26, TXT.turnlight_l)
	end

	if getElementData(veh, "rightflash_v") or getElementData(veh, "allflash_v") then
		dxDrawImage(posX-202+162/2+10, posY-45-15, 26, 26, TXT.turnlight_r_a)
	else
		dxDrawImage(posX-202+162/2+10, posY-45-15, 26, 26, TXT.turnlight_r)
	end

	-- Двигатель
	if not getVehicleEngineState(veh) then
		dxDrawImage(posX-202+162/2-52-5, posY-45+9, 26, 26, TXT.engine_off)
	else
		dxDrawImage(posX-202+162/2-52-5, posY-45+9, 26, 26, TXT.engine_on)
	end

	-- Круиз контроль
	if getElementData(veh, "queenVehicle.cruiseSpeedEnabled") then
		dxDrawImage(posX-202+162/2-26-5, posY-45+18, 26, 26, TXT.cc_on)
		dxDrawText(getElementSpeed(veh), posX-202+162/2-26-5, posY-45+26+13, posX-202+162/2-5, 20, tocolor(255, 255, 255), 1, HUD.FONTS['speed_font_RR'], "center")
	else
		dxDrawImage(posX-202+162/2-26-5, posY-45+18, 26, 26, TXT.cc_off)
	end
	-- Двери
	if not isVehicleLocked(veh) then
		dxDrawImage(posX-202+162/2+5, posY-45+18, 26, 26, TXT.door_open)
	else
		dxDrawImage(posX-202+162/2+5, posY-45+18, 26, 26, TXT.door_close)
	end

	-- Фары
	if (getVehicleOverrideLights(veh) == 2) then
		dxDrawImage(posX-202+162/2+26+10, posY-45+9, 26, 26, TXT.lights_on)
	else
		dxDrawImage(posX-202+162/2+26+10, posY-45+9, 26, 26, TXT.lights_off)
	end

	-- Топливо
	dxDrawImage(posX-40+10, posY-45+13, 26, 26, TXT.fuel)

	-- Чек
--	dxDrawImage(posX-202+162/2-26/2, posY-122-8, 26, 26, TXT.checkengine)

	-- Аренда автомобиля
--	dxDrawImage(posX-300-26-13, posY-45+9, 26, 26, TXT.rent)
end

local function drawSpeed()
	local veh = getPedOccupiedVehicle(localPlayer) 
    if not veh or getVehicleOccupant(veh) ~= localPlayer then return end

    local vehicleSpeed = getVehicleSpeed()

    drawIndicator(veh)

    -- Спидометр
	if vehicleSpeed < 90 then
		dxSetShaderValue(maskSpeedShader, "sPicTexture", circleTexturesSpeed[1])
		dxSetShaderValue(maskSpeedShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 0.2)
	elseif vehicleSpeed > 90 and vehicleSpeed < 170 then
		dxSetShaderValue(maskSpeedShader, "sPicTexture", circleTexturesSpeed[2])
		dxSetShaderValue(maskSpeedShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 4.9)
	elseif vehicleSpeed > 170 then
		dxSetShaderValue(maskSpeedShader, "sPicTexture", circleTexturesSpeed[3])
		dxSetShaderValue(maskSpeedShader, "gUVRotAngle", 0 - (vehicleSpeed/57) - 3.3)
	end

	dxDrawImage(posX-202, posY-122-45, 162, 162, maskSpeedShader, 0, 0, 0, tocolor(255, 168, 0, 127))
	dxDrawImage(posX-202, posY-122-45, 162, 162, TXT.speed_bg)

	if vehicleSpeed < 243 then
		dxDrawImage(posX-202, posY-122-45, 160, 160, TXT.speed_needle, vehicleSpeed - 3)
	else
		dxDrawImage(posX-202, posY-200, 160, 160, TXT.speed_needle, 240)
	end

	dxDrawText(getElementSpeed(veh), posX-202, posY-45-29, posX-202+162, 300, tocolor(255, 255, 255, 255), 1, HUD.FONTS['speed_font_Osw'], "center")
	dxDrawText("км/ч", posX-202, posY-45-9, posX-202+162, 300, tocolor(255, 255, 255, 255), 1, HUD.FONTS['speed_font_RR'], "center")

	-- Тахометр
	local rot = math.floor(((175/12800)* getVehicleRPM(veh)) + 0.5)
	if (smothedRotation < rot) then smothedRotation = smothedRotation + 2.5 end
	if (smothedRotation > rot) then smothedRotation = smothedRotation - 2.5 end

	if (0 - (smothedRotation/57)) > - 1 then
		dxSetShaderValue(maskTahometerShader, "sPicTexture", circleTexturesSpeed[1])
		dxSetShaderValue(maskTahometerShader, "gUVRotAngle", 0 - (smothedRotation/57) + 0.35)
	elseif (0 - (smothedRotation/57)) > - 4.4 then
		dxSetShaderValue(maskTahometerShader, "sPicTexture", circleTexturesSpeed[2])
		dxSetShaderValue(maskTahometerShader, "gUVRotAngle", 0 - (smothedRotation/57) - 4.5)
	end
	
	dxDrawImage(posX-300, posY-122, 122, 122, maskTahometerShader, 0, 0, 0, tocolor(255, 255, 255, 127))

	dxDrawImage(posX-300, posY-122, 122, 122, TXT.tahometer_bg)

	dxDrawImage(posX-293, posY-117, 115, 115, TXT.tahometer_needle, smothedRotation - 5)

	dxDrawText(string.sub(getVehicleRPM(veh), 1, 1), posX-226, posY-32, posX-203, 300, tocolor(255, 255, 255, 255), 1, HUD.FONTS['speed_font_Osw12'], "center")
	dxDrawText("RPM", posX-226, posY-13, posX-203, 300, tocolor(255, 255, 255, 255), 1, HUD.FONTS['speed_font_RR6'], "center")

	-- Топливо
	local fuel_count = getElementData(veh, "queenVehicle.fuel") or 0
	local fuel_max = getElementData(veh, "queenVehicle.fuelMax") or 0
	local fuel = math.floor((fuel_count/fuel_max)*100)
	local currentFuel = 0.6 - (1 - fuel/100)

	dxSetShaderValue(maskFuelTexture, "gUVPosition", 0, currentFuel)
	dxDrawImage(posX-40-34/2+5, posY-123-30-5, 34, 123, maskFuelTexture, 0, 0, 0, tocolor(255, 255, 255, 127))
		
	dxDrawImage(posX-40-34/2+5, posY-123-30-5, 34, 123, TXT.fuel_bg)
end

addEventHandler('onClientRender', root, function()
	if not Speed.visible then
		return
	end
--[[
	dxDrawRectangle(0, posY-122-1/2, sW, 1, tocolor(0, 255, 255, 255), true)

	dxDrawRectangle(posX-300-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(posX-300+97-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)

	dxDrawRectangle(posX-152/2-40-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(posX-162/2-40-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(posX-172/2-40-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)

	dxDrawRectangle(posX-226-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(posX-40, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(0, posY-200/2-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
]]
	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['speed'] then return end

	drawSpeed()
end)

function Speed.start()
	if speedStart then
		return
	end

	speedStart = true

	posX, posY = HUD.speed.posX, HUD.speed.posY

	TXT = {
		speed_bg				= dxCreateTexture('assets/imgSpeed/s_speedo.png'),
		tahometer_bg 			= dxCreateTexture('assets/imgSpeed/s_tahometer.png'),
		fuel_bg					= dxCreateTexture('assets/imgSpeed/s_fuel.png'),
		s_fuel_a				= dxCreateTexture('assets/imgSpeed/s_fuel_a.png'),

		speed_needle			= dxCreateTexture('assets/imgSpeed/needle_s.png'),
		tahometer_needle		= dxCreateTexture('assets/imgSpeed/needle_t.png'),

		maskSpeedTexture		= dxCreateTexture('assets/imgSpeed/s_mask.png'),
		maskTahometerTexture	= dxCreateTexture('assets/imgSpeed/t_mask.png'),
		maskFuelTexture			= dxCreateTexture('assets/imgSpeed/f_mask.png'),

		turnlight_l				= dxCreateTexture('assets/imgSpeed/turnlight_l.png'),
		turnlight_l_a			= dxCreateTexture('assets/imgSpeed/turnlight_l_a.png'),
		turnlight_r				= dxCreateTexture('assets/imgSpeed/turnlight_r.png'),
		turnlight_r_a			= dxCreateTexture('assets/imgSpeed/turnlight_r_a.png'),

		engine_off				= dxCreateTexture('assets/imgSpeed/engine_off.png'),
		engine_on				= dxCreateTexture('assets/imgSpeed/engine_on.png'),

		cc_off					= dxCreateTexture('assets/imgSpeed/cc_off.png'),
		cc_on					= dxCreateTexture('assets/imgSpeed/cc_on.png'),

		door_open				= dxCreateTexture('assets/imgSpeed/door_open.png'),
		door_close				= dxCreateTexture('assets/imgSpeed/door_close.png'),

		lights_off				= dxCreateTexture('assets/imgSpeed/lights_off.png'),
		lights_on				= dxCreateTexture('assets/imgSpeed/lights_on.png'),

		fuel					= dxCreateTexture('assets/imgSpeed/fuel.png'),
		fuel_empty				= dxCreateTexture('assets/imgSpeed/fuel_empty.png'),
		fuel_no					= dxCreateTexture('assets/imgSpeed/fuel_no.png'),

		rent					= dxCreateTexture('assets/imgSpeed/rent.png'),
		checkengine				= dxCreateTexture('assets/imgSpeed/checkengine.png'),
	}

	maskSpeedShader = exports.queenShaders:createShader("mask3d.fx")
	dxSetShaderValue(maskSpeedShader, "sMaskTexture", TXT.maskSpeedTexture) 
	dxSetShaderValue(maskSpeedShader, "gUVRotCenter", 0.5, 0.5)

	for i = 1, 3 do
		circleTexturesSpeed[i] = dxCreateTexture("assets/imgSpeed/s_circle"..tostring(i)..".png", "dxt5", true, "clamp")
	end

	maskTahometerShader = exports.queenShaders:createShader("mask3d.fx")
	dxSetShaderValue(maskTahometerShader, "sMaskTexture", TXT.maskTahometerTexture) 
	dxSetShaderValue(maskTahometerShader, "gUVRotCenter", 0.5, 0.5)

	for i = 1, 2 do
		circleTexturesTaxometr[i] = dxCreateTexture("assets/imgSpeed/t_circle"..tostring(i)..".png", "dxt5", true, "clamp")
	end

	maskFuelTexture = exports.queenShaders:createShader("mask3d.fx")
	dxSetShaderValue(maskFuelTexture, "sMaskTexture", TXT.maskFuelTexture) 
	dxSetShaderValue(maskFuelTexture, "gUVRotCenter", 0.5, 0.5)
	dxSetShaderValue(maskFuelTexture, "gUVRotAngle", 0)
	dxSetShaderValue(maskFuelTexture, "sPicTexture", TXT.s_fuel_a)
end

function Speed.setVisible(visible)
	Speed.visible = not not visible
end

function getVehicleSpeed()
    if isPedInVehicle(getLocalPlayer()) then
	    local theVehicle = getPedOccupiedVehicle (getLocalPlayer())
        local vx, vy, vz = getElementVelocity (theVehicle)
        return math.sqrt(vx^2 + vy^2 + vz^2) * 165
    end
    return 0
end

function getElementSpeed(element)
	speedx, speedy, speedz = getElementVelocity (element)
	actualspeed = (speedx^2 + speedy^2 + speedz^2)^(0.5) 
	kmh = actualspeed * 1.61 * 100
	return math.round(kmh)
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getVehicleRPM(vehicle)
	local vehicleRPM = 0
    if (vehicle) then  
        if (getVehicleEngineState(vehicle) == true) then
            if getVehicleCurrentGear(vehicle) > 0 then   
				vehicleRPM = math.floor(((getElementSpeed(vehicle, "kmh")/getVehicleCurrentGear(vehicle))*180) + 0.5) 
				if getElementSpeed(vehicle, "kmh") == 0 then vehicleRPM  = math.random(1500, 1650) end
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            else
                vehicleRPM = math.floor((getElementSpeed(vehicle, "kmh")*80) + 0.5)
				if getElementSpeed(vehicle, "kmh") == 0 then vehicleRPM  = math.random(1500, 1650) end
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            end
        else
            vehicleRPM = 0
        end
        return tonumber(vehicleRPM)
    else
        return 0
    end
end
--[[
local function drawSpeed()
	dxDrawImage(posX-200, posY-200, 162, 162, TXT.speed_bg)

	dxDrawImage(posX-300, posY-155, 122, 122, TXT.tahometer_bg)
end

function showSpeed(state)
	if not state then
		return removeEventHandler('onClientRender', root, drawSpeed, false)
	end

	posX, posY = HUD.speed.posX, HUD.speed.posY

	addEventHandler('onClientRender', root, drawSpeed, false)
end

addEventHandler("onClientVehicleEnter", root, function (thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 then
		addEventHandler("onClientRender", root, drawSpeedometr)
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(thePlayer, seat)
    if thePlayer == localPlayer and seat == 0 then
        removeEventHandler("onClientRender", root, drawSpeedometr)
    end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" and getPedOccupiedVehicle(getLocalPlayer()) == source then
		removeEventHandler("onClientRender", root, drawSpeedometr)
	end
end)

addEventHandler ( "onClientPlayerWasted", getLocalPlayer(), function()
	if not getPedOccupiedVehicle(source) then return end
	removeEventHandler("onClientRender", root, drawSpeedometr)
end)
]]