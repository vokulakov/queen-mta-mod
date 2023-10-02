local dxShader = exports.queenShaders:createShader("turnsignal.fx")

local sh = {}
local soundTurnSignal

local trigger = function(shader, type, veh)
	if sh[veh] then
		sh[veh] = nil
		
		if getVehicleOccupant(veh) == localPlayer then
			setElementData(veh, type..'_v', false)

			if isElement(soundTurnSignal) then
				destroyElement(soundTurnSignal)
			end
		end
		
		engineRemoveShaderFromWorldTexture(shader, type, veh)
	else
		sh[veh] = true
		
		if getVehicleOccupant(veh) == localPlayer then
			setElementData(veh, type..'_v', true)

			if isElement(soundTurnSignal) then
				destroyElement(soundTurnSignal)
			end
			soundTurnSignal = exports.queenSounds:playSound('veh_turnsignal')
		end
		
		engineApplyShaderToWorldTexture(shader, type, veh)
	end
end

local trigger2 = function(shader, veh)
	if sh[veh] then
		sh[veh] = nil
		engineRemoveShaderFromWorldTexture(shader, "rightflash", veh)
		engineRemoveShaderFromWorldTexture(shader, "leftflash", veh)
		
		if getVehicleOccupant(veh) == localPlayer then
			setElementData(veh, 'allflash_v', false)

			if isElement(soundTurnSignal) then
				destroyElement(soundTurnSignal)
			end
		end
		
	else
		sh[veh] = true
		engineApplyShaderToWorldTexture(shader, "rightflash", veh)
		engineApplyShaderToWorldTexture(shader, "leftflash", veh)
		
		if getVehicleOccupant(veh) == localPlayer then
			setElementData(veh, 'allflash_v', true)

			if isElement(soundTurnSignal) then
				destroyElement(soundTurnSignal)
			end
			soundTurnSignal = exports.queenSounds:playSound('veh_turnsignal')
		end
		
	end
end

setTimer(function()
	for _,v in ipairs(getElementsByType("vehicle")) do
		if getElementData(v, "rightflash") then
			setElementData(v, 'leftflash', false)
			setElementData(v, 'allflash', false)
			trigger(dxShader, "rightflash", v)
		end
	end
end, 600, 0)

setTimer(function()
	for _,veh in ipairs(getElementsByType("vehicle")) do
		if getElementData(veh, "leftflash") then
			setElementData(veh, 'rightflash', false)
			setElementData(veh, 'allflash', false)
			trigger(dxShader, "leftflash", veh)
		end
	end
end, 600, 0)

setTimer(function()
	for _,vehicle in ipairs(getElementsByType("vehicle")) do
		if getElementData(vehicle, "allflash") then
			setElementData(vehicle, "leftflash", false)
			setElementData(vehicle, "rightflash", false)
			trigger2(dxShader, vehicle)
		end
	end
end, 600, 0)

local left = function()
	local veh = getPedOccupiedVehicle(localPlayer)
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if not veh or seat ~= 0 then return end
	if setElementData(veh, "leftflash", true) then
		if getElementData(veh, 'rightflash') then
			setElementData(veh, "rightflash", false)
			setElementData(veh, 'rightflash_v', false)
			engineRemoveShaderFromWorldTexture(dxShader, "rightflash",veh)
		end
		setElementData(veh, "allflash_v", false)
		
		if getElementData(veh, "allflash") then
			engineRemoveShaderFromWorldTexture(dxShader, "rightflash",veh)
			setElementData(veh, "allflash_v", false)
		end
		
		engineApplyShaderToWorldTexture(dxShader, "leftflash", veh)
		setElementData(veh, 'leftflash_v', true)
	else
		setElementData(veh, "leftflash", false)
		setElementData(veh, 'leftflash_v', false)
		engineRemoveShaderFromWorldTexture(dxShader, "leftflash", veh)
	end
end
bindKey(",", "down", left)

local right = function()
	local veh = getPedOccupiedVehicle(localPlayer)
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if not veh or seat ~= 0 then return end
	if setElementData(veh, "rightflash", true) then
		if getElementData(veh, 'leftflash') then
			setElementData(veh, "leftflash", false)
			setElementData(veh, 'leftflash_v', false)
			engineRemoveShaderFromWorldTexture(dxShader, "leftflash",veh)
		end
		setElementData(veh, "allflash_v", false)
		
		if getElementData(veh, "allflash") then
			engineRemoveShaderFromWorldTexture(dxShader, "leftflash", veh)
			setElementData(veh, "allflash_v", false)
		end
		
		engineApplyShaderToWorldTexture(dxShader, "rightflash", veh)
		setElementData(veh, 'rightflash_v', true)
	else
		setElementData(veh, "rightflash", false)
		setElementData(veh, 'rightflash_v', false)
		engineRemoveShaderFromWorldTexture(dxShader, "rightflash",veh)
	end
end
bindKey(".", "down", right)

local all = function()
	local veh = getPedOccupiedVehicle(localPlayer)
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if not veh or seat ~= 0 then return end
	if not getElementData(veh, "allflash") then
		if getElementData(veh, 'leftflash') then
			setElementData(veh, "leftflash", false)
			setElementData(veh, 'leftflash_v', false)
			engineRemoveShaderFromWorldTexture(dxShader, "leftflash",veh)
		end
		if getElementData(veh, 'rightflash') then
			setElementData(veh, "rightflash", false)
			setElementData(veh, 'leftflash_v', false)
			engineRemoveShaderFromWorldTexture(dxShader, "rightflash",veh)
		end
		setElementData(veh, "allflash", true)
		
		engineApplyShaderToWorldTexture(dxShader, "rightflash", veh)
		engineApplyShaderToWorldTexture(dxShader, "leftflash", veh)
		setElementData(veh, "allflash_v", true)
	else
		setElementData(veh, "allflash", false)
		setElementData(veh, "allflash_v", false)
		engineRemoveShaderFromWorldTexture(dxShader, "rightflash",veh)
		engineRemoveShaderFromWorldTexture(dxShader, "leftflash",veh)
	end
end
bindKey("/", "down", all)

