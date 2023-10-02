Radar = {}
Radar.visible = false

local posX, posY
local width, height = 180, 180

local TXT = {}
local zoneNames = {}
local vehNames = {}

local DRAW_POST_GUI = false

local scale = DEFAULT_SCALE
local fallbackTo2d = true
local camera
local chunkRenderSize -- Обновляется каждый кадр

local arrowSize = 20 -- размер блипа локального игрока
local blipTextureSize = 16

local chunksTextures = {}
local WORLD_SIZE = 3072
local CHUNK_SIZE = 256
local CHUNKS_COUNT = 12
local SCALE_FACTOR = 2.5

local DEFAULT_SCALE = 2
local MAX_SPEED_SCALE = 1.3

local function drawInfo()
	local playerPosition = Vector3(localPlayer.position)
	-- Damage
	--dxDrawImage(posX, posY, 180, 180, TXT.damage, 0, 0, 0, tocolor(255, 255, 255, 255), false)

	-- GPS
	--dxDrawImage(posX+180, posY+170-22-52, 26, 26, TXT.point)
	--dxDrawText("1.6km", posX+180+30, posY+170-22-50, 0, 0, tocolor(254, 254, 254, 255), 1, HUD.FONTS['radar_font']) 

	-- Автомобиль
	local veh = localPlayer.vehicle
	if veh then
		local vehName = vehNames[getElementModel(veh)] or getVehicleName(veh)

		dxDrawImage(posX+180, posY+170-22-26, 26, 26, TXT.vehicle)
		dxDrawText(vehName, posX+180+30, posY+170-22-22, 0, 0, tocolor(254, 254, 254, 255), 1, HUD.FONTS['radar_font']) 
	end
	-- Местоположение
	dxDrawImage(posX+180, posY+170-22, 26, 26, TXT.location)

	local zoneName = zoneNames[getZoneName(playerPosition.x, playerPosition.y, playerPosition.z)]
	local city = getZoneName(playerPosition.x, playerPosition.y, playerPosition.z, true)
	dxDrawText(zoneName..", "..city, posX+180+30, posY+170-20, 0, 0, tocolor(254, 254, 254, 255), 1, HUD.FONTS['radar_font']) 
end

local function drawBlips()
	local px, py, pz = getElementPosition(localPlayer)
	for _, blip in ipairs(getElementsByType("blip")) do
		local x, y, z = getElementPosition(blip)
		local blipicon = getBlipIcon(blip)
		local bcR, bcG, bcB, bcA = getBlipColor(blip)

		if getDistanceBetweenPoints2D(x, y, px, py) < 100 then
			--outputDebugString(blipicon)
			Radar.drawImageOnMap(
				x, y, camera.rotation.z,
				TXT.blip[tonumber(blipicon)],
				blipTextureSize,
				blipTextureSize,
				tocolor(bcR, bcG, bcB, bcA)
			)

		end
    end

end

local function drawRadarChunk(x, y, chunkX, chunkY)
	local chunkID = chunkX + chunkY * CHUNKS_COUNT
	if chunkID < 0 or chunkID > 143 or chunkX >= CHUNKS_COUNT or chunkY >= CHUNKS_COUNT or chunkX < 0 or chunkY < 0 then
		return
	end

	local posX, posY = ((x - (chunkX) * CHUNK_SIZE) / CHUNK_SIZE) * chunkRenderSize,
				       ((y - (chunkY) * CHUNK_SIZE) / CHUNK_SIZE) * chunkRenderSize
	dxDrawImage(width / 2 - posX, width / 2 - posY, chunkRenderSize, chunkRenderSize, chunksTextures[chunkID])
end

local function drawRadarSection(x, y)
	local chunkX = math.floor(x / CHUNK_SIZE)
	local chunkY = math.floor(y / CHUNK_SIZE)

	drawRadarChunk(x, y, chunkX - 1, chunkY)
	drawRadarChunk(x, y, chunkX, chunkY)
	drawRadarChunk(x, y, chunkX + 1, chunkY)

	drawRadarChunk(x, y, chunkX - 1, chunkY - 1)
	drawRadarChunk(x, y, chunkX, chunkY - 1)
	drawRadarChunk(x, y, chunkX + 1, chunkY - 1)

	drawRadarChunk(x, y, chunkX - 1, chunkY + 1)
	drawRadarChunk(x, y, chunkX, chunkY + 1)
	drawRadarChunk(x, y, chunkX + 1, chunkY + 1)
end

local function drawRadar()
	--dxDrawRectangle(0, posY+170-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, posY+140-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, posY+131-1/2, sW, 1, tocolor(0, 255, 255, 255), true)

	local x = (localPlayer.position.x + 3000) / 6000 * WORLD_SIZE
	local y = (-localPlayer.position.y + 3000) / 6000 * WORLD_SIZE

	local sectionX = x
	local sectionY = y
	dxDrawRectangle(0, 0, width, height, tocolor(110, 158, 204))

	drawRadarSection(sectionX, sectionY)

	dxDrawImage(
		(width - arrowSize) / 2,
		(height - arrowSize) / 2,
		arrowSize,
		arrowSize,
		TXT.blip.localplayer,
		-localPlayer.rotation.z,
		0,
		0
	)

	drawBlips()

