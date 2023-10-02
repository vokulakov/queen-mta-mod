screenW, screenH = guiGetScreenSize()
local TEXTURE_MAP = dxCreateTexture("assets/map.jpg", "dxt5", true, "clamp") -- карта
--local TEXTURE_WATER = "assets/water.jpg" -- вода

local MAP_VISIBLE = false -- видимость карты
local MAP_WORLD_WIDTH, MAP_WORLD_HEIGHT = 3072, 3072 -- размер карты

MAP_MARGIN = 40 -- отступ от краёв экрана
local MAP_WIDTH, MAP_HEIGHT = screenW-MAP_MARGIN*2, screenH-MAP_MARGIN*2
local MAX_MAP_MARGIN = 30 -- ограничение перемещения карты

local mapRenderTarget = dxCreateRenderTarget(MAP_WIDTH, MAP_HEIGHT, true)
mW, mH = dxGetMaterialSize(mapRenderTarget)

local ZOOM = 1 -- начальный зум
local ZOOM_MIN = 1 -- минимальный зум
local ZOOM_MAX = 2 -- максимальный зум
local ZOOM_SPEED = 0.05 -- скорость зума

local MAP_X, MAP_Y = mW/2-MAP_WORLD_WIDTH/2/ZOOM, mH/2-MAP_WORLD_HEIGHT/2/ZOOM
local ZOOM_X, ZOOM_Y = 0, 0

local BLIPS = {
	localplayer = exports.queenTextures:createTexture('assets/hud_img/blips/2.png'),
	[0] 		= exports.queenTextures:createTexture('assets/hud_img/blips/0.png'),
	[45] 		= exports.queenTextures:createTexture('assets/hud_img/blips/45.png'),
	[47] 		= exports.queenTextures:createTexture('assets/hud_img/blips/47.png'),
	[50] 		= exports.queenTextures:createTexture('assets/hud_img/blips/50.png'),
	[17] 		= exports.queenTextures:createTexture('assets/hud_img/blips/17.png'),
}

local function getPlayerFromMap() -- центрирование карты
	local posxP, posyP, poszP = getElementPosition(localPlayer)
	local mapx = math.floor(MAP_WORLD_WIDTH/6000*(posxP*-1-3000))
	local mapy = math.floor(MAP_WORLD_HEIGHT/6000*(posyP-3000))
	ZOOM = ZOOM_MIN
	MAP_X, MAP_Y = mapx/ZOOM+mW/2, mapy/ZOOM+mH/2 -- перемещение на центр
	getMapLimit() 
	-- ДАННЫЕ ДЛЯ МАСШТАБИРОВАНИЯ КАРТЫ
	ZOOM_X = ((mW/2)-(MAP_X+(MAP_WORLD_WIDTH/ZOOM)/2))*ZOOM
	ZOOM_Y = ((mH/2)-(MAP_Y+(MAP_WORLD_HEIGHT/ZOOM)/2))*ZOOM

end

local function getMapFromWorldPosition(worldX, worldY) -- позиция на карте по позиции в мире
	local X = MAP_X+MAP_WORLD_WIDTH/6000*(worldX-(-3000))/ZOOM
	local Y = MAP_Y+MAP_WORLD_HEIGHT/6000*(3000-worldY)/ZOOM
	return X, Y
end

function getWorldPositionFromMap(mapX, mapY) -- позиция в мире по позиции на карте
	local px = ((mapX*6000 /(MAP_WORLD_WIDTH/ZOOM))-3000)
	local py = (3000 - (mapY*6000/(MAP_WORLD_HEIGHT/ZOOM)))
	return px, py
end

