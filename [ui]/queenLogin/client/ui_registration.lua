UI.reg = { }

function drawRegistrationWindow()
	UI.reg.bg = guiCreateStaticImage(sx/2-300/2, sy/2-240/2, 300, 240, "assets/img/background.png", false)

	UI.reg.tittle = guiCreateLabel(20, 0, 300, 40, "РЕГИСТРАЦИЯ", false, UI.reg.bg)
	guiSetFont(UI.reg.tittle, UI_FONTS['LOGIN_B_12'])
	guiLabelSetColor(UI.reg.tittle, 80, 80, 80)
    guiLabelSetVerticalAlign(UI.reg.tittle, "center")

	UI.reg.info = guiCreateLabel(20, 50, 300, 20, "Добро пожаловать на сервер", false, UI.reg.bg)
	guiSetFont(UI.reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.reg.info, 80, 80, 80)
	--guiLabelSetHorizontalAlign(UI.login.info, "center", false)

	UI.reg.info = guiCreateLabel(207, 50, 100, 20, "Queen MTA!", false, UI.reg.bg)
	guiSetFont(UI.reg.info, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.reg.info, 80, 80, 80)
	
	UI.reg.info = guiCreateLabel(0, 65, 300, 20, "Пожалуйста, зарегистрируйте аккаунт.", false, UI.reg.bg)
	guiSetFont(UI.reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.reg.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.reg.info, "center", false)

	-- Данные пользователя
	UI.reg.edit_login = createEditBox(40, 90, "Придумайте логин", UI.reg.bg)
	UI.reg.edit_pass = createEditBox(40, 125, "Придумайте пароль", UI.reg.bg)
	UI.reg.edit_email = createEditBox(40, 160, "Ваша эл.почта", UI.reg.bg)
	UI.reg.edit_login:setData('queenSounds.UI', 'ui_change') -- звук клика
	UI.reg.edit_pass:setData('queenSounds.UI', 'ui_change') -- звук клика
	UI.reg.edit_email:setData('queenSounds.UI', 'ui_change') -- звук клика
	
	UI.reg.b_reg = guiCreateStaticImage(35, 200, 149, 31, "assets/img/button_reg.png", false, UI.reg.bg)
	UI.reg.b_reg:setData('queenSounds.UI', 'ui_select') -- звук клика
	UI.reg.info = guiCreateLabel(173, 207.2, 50, 20, "или", false, UI.reg.bg)
	guiSetFont(UI.reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.reg.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.reg.info, "center", false)

	-- Назад
	UI.reg.b_back = guiCreateLabel(216, 207.8, 50, 20, "НАЗАД", false, UI.reg.bg)
	UI.reg.b_back:setData('queenSounds.UI', 'ui_back') -- звук клика
	guiSetFont(UI.reg.b_back, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.reg.b_back, 80, 80, 80)
end

addEventHandler("onClientMouseEnter", root, function()
	if not UI.reg.bg then
		return
	end

	if not guiGetVisible(UI.reg.bg) then
		return
	end

	if source ~= UI.reg.b_back then 
		return 
	end
	guiLabelSetColor(UI.reg.b_back, 255, 168, 0)
end)

addEventHandler("onClientMouseLeave", root, function()
	if not UI.reg.bg then
		return
	end

	if not guiGetVisible(UI.reg.bg) then
		return
	end
	
	if source ~= UI.reg.b_back then 
		return 
	end

	guiLabelSetColor(UI.reg.b_back, 80, 80, 80)
end)

function destroyRegistrationWindow()
	if not UI.reg.bg then
		return
	end

	destroyElement(UI.reg.bg)
	UI.reg = {}
end