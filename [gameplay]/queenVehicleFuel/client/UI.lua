sW, sH = guiGetScreenSize()

UI = {}

UI.FONTS = {
	['TITTLE']			= exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 12, false, "draft"),
	['INFO']			= exports.queenFonts:createFontGUI("Roboto-Regular.ttf", 9, false, "draft"),
	['PROGRESSBAR']		= exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 9, false, "draft"),
	['RADIOBUTTON']		= exports.queenFonts:createFontGUI("Roboto-Bold.ttf", 10.5, false, "draft"),
}

local function drawFuelingWindow()
	UI.bg = guiCreateStaticImage(sW/2-400/2, sH/2-300/2, 400, 300, "assets/img/gui_oils_fon.png", false)

	UI.tittle = guiCreateLabel(20, 0, 100, 38, "ЗАПРАВКА", false, UI.bg)
	guiSetFont(UI.tittle, UI.FONTS['TITTLE'])
	guiLabelSetColor(UI.tittle, 80, 80, 80)
    guiLabelSetVerticalAlign(UI.tittle, "center")

	UI.info = guiCreateLabel(0, 38+10, 400, 30, 'Приветствуем вас на нашей заправке!\nСколько литров желаете заправить?', false, UI.bg)
	guiSetFont(UI.info, UI.FONTS['INFO'])
	guiLabelSetColor(UI.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.info, "center", false)

	UI.info = guiCreateLabel (0, 38+10+37, 400, 20, "КОЛ-ВО ЛИТРОВ", false, UI.bg)
	guiSetFont(UI.info, UI.FONTS['TITTLE'])
	guiLabelSetColor(UI.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.info, "center")

	-- --
	UI.info = guiCreateLabel(20, 163, 140, 20, "Выберите вид топлива", false, UI.bg)
	guiSetFont(UI.info, UI.FONTS['INFO'])
	guiLabelSetColor(UI.info, 80, 80, 80)

	UI.info = guiCreateLabel(210, 163, 100, 20, "Цена за 1л", false, UI.bg)
	guiSetFont(UI.info, UI.FONTS['INFO'])
	guiLabelSetColor(UI.info, 80, 80, 80)

	UI.fuel_price = guiCreateLabel(0, 163, 370, 20, "", false, UI.bg)
	guiSetFont(UI.fuel_price, UI.FONTS['PROGRESSBAR'])
	guiLabelSetColor(UI.fuel_price, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.fuel_price, "right")

	UI.info = guiCreateLabel(210, 180, 100, 20, "Кол-во литров", false, UI.bg)
	guiSetFont(UI.info, UI.FONTS['INFO'])
	guiLabelSetColor(UI.info, 80, 80, 80)

	UI.fuel_amount = guiCreateLabel(0, 180, 370, 20, "", false, UI.bg)
	guiSetFont(UI.fuel_amount, UI.FONTS['PROGRESSBAR'])
	guiLabelSetColor(UI.fuel_amount, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.fuel_amount, "right")

	UI.info = guiCreateLabel(210, 197, 105, 20, "Общая стоимость", false, UI.bg)
	guiSetFont(UI.info, UI.FONTS['INFO'])
	guiLabelSetColor(UI.info, 80, 80, 80)

	UI.fuel_totalPrice = guiCreateLabel(0, 197, 370, 20, "", false, UI.bg)
	guiSetFont(UI.fuel_totalPrice, UI.FONTS['PROGRESSBAR'])
	guiLabelSetColor(UI.fuel_totalPrice, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.fuel_totalPrice, "right")

	-- --
	UI.pb_info = guiCreateLabel(0, 140, 400, 20, "", false, UI.bg)
	guiSetFont(UI.pb_info, UI.FONTS['PROGRESSBAR'])
	guiLabelSetColor(UI.pb_info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.pb_info, "center")

	UI.pb = guiProgressBar.createProgressBar(9, 115, 50, UI.bg)

	UI.rb_type1 = guiRadioButton.createRadioButton(20, 185, 'АИ-92', true, UI.bg)
	UI.rb_type2 = guiRadioButton.createRadioButton(90, 185, 'АИ-95', false, UI.bg)
	UI.rb_type3 = guiRadioButton.createRadioButton(160, 185, 'ДТ', false, UI.bg)
	-- --
	UI.btn_fill  = guiCreateStaticImage(12, 215, 375, 38, "assets/img/button_fill.png", false, UI.bg)
	UI.btn_close = guiCreateStaticImage(355, 8, 26, 25, "assets/img/button_close.png", false, UI.bg)

	UI.btn_close:setData('queenSounds.UI', 'ui_select') -- звук клика
	UI.btn_fill:setData('queenSounds.UI', 'ui_select') -- звук клика
