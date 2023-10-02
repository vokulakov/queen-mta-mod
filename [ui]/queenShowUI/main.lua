local UI = {
	['all'] = true, -- весь HUD
	['radar'] = true, -- радар
	['hud'] = true, -- статистика игрока
	['speed'] = true, -- спидометр
	['map'] = true, -- карта
	['scoreboard'] = true, -- список игроков
	['chat'] = true, -- чат


	['dashboard'] = true, -- панель игрока
	
	['notify'] = true, -- уведомления
	['control'] = true, -- управление
	
	['nicknames'] = true -- ники игроков
}


local function setVisiblePlayerUI(state)

	for component in pairs(UI) do 
		UI[component] = state 
	end

	setElementData(source, 'queenPlayer.UI', UI)
end
addEvent("queenShowUI.setVisiblePlayerUI", true)
addEventHandler("queenShowUI.setVisiblePlayerUI", root, setVisiblePlayerUI)


local function setVisiblePlayerComponentUI(theComponent, state)
	for component in pairs(UI) do 
		if component == theComponent then
			UI[component] = state 
		end
		setElementData(source, 'queenPlayer.UI', UI)
	end
end
addEvent("queenShowUI.setVisiblePlayerComponentUI", true)
addEventHandler("queenShowUI.setVisiblePlayerComponentUI", root, setVisiblePlayerComponentUI)


addEventHandler("onClientResourceStart", resourceRoot, function()
	setVisiblePlayerUI(false) -- --

	setElementData(localPlayer, "queenPlayer.ACTIVE_UI", false) -- Active
	toggleControl("radar", false) -- отключение стандартной карты
end)