local function drawMap() -- КАРТА
	local posxP, posyP, poszP = getElementPosition(localPlayer)
	local _, _, rotzP = getElementRotation(localPlayer)
	local pX, pY = getMapFromWorldPosition(posxP, posyP)

	--getPlayerLocation(posxP, posyP, poszP)

	dxSetRenderTarget(mapRenderTarget)
		dxDrawRectangle(0, 0, mW, mH, tocolor(110, 158, 204))
		dxDrawImage(MAP_X, MAP_Y, MAP_WORLD_WIDTH/ZOOM, MAP_WORLD_HEIGHT/ZOOM, TEXTURE_MAP)

		-- Блипы
		for _, blip in ipairs(getElementsByType("blip")) do
			local blipx, blipy, blipz = getElementPosition(blip)
			local bX, bY = getMapFromWorldPosition(blipx, blipy)
			local blipicon = getBlipIcon(blip)
			local bcR, bcG, bcB, bcA = getBlipColor(blip)
			local distance = getDistanceBetweenPoints3D(blipx, blipy, blipz, posxP, posyP, poszP)
			local blipSize = 1.3

			if BLIPS[blipicon] then
				dxDrawImage(bX-(18/ZOOM)/2, bY-(18/ZOOM)/2, 18/ZOOM, 18/ZOOM, BLIPS[blipicon], camRotZ, 0, 0, tocolor(bcR, bcG, bcB, bcA))
			end
			-- игроки
			if distance < 120 and blipicon == 0 and getElementData(blip, 'blip.player') ~= localPlayer then
				if (blipz - poszP) >= 5 then
					--blipicon = "+1"
				elseif (blipz - poszP) <= -5 then
					--blipicon = "-1"
				end

				bcR, bcG, bcB = getBlipColor(blip)

				dxDrawImage(bX-(16*blipSize)/2, bY-(16*blipSize)/2, 16*blipSize, 16*blipSize, BLIPS[blipicon], 0, 0, 0, tocolor(bcR, bcG, bcB, bcA))
			end
		end
		--[[
		for _, blip in ipairs(getElementsByType("blip")) do
			local blipx, blipy, blipz = getElementPosition(blip)
			local blipicon = getBlipIcon(blip)
			local bX, bY = getMapFromWorldPosition(blipx, blipy)
			local blippath = "assets/blips/"..blipicon..".png"
			local bcR, bcG, bcB, bcA = getBlipColor(blip)
			local distance = getDistanceBetweenPoints3D(blipx, blipy, blipz, posxP, posyP, poszP)
			local blipSize = 1.3
			
			-- fileExists дает нагрузку
			if fileExists(blippath) and blipicon ~= 0 then
				dxDrawImage(bX-(18/ZOOM)/2, bY-(18/ZOOM)/2, 18/ZOOM, 18/ZOOM, blippath, camRotZ, 0, 0, tocolor(bcR, bcG, bcB, bcA))
			end

			if distance < 120 and blipicon == 0 and getElementData(blip, 'blip.player') ~= localPlayer then
				if (blipz - poszP) >= 5 then
					blippath = "assets/blips/+1.png"
				elseif (blipz - poszP) <= -5 then
					blippath = "assets/blips/-1.png"
				end

				bcR, bcG, bcB = getBlipColor(blip)

				dxDrawImage(bX-(16*blipSize)/2, bY-(16*blipSize)/2, 16*blipSize, 16*blipSize, blippath, 0, 0, 0, tocolor(bcR, bcG, bcB, bcA))
			end
		end
		]]
		dxDrawImage(pX-(20/ZOOM)/2, pY-(20/ZOOM)/2, 20/ZOOM, 20/ZOOM, BLIPS.localplayer, (-rotzP)%360, 0, 0, tocolor(255, 255, 255, 255)) -- позиция игрока
	dxSetRenderTarget()

	dxDrawRectangle(MAP_MARGIN-5, MAP_MARGIN-5, mW+10, mH+10, tocolor(33, 33, 33, 200), false)
	dxDrawImage(MAP_MARGIN, MAP_MARGIN, mW, mH, mapRenderTarget, 0, 0, 0, tocolor(255, 255, 255, 255), false)
end

