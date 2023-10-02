sx, sy = guiGetScreenSize()
UI = { login = {} }

UI_FONTS = {
	['LOGIN_B_12'] = exports["queenFonts"]:createFontGUI("GothaProBol.otf", 12),
	['LOGIN_B_9'] = exports["queenFonts"]:createFontGUI("GothaProBol.otf", 9),

	['LOGIN_R_9'] = exports["queenFonts"]:createFontGUI("GothaProReg.otf", 9),
	['LOGIN_R_8'] = exports["queenFonts"]:createFontGUI("GothaProReg.otf", 8),

	['LOGIN_M_9'] = exports["queenFonts"]:createFontGUI("GothaProMed.otf", 9),
}

--[[
addEventHandler('onClientRender', root, function()
	dxDrawRectangle(0, sy/2-240/2-1/2, sx, 1, tocolor(0, 255, 255, 255), true)


	dxDrawRectangle(0, sy/2-160/2-1/2, sx, 1, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(sx/2-300/2-1/2+20, 0, 1, sy, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(sx/2-300/2-1/2+280, 0, 1, sy, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(0, sy/2+82-1/2, sx, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, sy/2+95-1/2, sx, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(0, sy/2+108-1/2, sx, 1, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(sx/2-300/2-1/2, 0, 1, sy, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(sx/2-300/2-1/2+262, 0, 1, sy, tocolor(0, 255, 255, 255), true)
	
	--dxDrawRectangle(sx/2-300/2-1/2-180, 0, 1, sy, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(sx/2-300/2-1/2+40, 0, 1, sy, tocolor(0, 255, 255, 255), true)
end)
--]]

function drawLoginWindow()
	UI.login.bg = guiCreateStaticImage(sx/2-300/2, sy/2-240/2, 300, 240, "assets/img/background.png", false)

	UI.login.tittle = guiCreateLabel(20, 0, 300, 40, "АВТОРИЗАЦИЯ", false, UI.login.bg)
	guiSetFont(UI.login.tittle, UI_FONTS['LOGIN_B_12'])
	guiLabelSetColor(UI.login.tittle, 80, 80, 80)
    guiLabelSetVerticalAlign(UI.login.tittle, "center")

	UI.login.info = guiCreateLabel(20, 50, 300, 20, "Добро пожаловать на сервер", false, UI.login.bg)
	guiSetFont(UI.login.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.login.info, 80, 80, 80)

	UI.login.info = guiCreateLabel(207, 50, 100, 20, "Queen MTA!", false, UI.login.bg)
	guiSetFont(UI.login.info, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.login.info, 80, 80, 80)
	
	UI.login.info = guiCreateLabel(0, 65, 300, 20, "Пожалуйста, авторизируйтесь.", false, UI.login.bg)
	guiSetFont(UI.login.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.login.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.login.info, "center", false)


	UI.login.edit_login = createEditBox(40, 90, "Логин", UI.login.bg)
	UI.login.edit_pass = createEditBox(40, 125, "Пароль", UI.login.bg, true)
	UI.login.edit_login:setData('queenSounds.UI', 'ui_change') -- звук клика
	UI.login.edit_pass:setData('queenSounds.UI', 'ui_change') -- звук клика
	
	UI.login.check_save = createCheckBox(160, 152, "Запомнить", UI.login.bg, false)
	UI.login.check_save:setData('queenSounds.UI', 'ui_change') -- звук клика
	-- Кнопка авторизации
	UI.login.b_login = guiCreateStaticImage(35, 170, 229, 31, "assets/img/button_login.png", false, UI.login.bg)
	UI.login.b_login:setData('queenSounds.UI', 'ui_select') -- звук клика
	UI.login.info = guiCreateLabel(0, 201, 300, 20, "или", false, UI.login.bg)
	guiSetFont(UI.login.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.login.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.login.info, "center", false)

	-- Кнопка регистрации
	UI.login.b_reg = guiCreateLabel(104, 216, 100, 20, "РЕГИСТРАЦИЯ", false, UI.login.bg)
	UI.login.b_reg:setData('queenSounds.UI', 'ui_select') -- звук клика
	guiSetFont(UI.login.b_reg, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.login.b_reg, 80, 80, 80)

end

addEventHandler("onClientMouseEnter", root, function()
	if not UI.login.bg then
		return
	end

	if not guiGetVisible(UI.login.bg) then
		return
	end

	if source ~= UI.login.b_reg then 
		return 
	end
	guiLabelSetColor(UI.login.b_reg, 255, 168, 0)
end)

addEventHandler("onClientMouseLeave", root, function()
	if not UI.login.bg then
		return
	end

	if not guiGetVisible(UI.login.bg) then
		return
	end

	if source ~= UI.login.b_reg then 
		return 
	end

	guiLabelSetColor(UI.login.b_reg, 80, 80, 80)
end)

function destroyLoginWindow()
	if not UI.login.bg then
		return
	end

	destroyElement(UI.login.bg)
	UI.login = {}
end