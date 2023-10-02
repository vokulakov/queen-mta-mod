UI.succes_reg = { }

function drawSuccesRegistrationWindow(username, password, email)

	UI.succes_reg.bg = guiCreateStaticImage(sx/2-300/2, sy/2-240/2, 300, 240, "assets/img/success_register.png", false)

	UI.succes_reg.tittle = guiCreateLabel(20, 0, 300, 40, "УСПЕШНАЯ РЕГИСТРАЦИЯ", false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.tittle, UI_FONTS['LOGIN_B_12'])
	guiLabelSetColor(UI.succes_reg.tittle, 80, 80, 80)
    guiLabelSetVerticalAlign(UI.succes_reg.tittle, "center")

    UI.succes_reg.info = guiCreateLabel(0, 50, 300, 20, "Поздравляем вас с успешной регистрацией", false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.succes_reg.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.succes_reg.info, "center", false)

	UI.succes_reg.info = guiCreateLabel(56.2, 65, 120, 20, "на нашем сервере", false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.succes_reg.info, 80, 80, 80)

	UI.login.info = guiCreateLabel(172.5, 65, 100, 20, "Queen MTA!", false, UI.succes_reg.bg)
	guiSetFont(UI.login.info, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.login.info, 80, 80, 80)

	-- Логин
	UI.succes_reg.info = guiCreateLabel(40, 97, 40, 20, "Логин: ", false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.succes_reg.info, 80, 80, 80)

	UI.succes_reg.labelLogin = guiCreateLabel(84.5, 97, 175, 20, username, false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.labelLogin, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.succes_reg.labelLogin, 80, 80, 80)

	-- Пароль
	UI.succes_reg.info = guiCreateLabel(40, 117, 50, 20, "Пароль:", false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.succes_reg.info, 80, 80, 80)

	UI.succes_reg.labelPass = guiCreateLabel(91.5, 117, 165, 20, password, false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.labelPass, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.succes_reg.labelPass, 80, 80, 80)
	-- Эл. почта
	UI.succes_reg.info = guiCreateLabel(40, 137, 70, 20, "Эл. почта:", false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.succes_reg.info, 80, 80, 80)

	UI.succes_reg.labelEmail = guiCreateLabel(105.2, 137, 157, 20, email, false, UI.succes_reg.bg)
	guiSetFont(UI.succes_reg.labelEmail, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.succes_reg.labelEmail, 80, 80, 80)

	UI.succes_reg.b_next = guiCreateStaticImage(35, 165, 228, 31, "assets/img/button_next.png", false, UI.succes_reg.bg)
	UI.succes_reg.b_next:setData('queenSounds.UI', 'ui_select') -- звук клика
end

function destroySuccesRegistrationWindow()
	if not UI.succes_reg.bg then
		return
	end

	destroyElement(UI.succes_reg.bg)
	UI.succes_reg = {}
end