local function zoomingMAP()
	MAP_X = mW/2 - (MAP_WORLD_WIDTH/ZOOM)/2 - (ZOOM_X)/ZOOM
	MAP_Y = mH/2 - (MAP_WORLD_HEIGHT/ZOOM)/2 - (ZOOM_Y)/ZOOM
	getMapLimit()
end

addEventHandler("onClientKey", root, function(button) -- изменение зума
	if not MAP_VISIBLE then return end
	if CLICK_MOVE then return end
    if button == "mouse_wheel_down" then
		if ZOOM < ZOOM_MAX then 
			ZOOM = ZOOM + ZOOM_SPEED
			zoomingMAP()
		end
	elseif button == "mouse_wheel_up" then
		if ZOOM > ZOOM_MIN then 
			ZOOM = ZOOM - ZOOM_SPEED 
			zoomingMAP()
		end
	end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state, absoluteX, absoluteY) 
	if not MAP_VISIBLE then return end
	if button == "left" then -- КЛИК ДЛЯ ПЕРЕМЕЩЕНИЯ КАРТЫ
		if state == "down" then
			if absoluteX > MAP_MARGIN and absoluteX < MAP_MARGIN+mW and absoluteY > MAP_MARGIN and absoluteY < MAP_MARGIN+mH then
				CLICK_MOVE = true
				moveX, moveY = absoluteX - MAP_X, absoluteY - MAP_Y
			end
		else
			CLICK_MOVE = false
		end
	elseif button == "right" then -- КЛИК ДЛЯ МЕТКИ
		if state == "down" then
		end
	end
end)

function getMapLimit() -- проверяем положение карты относительно рамки
	LIMIT_X, LIMIT_Y = mW-MAP_WORLD_WIDTH/ZOOM-MAX_MAP_MARGIN, mH-MAP_WORLD_HEIGHT/ZOOM-MAX_MAP_MARGIN 
	LIMIT_MAP_X, LIMIT_MAP_Y = LIMIT_X, LIMIT_Y

	if MAP_X >= MAX_MAP_MARGIN then -- если вышли за рамку слева
		LIMIT_MAP_X = MAP_X -- временная граница рамки слева
	elseif MAP_X/ZOOM <= LIMIT_X/ZOOM then -- если вышли за рамку справа
		LIMIT_MAP_X = MAP_X
	end

	if MAP_Y >= MAX_MAP_MARGIN then -- если вышли за рамку сверху
		LIMIT_MAP_Y = MAP_Y -- временная граница рамки сверху
	elseif MAP_Y/ZOOM <= LIMIT_Y/ZOOM then -- если вышли за рамку снизу
		LIMIT_MAP_Y = MAP_Y
	end

end

