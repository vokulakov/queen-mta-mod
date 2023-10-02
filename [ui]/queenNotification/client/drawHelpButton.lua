local drawButtons = { }

function drawHelpButton(x, y, w, text, font_scale, alpha, button)
	local TEXT_FONT = exports["queenFonts"]:createFontGUI("Roboto-Regular.ttf", font_scale)

	-- РАСЧЕТ РАЗМЕРОВ
	local TEST_TEXT = guiCreateLabel(x, y, w, 26, text, false)
	guiSetFont(TEST_TEXT, TEXT_FONT)
	local WIDTH, HEIGHT = guiLabelGetTextExtent(TEST_TEXT), guiLabelGetFontHeight(TEST_TEXT)
	destroyElement(TEST_TEXT)

	-- ЦЕНТРАЛЬНАЯ ПАНЕЛЬ
	local HELP_PANEL = exports["queenTextures"]:staticImage(x, y, WIDTH+5+26, HEIGHT+10, "assets/ui_img/panel/pane.png", false)
	guiSetProperty(HELP_PANEL, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_PANEL, alpha)
	guiSetEnabled(HELP_PANEL, false)

	-- ЛЕВЫЙ КРАЙ
	local HELP_LEFT_UP = exports["queenTextures"]:staticImage(x-6, y, 6, 6, "assets/ui_img/panel/round_1.png", false)
	guiSetProperty(HELP_LEFT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_UP, alpha)
	setElementParent(HELP_LEFT_UP, HELP_PANEL)

	local HELP_LEFT_CENTER = exports["queenTextures"]:staticImage(x-6, y+6, 6, HEIGHT-2, "assets/ui_img/panel/pane.png", false)
	guiSetProperty(HELP_LEFT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_CENTER, alpha)
	setElementParent(HELP_LEFT_CENTER, HELP_PANEL)

	local HELP_LEFT_DOWN = exports["queenTextures"]:staticImage(x-6, y+10+HEIGHT-6, 6, 6, "assets/ui_img/panel/round_4.png", false)
	guiSetProperty(HELP_LEFT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_LEFT_DOWN, alpha)
	setElementParent(HELP_LEFT_DOWN, HELP_PANEL)

	-- ПРАВЫЙ КРАЙ
	local HELP_RIGHT_UP = exports["queenTextures"]:staticImage(x+WIDTH+26+5, y, 6, 6, "assets/ui_img/panel/round_2.png", false)
	guiSetProperty(HELP_RIGHT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_UP, alpha)
	setElementParent(HELP_RIGHT_UP, HELP_PANEL)

	local HELP_RIGHT_CENTER = exports["queenTextures"]:staticImage(x+WIDTH+26+5, y+6, 6, HEIGHT-2, "assets/ui_img/panel/pane.png", false)
	guiSetProperty(HELP_RIGHT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_CENTER, alpha)
	setElementParent(HELP_RIGHT_CENTER, HELP_PANEL)

	local HELP_RIGHT_DOWN = exports["queenTextures"]:staticImage(x+WIDTH+26+5, y+10+HEIGHT-6, 6, 6, "assets/ui_img/panel/round_3.png", false)
	guiSetProperty(HELP_RIGHT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(HELP_RIGHT_DOWN, alpha)
	setElementParent(HELP_RIGHT_DOWN, HELP_PANEL)

	-- ТЕКСТ
	local HELP_TEXT = guiCreateLabel(x, y+5, WIDTH, HEIGHT, text, false)
	guiLabelSetHorizontalAlign(HELP_TEXT, "center")
	guiSetFont(HELP_TEXT, TEXT_FONT)
	setElementParent(HELP_TEXT, HELP_PANEL)
	
	-- КНОПКА
	if button ~= "" then
		local HELP_BUTTON = exports["queenTextures"]:staticImage(WIDTH+5, HEIGHT/2-13+5, 26, 26, "assets/ui_img/buttons/"..button..".png", false, HELP_PANEL)
		guiSetEnabled(HELP_BUTTON, false)
	end

	drawButtons[HELP_PANEL] = HELP_PANEL

	return HELP_PANEL
end


addEventHandler("onClientElementDestroy", root, function()
	if source.type == 'gui-staticimage' then
		--local elements = getElementChildren(source)
		if drawButtons[source] then
			drawButtons[source] = nil
		end
	end
end)