local drawRectangles = {}

function drawRectangle(x, y, w, h, alpha, round)
	local RECTANGLE_PANEL = exports["queenTextures"]:staticImage(x, y, w, h, 'assets/ui_img/panel/pane.png', false)
	guiSetProperty(RECTANGLE_PANEL, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
	guiSetAlpha(RECTANGLE_PANEL, alpha)
	guiSetEnabled(RECTANGLE_PANEL, false)

	if round then
		-- ЛЕВЫЙ КРАЙ
		local RECTANGLE_LEFT_UP = exports["queenTextures"]:staticImage(x-6, y, 6, 6, 'assets/ui_img/panel/round_1.png', false)
		guiSetProperty(RECTANGLE_LEFT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_UP, alpha)
		setElementParent(RECTANGLE_LEFT_UP, RECTANGLE_PANEL)

		local RECTANGLE_LEFT_CENTER = exports["queenTextures"]:staticImage(x-6, y+6, 6, h-12, 'assets/ui_img/panel/pane.png', false)
		guiSetProperty(RECTANGLE_LEFT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_CENTER, alpha)
		setElementParent(RECTANGLE_LEFT_CENTER, RECTANGLE_PANEL)

		local RECTANGLE_LEFT_DOWN = exports["queenTextures"]:staticImage(x-6, y+h-6, 6, 6, 'assets/ui_img/panel/round_4.png', false)
		guiSetProperty(RECTANGLE_LEFT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_LEFT_DOWN, alpha)
		setElementParent(RECTANGLE_LEFT_DOWN, RECTANGLE_PANEL)

		-- ПРАВЫЙ КРАЙ
		local RECTANGLE_RIGHT_UP = exports["queenTextures"]:staticImage(x+w, y, 6, 6, 'assets/ui_img/panel/round_2.png', false)
		guiSetProperty(RECTANGLE_RIGHT_UP, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_UP, alpha)
		setElementParent(RECTANGLE_RIGHT_UP, RECTANGLE_PANEL)

		local RECTANGLE_RIGHT_CENTER = exports["queenTextures"]:staticImage(x+w, y+6, 6, h-12, 'assets/ui_img/panel/pane.png', false)
		guiSetProperty(RECTANGLE_RIGHT_CENTER, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_CENTER, alpha)
		setElementParent(RECTANGLE_RIGHT_CENTER, RECTANGLE_PANEL)

		local RECTANGLE_RIGHT_DOWN = exports["queenTextures"]:staticImage(x+w, y+h-6, 6, 6, 'assets/ui_img/panel/round_3.png', false)
		guiSetProperty(RECTANGLE_RIGHT_DOWN, "ImageColours", "tl:FF000000 tr:FF000000 bl:FF000000 br:FF000000")
		guiSetAlpha(RECTANGLE_RIGHT_DOWN, alpha)
		setElementParent(RECTANGLE_RIGHT_DOWN, RECTANGLE_PANEL)
	end

	drawRectangles[RECTANGLE_PANEL] = RECTANGLE_PANEL

	return RECTANGLE_PANEL
end

function setRectangleSize(rectangle, width, height)
	local elements = getElementChildren(rectangle)
	local rectangle_x, rectangle_y = guiGetPosition(rectangle, false)
	local rectangle_w, rectangle_h = guiGetSize(rectangle, false)
	guiSetSize(rectangle, width, height, false)
	for k, v in ipairs(elements) do
		if getElementType(v) == 'gui-staticimage' then
			local element_x, element_y = guiGetPosition(v, false)
			if tonumber(rectangle_x + rectangle_w) == tonumber(element_x) then
				guiSetPosition(v, rectangle_x + width, element_y, false)
			end
		end
	end
end

addEventHandler("onClientElementDestroy", root, function()
	if source.type == 'gui-staticimage' then
		--local elements = getElementChildren(source)
		if drawRectangles[source] then
			drawRectangles[source] = nil
		end
	end
end)