addEventHandler("onClientCursorMove", getRootElement(), function(cursorX, cursorY, mouseX, mouseY) -- перемещение карты
	if not MAP_VISIBLE then return end
	if not CLICK_MOVE then return end
	if mouseX > MAP_MARGIN and mouseX < MAP_MARGIN+mW and mouseY > MAP_MARGIN and mouseY < MAP_MARGIN+mH then 	-- ПРОВЕРКА ПОЛОЖЕНИЯ КУРСОРА

		MAP_X, MAP_Y = mouseX-moveX, mouseY-moveY	

		if LIMIT_MAP_X > MAX_MAP_MARGIN then -- находимся за рамкой слева
			if MAP_X >= LIMIT_MAP_X then --  временная граница слева
				MAP_X = LIMIT_MAP_X
			elseif MAP_X <= MAX_MAP_MARGIN then -- вернулись в границу рами слева
				LIMIT_MAP_X = LIMIT_X
			end
		elseif MAP_X >= MAX_MAP_MARGIN then -- граница рамки слева
			MAP_X = MAX_MAP_MARGIN
		end

		if LIMIT_MAP_X < LIMIT_X/ZOOM then -- находимся за рамкой справа
			if MAP_X <= LIMIT_MAP_X then -- временная граница справа
				MAP_X = LIMIT_MAP_X
			elseif MAP_X/ZOOM >= LIMIT_X/ZOOM then -- вернулись в границу рамки справа
				LIMIT_MAP_X = LIMIT_X
			end
		elseif MAP_X/ZOOM <= LIMIT_X/ZOOM then -- граница рамки справа
			MAP_X = LIMIT_X
		end

		if LIMIT_MAP_Y > MAX_MAP_MARGIN then -- находися за рамкой сверху
			if MAP_Y >= LIMIT_MAP_Y then -- временная граница сверху
				MAP_Y = LIMIT_MAP_Y
			elseif MAP_Y <= MAX_MAP_MARGIN then -- вернулись в границу рамки сверху
				LIMIT_MAP_Y = LIMIT_Y
			end
		elseif MAP_Y >= MAX_MAP_MARGIN then -- граница рамки сверху
			MAP_Y = MAX_MAP_MARGIN
		end

		if LIMIT_MAP_Y < LIMIT_Y/ZOOM then -- находимся за рамкой снизу
			if MAP_Y <= LIMIT_MAP_Y then -- временная граница снизу
				MAP_Y = LIMIT_MAP_Y
			elseif MAP_Y/ZOOM >= LIMIT_Y/ZOOM then -- вернулись в границу рамки снизу
				LIMIT_MAP_Y = LIMIT_Y
			end
		elseif MAP_Y/ZOOM <= LIMIT_Y/ZOOM then -- граница рамки снизу
			MAP_Y = LIMIT_Y
		end

		-- ДАННЫЕ ДЛЯ МАСШТАБИРОВАНИЯ КАРТЫ
		ZOOM_X = ((mW/2)-(MAP_X+(MAP_WORLD_WIDTH/ZOOM)/2))*ZOOM
		ZOOM_Y = ((mH/2)-(MAP_Y+(MAP_WORLD_HEIGHT/ZOOM)/2))*ZOOM
	else
		CLICK_MOVE = false
	end
end)

local function showMap()
	local ACTIVE_UI = getElementData(localPlayer, "queenPlayer.ACTIVE_UI")
	if ACTIVE_UI and getElementData(localPlayer, "queenPlayer.ACTIVE_UI") ~= 'map' then 
		return 
	end

	if getElementInterior(localPlayer) ~= 0 then return end
	
	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['map'] then return end

	if not MAP_VISIBLE then 
		getPlayerFromMap()
		triggerEvent("queenShaders.blurShaderStart", localPlayer)
		addEventHandler("onClientRender", root, drawMap)
		setElementData(localPlayer, "queenPlayer.ACTIVE_UI", "map")

		MapLegends.showLegendsPanel(true)
		bindKey("space", "down", MapLegends.showLegendsPanel)
	else
		CLICK_MOVE = false
		triggerEvent("queenShaders.blurShaderStop", localPlayer)
		removeEventHandler("onClientRender", root, drawMap)
		setElementData(localPlayer, "queenPlayer.ACTIVE_UI", false)

		MapLegends.showLegendsPanel(false)
		unbindKey("space", "down", MapLegends.showLegendsPanel)
	end
	--showChat(MAP_VISIBLE)
	showCursor(not MAP_VISIBLE)
	MapHelp.setVisible(not MAP_VISIBLE)

	MAP_VISIBLE = not MAP_VISIBLE
	triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, not MAP_VISIBLE)
	triggerEvent("queenShowUI.setVisiblePlayerComponentUI", localPlayer, "map", true)
end

setTimer(toggleControl, 1000, 0, "radar", false)

addEventHandler("onClientResourceStart", resourceRoot, function()
	bindKey("f11", "down", showMap)
end)

addEventHandler("onClientResourceStop", resourceRoot, function() -- отключение ресурса
	unbindKey("f11", "down", showMap)
end)

