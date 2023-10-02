sW, sH = guiGetScreenSize()

Dashboard = {}
Dashboard.UI = {}

Dashboard.isVisible = false

Dashboard.UI.FONT = {
	TITTLE = exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 12, false, "draft"),

	NICKNAME = exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 14, false, "draft"),
	TIME_BOLD = exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 11, false, "draft"),
	TIME_REG = exports.queenFonts:createFontGUI("Roboto-Regular.ttf", 11, false, "draft"),
	ID = exports.queenFonts:createFontGUI("Roboto-Regular.ttf", 8, false, "draft"),

	STAT_TITTLE = exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 10.5, false, "draft"),
	STAT_LBL = exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 9, false, "draft"),
	STAT_INFO = exports.queenFonts:createFontGUI("Roboto-Regular.ttf", 9, false, "draft"),
} 	

function Dashboard.showDashboard()
	Dashboard.UI.bg = guiCreateStaticImage(sW/2-700/2, sH/2-500/2, 700, 500, "assets/img/gui_dashboard.png", false)

	-- ШАПКА --
	Dashboard.UI.title = guiCreateLabel(27, 0, 140, 40, "ПАНЕЛЬ ИГРОКА", false, Dashboard.UI.bg)
	guiSetFont(Dashboard.UI.title, Dashboard.UI.FONT['TITTLE'])
	guiLabelSetColor(Dashboard.UI.title, 80, 80, 80)
	guiLabelSetVerticalAlign(Dashboard.UI.title, "center")

	Dashboard.UI.btn_close = guiCreateStaticImage(700-30-23, 40/2-30/2, 30, 30, "assets/img/button_close.png", false, Dashboard.UI.bg)
	Dashboard.UI.btn_close:setData('queenSounds.UI', 'ui_select') -- звук клика
	
	-- РАЗДЕЛЫ --
	Dashboard.UI.btn_account = guiCreateStaticImage(27, 50, 130, 25, "assets/img/button_account.png", false, Dashboard.UI.bg)
	Dashboard.UI.btn_account:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiMoveToBack(Dashboard.UI.btn_account)

	Dashboard.UI.btn_vehicle = guiCreateStaticImage(27+129, 50, 130, 25, "assets/img/button_cars.png", false, Dashboard.UI.bg)
	Dashboard.UI.btn_vehicle:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiMoveToBack(Dashboard.UI.btn_vehicle)

	Dashboard.UI.btn_help = guiCreateStaticImage(27+129*2, 50, 130, 25, "assets/img/button_help.png", false, Dashboard.UI.bg)
	Dashboard.UI.btn_help:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiMoveToBack(Dashboard.UI.btn_help)

	Dashboard.UI.btn_donat = guiCreateStaticImage(27+129*3, 50, 130, 25, "assets/img/button_donat.png", false, Dashboard.UI.bg)
	Dashboard.UI.btn_donat:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiMoveToBack(Dashboard.UI.btn_donat)

	Dashboard.UI.btn_settings = guiCreateStaticImage(27+129*4, 50, 130, 25, "assets/img/button_settings.png", false, Dashboard.UI.bg)
	Dashboard.UI.btn_settings:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiMoveToBack(Dashboard.UI.btn_settings)
end


addEventHandler('onClientRender', root, function()
	--dxDrawRectangle(0, sH/2-500/2+40, sW, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, sH/2-500/2+50, sW, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, sH/2-500/2+100, sW, 1, tocolor(0, 255, 255, 255), true)
	-- --
	--dxDrawRectangle(sW/2-700/2+27, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(sW/2+700/2-27, 0, 1, sH, tocolor(0, 255, 255, 255), true)
end)

function Dashboard.setVisible(isVisible)
	Dashboard.isVisible = isVisible

	triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, not Dashboard.isVisible)

	if Dashboard.isVisible then
		triggerEvent("queenShaders.blurShaderStart", localPlayer)
		setElementData(localPlayer, "queenPlayer.ACTIVE_UI", 'dashboard')
		Dashboard.showDashboard()
	else
		destroyElement(Dashboard.UI.bg)
		triggerEvent("queenShaders.blurShaderStop", localPlayer)
		setElementData(localPlayer, "queenPlayer.ACTIVE_UI", false)
	end

	showCursor(Dashboard.isVisible)
end


addEventHandler("onClientMouseEnter", root, function()
	if not isElement(Dashboard.UI.bg) then
		return
	end
	
	if source == Dashboard.UI.btn_close then
		guiStaticImageLoadImage(Dashboard.UI.btn_close, "assets/img/button_close_a.png")
	end
end)
	
addEventHandler("onClientMouseLeave", root, function()
	if not isElement(Dashboard.UI.bg) then
		return
	end

	if source == Dashboard.UI.btn_close then
		guiStaticImageLoadImage(Dashboard.UI.btn_close, "assets/img/button_close.png")
	end
end)

addEventHandler("onClientGUIClick", root, function()
	if not isElement(Dashboard.UI.bg) then
		return
	end

	if source == Dashboard.UI.bg then
		return
	end

	if source == Dashboard.UI.btn_close then
		Dashboard.setVisible(false)
	end


end)

-- --
bindKey('F1', 'down', function()
	Dashboard.setVisible(not Dashboard.isVisible)
	Dashboard.setAccountTabVisible(true)
end)