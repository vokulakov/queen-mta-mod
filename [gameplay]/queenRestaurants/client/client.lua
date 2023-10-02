for _, pick in ipairs(RestaurantsConfig.position) do
	createBlip(pick.eX, pick.eY, pick.eZ, 50, 0, 255, 168, 0, 255, 0, 450)
end

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
		local data = getElementData(source, "queenRestaurants.PickupInfo")
		if data then
			FUELING_STREAMED_TEXT[source] = { pickup = source, text = data.text, z = data.textZ }
		end
	end
end)

addEventHandler("onClientElementStreamOut", root, function()
	if getElementType(source) == "pickup" and getElementData(source, "queenRestaurants.PickupInfo") then
		FUELING_STREAMED_TEXT[source] = nil
	end
end)
-- НАДПИСЬ НАД ПИКАПОМ [КОНЕЦ] --

-- Фоновая музыка
local soundBackGround 

addEvent("queenRestaurants.music", true)
addEventHandler("queenRestaurants.music", root, function(state)
	if state then
		soundBackGround = exports.queenSounds:playSound('int_restaurant', true)
		setSoundVolume(soundBackGround, 0.1)
	else
		if soundBackGround then
			stopSound(soundBackGround)
		end
	end
end)

addEvent("queenRestaurants.onPlayerEat", true)
addEventHandler("queenRestaurants.onPlayerEat", root, function()
	local soundFX = exports.queenSounds:playSound('sound_eat2')
	setSoundVolume(soundFX, 0.2)
end)

-- GUI
local sx, sy = guiGetScreenSize()
local UI = {}
local foodID = 1
local isPickup 

local function showWindowFood()
	if not type(isPickup) == 'table' then
		return 
	end

	UI.wnd = guiCreateWindow(sx/2-300/2, sy/2-250/2, 300, 250, isPickup.name, false)
	guiWindowSetSizable(UI.wnd, false)
	guiWindowSetMovable(UI.wnd, false)

	UI.food_img = guiCreateStaticImage(300/2-200/2, 30, 200, 100, isPickup.foods[foodID].img, false, UI.wnd)

	--
	UI.food_name = guiCreateLabel(0, 135, 300, 20, isPickup.foods[foodID].name, false, UI.wnd)
	--UI.login.info = guiCreateLabel(0, 65, 300, 20, "Пожалуйста, авторизируйтесь.", false, UI.login.bg)
	--guiSetFont(UI.login.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.food_name, 255, 168, 0)
	guiLabelSetHorizontalAlign(UI.food_name, "center", false)

	--UI.food_info = guiCreateLabel(0, 155, 300, 20, pickup.foods[1].price..'$', false, UI.wnd)
	--guiLabelSetColor(UI.food_info, 255, 168, 0)
	--guiLabelSetHorizontalAlign(UI.food_info, "center", false)
	--

	UI.btn_prev = guiCreateButton(10, 180, 40, 60, "<", false, UI.wnd)
	guiSetProperty(UI.btn_prev, "NormalTextColour", "ffff9000")
	guiSetFont(UI.btn_prev, "sa-header")
	UI.btn_prev:setData('queenSounds.UI', 'ui_change') -- звук клика

	UI.btn_next = guiCreateButton(250, 180, 40, 60, ">", false, UI.wnd)
	guiSetProperty(UI.btn_next, "NormalTextColour", "ffff9000")
	guiSetFont(UI.btn_next,"sa-header")
	UI.btn_next:setData('queenSounds.UI', 'ui_change') -- звук клика

	UI.btn_buy = guiCreateButton(55, 180, 190, 35, "Купить", false, UI.wnd)
	guiSetProperty(UI.btn_buy, "NormalTextColour", "ffffffff" )
	UI.btn_buy:setData('queenSounds.UI', 'ui_select') -- звук клика

	UI.btn_close = guiCreateButton(55, 220, 190, 20, "Закрыть", false, UI.wnd)
	guiSetProperty(UI.btn_close, "NormalTextColour", "ffffffff")
	UI.btn_close:setData('queenSounds.UI', 'ui_select') -- звук клика
	--

	guiSetText(UI.btn_buy, "Купить за "..isPickup.foods[foodID].price.."$")


	showCursor(true)
end

addEvent('queenRestaurants.onPlayerPickupHit', true)
addEventHandler('queenRestaurants.onPlayerPickupHit', root, function(pickup)
	isPickup = pickup:getData('queenRestaurants.isPickupInfo')
	showWindowFood()
end)

addEventHandler("onClientGUIClick", root, function()
	if not isElement(UI.wnd) then
		return
	end

	if source == UI.wnd then
		return
	end

	local foodMax = table.maxn(isPickup.foods)

	if source == UI.btn_close or source == UI.btn_buy then
		destroyElement(UI.wnd)
		showCursor(false)

		if source ==  UI.btn_buy then
			triggerServerEvent("queenRestaurants.onPlayerBuyFood", localPlayer, isPickup.foods[foodID].name, isPickup.foods[foodID].price, isPickup.foods[foodID].add)
		end

		return
	elseif source == UI.btn_next then
		foodID = foodID + 1
		if foodID > foodMax then
			foodID = 1
		end	
	elseif source == UI.btn_prev then
		foodID = foodID - 1
		if foodID == 0 then
			foodID = foodMax
		end	
	end

	guiSetText(UI.food_name, isPickup.foods[foodID].name)
	guiSetText(UI.btn_buy, "Купить за "..isPickup.foods[foodID].price.."$")
	guiStaticImageLoadImage(UI.food_img, isPickup.foods[foodID].img)
end)