end

addEventHandler("onClientRender", root, function ()
	if not Radar.visible then
		return
	end

	if Camera.interior ~= 0 then
		return
	end

	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['radar'] then return end

	scale = DEFAULT_SCALE
	-- Отдаление радара при быстрой езде
	if localPlayer.vehicle then
		local speed = localPlayer.vehicle.velocity.length
		scale = scale - math.min(MAX_SPEED_SCALE, speed * 1)
	end
	chunkRenderSize = CHUNK_SIZE * scale / SCALE_FACTOR

	if not fallbackTo2d then
		-- Отрисовка радара в renderTarget
		dxSetRenderTarget(renderTarget, true)
			drawRadar()
		dxSetRenderTarget()

		-- Следование за игроком
		maskShader:setValue("gUVRotAngle", -math.rad(camera.rotation.z))
		maskShader:setValue("gUVPosition", 0, 0)
		maskShader:setValue("gUVScale", 1, 1)
		maskShader:setValue("sPicTexture", renderTarget)
		maskShader:setValue("sMaskTexture", TXT.mask)

		-- Контур
		dxDrawImage(
			posX,
			posY, 
			width, 
			height, 
			TXT.cover, 
			camera.rotation.z, 0, 0, 
			tocolor(255, 255, 255, 255), 
			DRAW_POST_GUI
		)

		-- Локальный игрок
		dxDrawImage(
			posX,
			posY,
			width,
			height,
			maskShader,
			0, 0, 0,
			tocolor(255, 255, 255, 255),
			DRAW_POST_GUI
		)

		drawInfo()
	end

end)

function Radar.start()
	if renderTarget then return false end

	renderTarget = dxCreateRenderTarget(width, height, true)
	maskShader = exports.queenShaders:createShader("mask3d.fx")

	posX, posY = HUD.radar.posX, HUD.radar.posY

	fallbackTo2d = false

	if not (renderTarget and maskShader) then
		fallbackTo2d = true
		outputDebugString("Radar: Failed to create renderTarget or shader")
		return
	end

	TXT = {
		mask 	   = dxCreateTexture('assets/imgRadar/radar_mask.png'),
		cover 	   = dxCreateTexture('assets/imgRadar/radar_cover.png'),
		damage 	   = dxCreateTexture('assets/imgRadar/radar_damag.png'),
		location   = dxCreateTexture('assets/imgRadar/icon_gps.png'),
		vehicle	   = dxCreateTexture('assets/imgRadar/icon_car.png'),
		point      = dxCreateTexture('assets/imgRadar/icon_point.png'),

		blip = {

			localplayer = exports.queenTextures:createTexture('assets/hud_img/blips/2.png'),
			[0] 		= exports.queenTextures:createTexture('assets/hud_img/blips/0.png'),
			[45] 		= exports.queenTextures:createTexture('assets/hud_img/blips/45.png'),
			[47] 		= exports.queenTextures:createTexture('assets/hud_img/blips/47.png'),
			[50] 		= exports.queenTextures:createTexture('assets/hud_img/blips/50.png'),
			[17] 		= exports.queenTextures:createTexture('assets/hud_img/blips/17.png'),
			--[11] 		= exports.queenTextures:createTexture('assets/hud_img/blips/11.png'),
			--[12] 		= exports.queenTextures:createTexture('assets/hud_img/blips/12.png'),
			--[18] 		= exports.queenTextures:createTexture('assets/hud_img/blips/18.png'),
		}	

	}

	zoneNames = exports.queenShared:getLocationList()
	vehNames = exports.queenShared:getVehiclesNameList()

	maskShader:setValue("gUVRotCenter", 0.5, 0.5)
	maskShader:setValue("sMaskTexture", TXT.mask)

	for i = 0, 143 do
		chunksTextures[i] = dxCreateTexture("assets/imgRadar/map/radar" .. i .. ".png", "dxt5", true, "clamp")
	end

	camera = getCamera()
end

function Radar.setVisible(visible)
	Radar.visible = not not visible
end

function Radar.drawImageOnMap(globalX, globalY, rotationZ, image, imgWidth, imgHeight, color)
	if not image then
		return
	end
	if not color then
		color = tocolor(255, 255, 255)
	end
	local relativeX, relativeY = localPlayer.position.x - globalX,
								 localPlayer.position.y - globalY
	local mapX, mapY = 	relativeX / 6000 * WORLD_SIZE * scale / SCALE_FACTOR,
						relativeY / 6000 * WORLD_SIZE * scale / SCALE_FACTOR

	local distance = mapX * mapX + mapY * mapY
	-- Картинка слишком далеко от игрока, нет смысла рисовать
	if distance > chunkRenderSize * chunkRenderSize * 9 then
		return
	end
	dxDrawImage((width -  imgWidth) / 2 - mapX,
				(height - imgHeight) / 2 + mapY, imgWidth, imgHeight, image,
				 -rotationZ, 0, 0, color)
