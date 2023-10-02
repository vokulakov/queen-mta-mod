-- НАДПИСЬ НАД ПИКАПОМ [НАЧАЛО] --
local FUELING_STREAMED_TEXT = {}

local function dxDrawCustomText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, "default-bold", "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, "default-bold", "center", "center")
end

addEventHandler("onClientRender", root, function()
	local cx, cy, cz = getCameraMatrix()
	for _, pickup in pairs(FUELING_STREAMED_TEXT) do
		local xP, yP, zP = getElementPosition(pickup.pickup)
		if (isLineOfSightClear(xP, yP, zP, cx, cy, cz, true, true, false, false, true, true, true, nil)) then
			local x, y = getScreenFromWorldPosition(xP, yP, zP + pickup.z)
			if x and y then
				local distance = getDistanceBetweenPoints3D(cx, cy, cz, xP, yP, zP)
				if distance < 65 then
					dxDrawCustomText(pickup.text, x, y, x, y, tocolor(255, 255, 0), 1)
				end
			end
		end
	end
end)

addEventHandler("onClientElementStreamIn", root, function()
	if getElementType(source) == "pickup" then
		local data = getElementData(source, "queenSkinShop.PickupInfo")
		if data then
			FUELING_STREAMED_TEXT[source] = { pickup = source, text = data.text, z = data.textZ }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" and getElementData(source, "queenSkinShop.PickupInfo") then
		FUELING_STREAMED_TEXT[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --

local sx, sy = guiGetScreenSize()
local index, numberSkin, numberSkinMax, typeSkin, skinPedLook, isAnimTimer, rotationTimer

local function showWindowSkin(pickup)

	index = tonumber(getElementID(pickup))
	numberSkin = 1
	typeSkin = 'male'
	numberSkinMax = table.maxn(skinShopTable[index]["ID"][typeSkin])
	skinPreview(numberSkin)

	setCameraMatrix(skinShopTable[index].cam["CamX"], skinShopTable[index].cam["CamY"], skinShopTable[index].cam["CamZ"], skinShopTable[index].cam["lookAtX"], skinShopTable[index].cam["lookAtY"], skinShopTable[index].cam["lookAtZ"])
	-- GUI --
	windowSkin = guiCreateWindow((sx-300)/2, sy-110, 300, 95, "", false)
	guiWindowSetSizable(windowSkin, false)
	guiWindowSetMovable(windowSkin, false)

	button_male = guiCreateRadioButton(55, 25, 90, 20, "Мужчины", false, windowSkin)
	button_female = guiCreateRadioButton(55, 42, 90, 20, "Женщины", false, windowSkin)
	button_male:setData('queenSounds.UI', 'ui_select') -- звук клика
	button_female:setData('queenSounds.UI', 'ui_select') -- звук клика

	guiRadioButtonSetSelected(button_male, true)

	button_prev = guiCreateButton(10, 25, 40, 60, "<", false, windowSkin)
	guiSetProperty(button_prev, "NormalTextColour", "ffff9000")
	guiSetFont(button_prev, "sa-header")
	button_prev:setData('queenSounds.UI', 'ui_change') -- звук клика

	button_next = guiCreateButton(250, 25, 40, 60, ">", false, windowSkin)
	guiSetProperty(button_next, "NormalTextColour", "ffff9000")
	guiSetFont(button_next,"sa-header")
	button_next:setData('queenSounds.UI', 'ui_change') -- звук клика

	button_buy = guiCreateButton(145, 25, 100, 35, "Купить", false, windowSkin)
	guiSetProperty(button_buy, "NormalTextColour", "ffffffff" )
	button_buy:setData('queenSounds.UI', 'ui_select') -- звук клика
	
	button_out = guiCreateButton(55, 65, 190, 20, "Закрыть", false, windowSkin)
	guiSetProperty(button_out, "NormalTextColour", "ffffffff")
	button_out:setData('queenSounds.UI', 'ui_select') -- звук клика

	showCursor (true)
	---------

	local price = skinShopTable[index]["ID"][typeSkin][numberSkin][2]
	guiSetText(windowSkin, "["..numberSkin.."/"..numberSkinMax.."]")
	guiSetText(button_buy, "Купить за "..price.."$")
end

function skinPreview(num)

	if not isElement(skinPedLook) then
		skinPedLook = createPed(skinShopTable[index]["ID"][typeSkin][numberSkin][1], skinShopTable[index].cam["vPosX"], skinShopTable[index].cam["vPosY"], skinShopTable[index].cam["vPosZ"], skinShopTable[index].cam["vRot"])
		setElementDimension(skinPedLook, skinShopTable[index]["dim"])
		setElementInterior(skinPedLook, skinShopTable[index]["int"])

		setPedAnimation(skinPedLook, "CLOTHES", "CLO_Pose_Loop", -1, true, false)
	else
		setElementModel(skinPedLook, skinShopTable[index]["ID"][typeSkin][numberSkin][1])
	end

	setPedAnimation(skinPedLook, "CLOTHES", "CLO_Pose_Torso", -1, true, false, false, true)

	setElementRotation(skinPedLook, 0, 0, skinShopTable[index].cam["vRot"] - 90)

	isAnimTimer = setTimer(function()
		setPedAnimation(skinPedLook, "CLOTHES", "CLO_Pose_Loop", -1, true, false)

		rotationTimer = setTimer(function()
			if not isElement(skinPedLook) then return end
			local rotX, rotY, rotZ = getElementRotation(skinPedLook)
			setElementRotation(skinPedLook, rotX, rotY, rotZ + 5)
		end, 50, 0)

	end, 3000, 1)

end

--setPedAnimation(localPlayer, "CLOTHES", "CLO_Pose_Torso", 0, false, false, true, true)
--index = 3
--numberSkin = 1
--typeSkin = 'male'
--numberSkinMax = table.maxn(skinShopTable[index]["ID"][typeSkin])
--skinPreview(numberSkin)
--setCameraMatrix(skinShopTable[1].cam["CamX"], skinShopTable[1].cam["CamY"], skinShopTable[1].cam["CamZ"], skinShopTable[1].cam["lookAtX"], skinShopTable[1].cam["lookAtY"], skinShopTable[1].cam["lookAtZ"])

-- fadeCamera(false, 1)
-- fadeCamera(true, 1)
-- setCameraTarget(localPlayer)

addEventHandler("onClientGUIClick", root, function()
	if not isElement(windowSkin) then
		return
	end

	if source == windowSkin then
		return
	end

	if source == button_out or source == button_buy then
		destroyElement(windowSkin)
		showCursor(false)

		fadeCamera(false, 1)

		setTimer(function()
			if isTimer(rotationTimer) then
				killTimer(rotationTimer)
			end

			if isTimer(isAnimTimer) then
				killTimer(isAnimTimer)
			end

			if isElement(skinPedLook) then
				destroyElement(skinPedLook)
			end

			fadeCamera(true, 1)
			setCameraTarget(localPlayer, localPlayer)

			triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, true)
   	 		--showChat(true)
    		toggleControl("radar", false) -- отключение стандартной карты
		end, 1500, 1)

		if source == button_buy then
			local id = skinShopTable[index]["ID"][typeSkin][numberSkin][1]
			local price = skinShopTable[index]["ID"][typeSkin][numberSkin][2]
			triggerServerEvent("queenSkinShop.onPlayerSkinChange", localPlayer, id, price)
		end

		return
	elseif source == button_male or source == button_female then
		if source == button_female then
			if typeSkin == 'female' then return end
			typeSkin = 'female'
		elseif source == button_male then
			if typeSkin == 'male' then return end
			typeSkin = 'male'
		end
		numberSkin = 1
		numberSkinMax = table.maxn(skinShopTable[index]["ID"][typeSkin])
	elseif source == button_next then
		numberSkin = numberSkin + 1
		if numberSkin > numberSkinMax then
			numberSkin = 1
		end	
	elseif source == button_prev then
		numberSkin = numberSkin - 1
		if numberSkin == 0 then
			numberSkin = numberSkinMax
		end	
	end

	if isTimer(rotationTimer) then
		killTimer(rotationTimer)
	end

	if isTimer(isAnimTimer) then
		killTimer(isAnimTimer)
	end

	skinPreview(numberSkin)
	local price = skinShopTable[index]["ID"][typeSkin][numberSkin][2]
	guiSetText(windowSkin, "["..numberSkin.."/"..numberSkinMax.."]")
	guiSetText(button_buy, "Купить за "..price.."$")
end)

-- --

local soundBackGround 

addEvent("queenSkinShop.music", true)
addEventHandler("queenSkinShop.music", root, function(state)
	if state then
		soundBackGround = exports.queenSounds:playSound('int_skinshop', true)
		setSoundVolume(soundBackGround, 0.1)
	else
		if soundBackGround then
			stopSound(soundBackGround)
		end
	end
end)
-- --
addEventHandler('onClientResourceStart', resourceRoot, function()
	for i, M in ipairs(skinShopTable) do
		local pickupSkin = createPickup(M.skin_pickup.x, M.skin_pickup.y, M.skin_pickup.z, 3, 1275, 1000)
		
		addEventHandler("onClientPickupHit", pickupSkin, function(player)
			if player ~= localPlayer then return end
			triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, false)
    		--showChat(false)
    		
			fadeCamera(false, 1)
			setTimer(function(pickup)
				fadeCamera(true, 1)
				showWindowSkin(pickup)
			end, 1500, 1, source)

		end)

		setElementDimension(pickupSkin, M.dim)
		setElementInterior(pickupSkin, M.int)
		setElementID(pickupSkin, tostring(i))

		createBlip(M.entrance.x, M.entrance.y, M.entrance.z, 45, 0, 0, 255, 255, 255, 0, 450)
	end
end)