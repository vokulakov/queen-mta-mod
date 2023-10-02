Dashboard.UI.accountTab = {}

local accountTabItems = {
	{name = 'Имя аккаунта', 		data = 'username', 			key = 'account'	},
	{name = 'Уровень', 				data = 'user_lvl', 			key = 'user'	},
	{name = 'Очки опыта', 			data = 'user_exp', 			key = 'user'	},
	{},
	{},
	{},
	{},
	{},
	{name = 'Пол', 					data = 'user_sex', 			key = 'user'	},
	{name = 'Дата регистрации', 	data = 'register_time', 	key = 'account'	},
}

function Dashboard.showAccountTab()
	local accountData = localPlayer:getData("player.accountData")
	local userData = localPlayer:getData("player.userData")

	Dashboard.UI.accountTab.top_border = guiCreateStaticImage(25, 50+49, 651, 45, "assets/img/account_tab/top_border.png", false, Dashboard.UI.bg)

	-- НИК
	Dashboard.UI.nick = guiCreateLabel(20, -5, 400, 40, localPlayer:getName(), false, Dashboard.UI.accountTab.top_border)
	guiSetFont(Dashboard.UI.nick, Dashboard.UI.FONT['NICKNAME'])
	guiLabelSetColor(Dashboard.UI.nick, 80, 80, 80)
	guiLabelSetVerticalAlign(Dashboard.UI.nick, "center")

	Dashboard.UI.serial = guiCreateLabel(20, 0, 400, 40, 'Идентификатор аккаунта: '..accountData.user_id, false, Dashboard.UI.accountTab.top_border)
	guiSetFont(Dashboard.UI.serial, Dashboard.UI.FONT['ID'])
	guiLabelSetColor(Dashboard.UI.serial, 80, 80, 80)
	guiLabelSetVerticalAlign(Dashboard.UI.serial, "bottom")

	-- НАИГРАНО
	local playtime = localPlayer:getData('queenPlayer.playtime') or 0

	Dashboard.UI.lbl = guiCreateLabel(0, -2, 651-20, 45, math.floor(playtime/60)..' часов', false, Dashboard.UI.accountTab.top_border)
	guiSetFont(Dashboard.UI.lbl, Dashboard.UI.FONT['TIME_REG'])
	guiLabelSetColor(Dashboard.UI.lbl, 80, 80, 80)
	guiLabelSetVerticalAlign(Dashboard.UI.lbl, "center")
	guiLabelSetHorizontalAlign(Dashboard.UI.lbl, "right")

	Dashboard.UI.lbl = guiCreateLabel(0-guiLabelGetTextExtent(Dashboard.UI.lbl), -2, 651-20, 45, 'НАИГРАНО: ', false, Dashboard.UI.accountTab.top_border)
	guiSetFont(Dashboard.UI.lbl, Dashboard.UI.FONT['TIME_BOLD'])
	guiLabelSetColor(Dashboard.UI.lbl, 80, 80, 80)
	guiLabelSetVerticalAlign(Dashboard.UI.lbl, "center")
	guiLabelSetHorizontalAlign(Dashboard.UI.lbl, "right")

	-- Статистика
	Dashboard.UI.accountTab.list_border = guiCreateStaticImage(22, 50+45+49+20, 320, 230, "assets/img/account_tab/list_border.png", false, Dashboard.UI.bg)
	
	Dashboard.UI.tittle = guiCreateLabel(20, 0, 320, 30, 'Статистика персонажа', false, Dashboard.UI.accountTab.list_border)
	guiSetFont(Dashboard.UI.tittle, Dashboard.UI.FONT['STAT_TITTLE'])
	guiLabelSetColor(Dashboard.UI.tittle, 80, 80, 80)
	guiLabelSetVerticalAlign(Dashboard.UI.tittle, "center")

	for i, value in ipairs(accountTabItems) do
		if value.name then
			Dashboard.UI.tittle = guiCreateLabel(28, 25+((i-1)*20), 400, 20, value.name, false, Dashboard.UI.accountTab.list_border)
			guiSetFont(Dashboard.UI.tittle, Dashboard.UI.FONT['STAT_LBL'])
			guiLabelSetColor(Dashboard.UI.tittle, 80, 80, 80)
			guiLabelSetVerticalAlign(Dashboard.UI.tittle, "center")

			-- Информация
			local info 

			if value.key == 'account' then
				info = accountData[value.data]
				if value.data == 'register_time' then
					info = info:sub(1, #info-3)
				end
			elseif value.key == 'user' then
				info = userData[value.data]
				if info == 'male' then
					info = 'Мужской'
				elseif info == 'female' then
					info = 'Женский'
				end
			end

			Dashboard.UI.tittle = guiCreateLabel(165, 25+((i-1)*20), 400, 20, info, false, Dashboard.UI.accountTab.list_border)
			guiSetFont(Dashboard.UI.tittle, Dashboard.UI.FONT['STAT_INFO'])
			guiLabelSetColor(Dashboard.UI.tittle, 80, 80, 80)
			guiLabelSetVerticalAlign(Dashboard.UI.tittle, "center")

			if i ~= #accountTabItems then
				guiCreateStaticImage(5, 25+(i*20), 310, 1, "assets/img/account_tab/list_line.png", false, Dashboard.UI.accountTab.list_border)
			end
		end
	end

end

function Dashboard.setAccountTabVisible(isVisible)
	if not isElement(Dashboard.UI.bg) then
		return
	end

	if isVisible then
		guiStaticImageLoadImage(Dashboard.UI.btn_account, "assets/img/button_account_a.png")
		Dashboard.showAccountTab()
	else
		guiStaticImageLoadImage(Dashboard.UI.btn_account, "assets/img/button_account.png")
	end
end