end
--[[
local radarRenderTarget = dxCreateRenderTarget(180, 180) 
local rtW, rtH = dxGetMaterialSize(radarRenderTarget)

local posX, posY, mapX, mapY, mapW, mapH, mapZoomScale

local radarMaskShader = exports.queenShaders:createShader("mask3d.fx")

local TXT = {
	mask 	   = dxCreateTexture('assets/imgRadar/radar_mask.png', "argb", true),
	cover 	   = dxCreateTexture('assets/imgRadar/radar_cover.png', "argb", true),
	damage 	   = dxCreateTexture('assets/imgRadar/radar_damag.png', "argb", true),
	location   = dxCreateTexture('assets/imgRadar/icon_gps.png', "argb", true),
	vehicle	   = dxCreateTexture('assets/imgRadar/icon_car.png', "argb", true),
	point      = dxCreateTexture('assets/imgRadar/icon_point.png', "argb", true),

	map		   = exports.queenTextures:createTexture('assets/hud_img/world.jpg', "argb", true),

	blip = {

		localplayer = exports.queenTextures:createTexture('assets/hud_img/blips/2.png', "argb", true)
	}

}

local function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))

	if t < 0 then t = t + 360 end
	return t
end

local function getDistanceRotation(x, y, dist, angle)
	local a = math.rad(90 - angle)
	local dx = math.cos(a) * dist
	local dy = math.sin(a) * dist

	return x+dx, y+dy
end

local function drawRadar()
	if Camera.interior ~= 0 then
		return
	end

	local playerPosition = Vector3(localPlayer.position)
	local X, Y = rtW/2 - (playerPosition.x/mapZoomScale), rtH/2 + (playerPosition.y/mapZoomScale)

	dxDrawRectangle(0, posY+171-1/2, sW, 1, tocolor(0, 255, 255, 255), true)

	dxSetRenderTarget(radarRenderTarget, true) 
		dxDrawRectangle(0, 0, rtW, rtH, tocolor(124, 167, 209)) -- water
		dxDrawImage(X - (mapW)/2, Y - (mapH)/2, mapW, mapH, TXT.map)
	dxSetRenderTarget() 
	dxSetShaderValue(radarMaskShader, "sPicTexture", radarRenderTarget)

	dxDrawImage(posX, posY, 180, 180, radarMaskShader, Camera.rotation.z, 0, 0, tocolor(255, 255, 255, 255))
	dxDrawImage(posX, posY, 180, 180, TXT.cover, Camera.rotation.z, 0, 0, tocolor(255, 255, 255, 255), false)

	-- LOCAL PLAYER --
	local blipSize = 20
	dxDrawImage(posX+centerX - blipSize/2, posY+centerY - blipSize/2, blipSize, blipSize, TXT.blip.localplayer, Camera.rotation.z-localPlayer.rotation.z, 0, 0)
	------------------

	-- Damage
	dxDrawImage(posX, posY, 180, 180, TXT.damage, 0, 0, 0, tocolor(255, 255, 255, 255), false)

	-- GPS
	dxDrawImage(posX+180, posY+170-22-52, 26, 26, TXT.point)
	dxDrawText("1.6km", posX+180+30, posY+170-22-50, 0, 0, tocolor(254, 254, 254, 255), 1, HUD.FONTS['radar_font']) 

	-- Автомобиль
	dxDrawImage(posX+180, posY+170-22-26, 26, 26, TXT.vehicle)
	dxDrawText("Infernus", posX+180+30, posY+170-22-24, 0, 0, tocolor(254, 254, 254, 255), 1, HUD.FONTS['radar_font']) 

	-- Местоположение
	dxDrawImage(posX+180, posY+170-22, 26, 26, TXT.location)

	local location = getZoneName(playerPosition.x, playerPosition.y, playerPosition.z)
	local city = getZoneName(playerPosition.x, playerPosition.y, playerPosition.z, true)
	dxDrawText(location..", "..city, posX+180+30, posY+170-20, 0, 0, tocolor(254, 254, 254, 255), 1, HUD.FONTS['radar_font']) 
end

function showRadar(state)
	if not state then
		return removeEventHandler('onClientRender', root, drawRadar, false)
	end

	posX, posY = HUD.radar.posX, HUD.radar.posY
	mapW, mapH = dxGetMaterialSize(TXT.map)

	mapZoomScale = 6000/mapW

	addEventHandler('onClientRender', root, drawRadar, false)

	dxSetShaderValue(radarMaskShader, "sMaskTexture", TXT.mask) 
	dxSetShaderValue(radarMaskShader, "gUVRotCenter", 0, 0)
	dxSetShaderValue(radarMaskShader, "gUVRotAngle", 0)
end

-- Нужно очищать за собой мусор, иначе происходит переполнение оперативы
addEventHandler('onClientResourceStop', resourceRoot, function()
	destroyElement(radarMaskShader)

	for i, texture in pairs(TXT) do
		destroyElement(texture)
	end
end)
]]