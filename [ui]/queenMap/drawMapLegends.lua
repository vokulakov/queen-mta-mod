MapLegends = {}

MapLegends.isVisible = false

local isMapLegends 

local BLIPS = {
	{ text = "Вы", 				url = "assets/hud_img/blips/2.png" }, -- локальный игрок
	{ text = "Игрок", 			url = "assets/hud_img/blips/0.png" },
	{ text = "Магазин одежды", 	url = "assets/hud_img/blips/45.png", color = tocolor(0, 255, 255) },
	{ text = "АЗС", 			url = "assets/hud_img/blips/47.png", color = tocolor(255, 0, 0) },
	{ text = "Ресторан", 		url = "assets/hud_img/blips/50.png", color = tocolor(255, 0, 0) },
	{ text = "Больница", 		url = "assets/hud_img/blips/17.png", color = tocolor(255, 0, 0) },
	--{text = "Работа грузчика", url = "assets/blips/12.png"},
	--{text = "Автосервис", url = "assets/blips/18.png"},
} 

--! ПЕРЕДЕЛАТЬ НА DX

-- exports["queenTextures"]:staticImage(x-6, y, 6, 6, 'assets/ui_img/panel/round_1.png', false)
local TEXT_FONT = exports.queenFonts:createFontGUI("Roboto-Regular.ttf", 12, false, "draft")

function MapLegends.drawBlipRectangle(text, url, x, y, color)
	if not color then
		color = tocolor(255, 255, 255)
	end

	-- РАСЧЕТ РАЗМЕРОВ
	local TEST_TEXT = guiCreateLabel(x, y, 0, 0, text, false)
	guiSetFont(TEST_TEXT, TEXT_FONT)
	local WIDTH, HEIGHT = guiLabelGetTextExtent(TEST_TEXT), guiLabelGetFontHeight(TEST_TEXT)
	destroyElement(TEST_TEXT)

	-- ФОН
	local BLIP_BACKROUND = exports.queenNotification:drawRectangle(mW-WIDTH+10-26, y, WIDTH+20+26, HEIGHT+8, 0.8, false)
	
	-- ТЕКСТ
	local BLIP_TEXT = guiCreateLabel(mW-WIDTH-8, y+4, WIDTH, HEIGHT, text, false)
	guiLabelSetHorizontalAlign(BLIP_TEXT, "center")
	guiSetFont(BLIP_TEXT, TEXT_FONT)
	setElementParent(BLIP_TEXT, BLIP_BACKROUND)

	-- BLIP
	local BLIP_IMAGE = exports["queenTextures"]:staticImage(WIDTH+15, HEIGHT/2-13+4, 26, 26, url, false, BLIP_BACKROUND)

	return BLIP_BACKROUND
end

function MapLegends.legendsOfBlips(x, y, w, h)
	local RECTANGLE = exports.queenNotification:drawRectangle(x, y, w, h, 0, false)

	local W = 0
	for i, data in ipairs(BLIPS) do
		LEGEND_BLIP = MapLegends.drawBlipRectangle(data.text, data.url, x, y+W*30)
		setElementParent(LEGEND_BLIP, RECTANGLE)
		W = W+1
	end

	return RECTANGLE
end

function MapLegends.showLegendsPanel(isVisible) -- панель легенд
	if not isVisible and not MapLegends.isVisible then
		return
	end

	if MapLegends.isVisible then
		destroyElement(isMapLegends)
		MapLegends.isVisible = false
	else
		isMapLegends = MapLegends.legendsOfBlips(mW-260+10, MAP_MARGIN+10, 260, mH-MAP_MARGIN-35) 

		MapLegends.isVisible = true
	end
end