end

function UI.updateFuelingInfo(progress)
	local veh = getPedOccupiedVehicle(localPlayer)

	if not veh then
		return --UI.setVisibleWindow(false)
	end

	local fuel_count = getElementData(veh, "queenVehicle.fuel") or 0
	local fuel_max = getElementData(veh, "queenVehicle.fuelMax") or 200

	totalsLitres = math.floor((progress*fuel_max)/100)

	local price = Config.fuelSetting[fuelType].price

	totalsPrice = math.floor(totalsLitres*price)

	guiSetText(UI.fuel_price, '$'..price)
	guiSetText(UI.fuel_totalPrice, '$'..totalsPrice)
	guiSetText(UI.fuel_amount, totalsLitres) 			-- кол-во литров
 	guiSetText(UI.pb_info, totalsLitres)	  			-- кол-во на скроле
end

function UI.setVisibleWindow(state)
	if isElement(UI.bg) and state then
		return
	end

	showCursor(state)

	if not state then
		setElementData(localPlayer, "queenPlayer.ACTIVE_UI", false)
		destroyElement(UI.bg)
		toggleAllControls(true, true, true) 
		exports.queenSounds:playSound('azs_pistolet_remove')
		return
	end

	drawFuelingWindow()
	setElementData(localPlayer, "queenPlayer.ACTIVE_UI", 'fuelingWindow')
end

addEventHandler("onClientMouseEnter", root, function()
	if not isElement(UI.bg) then
		return
	end

	if source == UI.btn_fill then
		guiStaticImageLoadImage(UI.btn_fill, "assets/img/button_fill_a.png")
	end
end)
	
addEventHandler("onClientMouseLeave", root, function()
	if not isElement(UI.bg) then
		return
	end

	if source == UI.btn_fill then
		guiStaticImageLoadImage(UI.btn_fill, "assets/img/button_fill.png")
	end
end)

addEventHandler("onClientGUIClick", root, function()
	if not isElement(UI.bg) then
		return
	end

	if source == UI.bg then
		return
	end

	if source == UI.btn_close then
		UI.setVisibleWindow(false)
	elseif source == UI.btn_fill then
		onVehicleFill()
	end

end)

--[[
addEventHandler('onClientRender', root, function()

	dxDrawRectangle(sW/2+400/2-20, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(sW/2-400/2+20, 0, 1, sH, tocolor(0, 255, 255, 255), true)

	dxDrawRectangle(sW/2-400/2+200-10, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(sW/2-400/2+200, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(sW/2-400/2+200+10, 0, 1, sH, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(0, sH/2-300/2+14, sW, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, sH/2-300/2+19, sW, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, sH/2-300/2+25, sW, 1, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(0, sH/2-300/2+38+40+10, sW, 1, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(0, sH/2-300/2+163, sW, 1, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(0, sH/2+300/2-37-20, sW, 1, tocolor(0, 255, 255, 255), true)
end)
]]
-- --

if Config.showCoeff then
	addEventHandler('onClientRender', root, function()
		local veh = getPedOccupiedVehicle(localPlayer)
		if not veh then return end

		local fuel = getElementData(veh, 'queenVehicle.fuel') or nil
		local maxFuel = getElementData(veh, 'queenVehicle.fuelMax') or nil

		dxDrawText('Показатель расхода топлива: '..fuel..'/'..maxFuel, 10, sH-20, sW, sH)
	end)
end