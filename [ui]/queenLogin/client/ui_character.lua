UI.character = { }

Character = {}

function drawCharacterWindow()
	UI.character.bg = guiCreateStaticImage(30, sy/2-240/2, 300, 240, "assets/img/char_background.png", false)

	UI.character.tittle = guiCreateLabel(20, 0, 300, 40, "СОЗДАНИЕ ПЕРСОНАЖА", false, UI.character.bg)
	guiSetFont(UI.character.tittle, UI_FONTS['LOGIN_B_12'])
	guiLabelSetColor(UI.character.tittle, 80, 80, 80)
    guiLabelSetVerticalAlign(UI.character.tittle, "center")

    UI.character.info = guiCreateLabel(0, 50, 300, 20, "Для начала игры, создайте себе персонажа.", false, UI.character.bg)
	guiSetFont(UI.character.info, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(UI.character.info, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.character.info, "center", false)

	-- Выбор пола
	UI.character.button_sex = guiCreateStaticImage(38.5, 70, 226, 32, "assets/img/button_male.png", false, UI.character.bg)
	UI.character.button_sex:setData('queenSounds.UI', 'ui_change') -- звук клика
	-- Выбор города
	UI.character.info = guiCreateLabel(38.5, 120, 100, 20, "Выбор города", false, UI.character.bg)
	guiSetFont(UI.character.info, UI_FONTS['LOGIN_M_9'])
	guiLabelSetColor(UI.character.info, 80, 80, 80)

	UI.character.b_city_prev = guiCreateLabel(147, 120, 10, 20, "<", false, UI.character.bg)
	UI.character.b_city_prev:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiSetFont(UI.character.b_city_prev, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.character.b_city_prev, 80, 80, 80)

	UI.character.labelCity = guiCreateLabel(153, 120, 100, 20, Character.city[Character.city_index].name, false, UI.character.bg)
	guiSetFont(UI.character.labelCity, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.character.labelCity, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.character.labelCity, "center", false)

	UI.character.b_city_next = guiCreateLabel(251.5, 120, 10, 20, ">", false, UI.character.bg)
	UI.character.b_city_next:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiSetFont(UI.character.b_city_next, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.character.b_city_next, 80, 80, 80)

	-- Выбор скина
	UI.character.info = guiCreateLabel(38.5, 140, 100, 20, "Выбор скина", false, UI.character.bg)
	guiSetFont(UI.character.info, UI_FONTS['LOGIN_M_9'])
	guiLabelSetColor(UI.character.info, 80, 80, 80)

	UI.character.b_skin_prev = guiCreateLabel(222, 140, 10, 20, "<", false, UI.character.bg)
	UI.character.b_skin_prev:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiSetFont(UI.character.b_skin_prev, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.character.b_skin_prev, 80, 80, 80)

	UI.character.labelSkin = guiCreateLabel(234.5, 140, 10, 20, Character.index, false, UI.character.bg)
	guiSetFont(UI.character.labelSkin, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.character.labelSkin, 80, 80, 80)
	guiLabelSetHorizontalAlign(UI.character.labelSkin, "center", false)

	UI.character.b_skin_next = guiCreateLabel(251, 140, 10, 20, ">", false, UI.character.bg)
	UI.character.b_skin_next:setData('queenSounds.UI', 'ui_change') -- звук клика
	guiSetFont(UI.character.b_skin_next, UI_FONTS['LOGIN_B_9'])
	guiLabelSetColor(UI.character.b_skin_next, 80, 80, 80)
	--
	UI.character.edit_login = createEditBox(38.5, 165, "Логин игрока, пригласившего вас", UI.character.bg)
	
	--
	UI.character.button_start = guiCreateStaticImage(38.5, 200, 225, 28, "assets/img/start_game.png", false, UI.character.bg)
	UI.character.button_start:setData('queenSounds.UI', 'ui_select') -- звук клика
end

addEventHandler("onClientMouseEnter", root, function()
	if not UI.character.bg then
		return
	end

	if not guiGetVisible(UI.character.bg) then
		return
	end

	if source ~= UI.character.b_skin_next and source ~= UI.character.b_skin_prev and source ~= UI.character.b_city_next and source ~= UI.character.b_city_prev then
		return 
	end

	guiLabelSetColor(source, 255, 168, 0)
end)
	
addEventHandler("onClientMouseLeave", root, function()
	if not UI.character.bg then
		return
	end

	if not guiGetVisible(UI.character.bg) then
		return
	end

	if source ~= UI.character.b_skin_next and source ~= UI.character.b_skin_prev and source ~= UI.character.b_city_next and source ~= UI.character.b_city_prev then
		return 
	end

	guiLabelSetColor(source, 80, 80, 80)
end)

local function showCharacter()

	Character.ped = createPed(Character.model, 1680, 1753, 10.8, -90)
	setElementDimension(Character.ped, getElementDimension(localPlayer))

	setPedAnimation(Character.ped, "ped", "endchat_03", -1, true, false, false)
	Character.animTimer = setTimer(setPedAnimation, 2300, 1, Character.ped, false)
end

function destroyCharacterWindow()
	fadeCamera(false, 2) 

	destroyElement(Character.ped)
	if isTimer(Character.animTimer) then killTimer(Character.animTimer) end 
	destroyElement(UI.character.bg)

	UI.character = {}
	Character = {}
end

local function updateCharacter(model)
	setElementModel(Character.ped, model)
	setPedAnimation(Character.ped, "ped", "endchat_03", -1, true, false, true)

	if isTimer(Character.animTimer) then
		killTimer(Character.animTimer)
	end

	Character.animTimer = setTimer(setPedAnimation, 2300, 1, Character.ped, false)

	guiSetText(UI.character.labelSkin, Character.index)
	Character.model = model
end

addEventHandler('onClientGUIClick', root, function(button)
	if not button == 'left' then 
		return 
	end

	if not UI.character.bg then
		return
	end

	if not guiGetVisible(UI.character.bg) then
		return
	end

	if source == UI.character.button_sex then -- смена пола
		if Character.sex == 'female' then
			Character.sex = 'male'
		else
			Character.sex = 'female'
		end

		guiStaticImageLoadImage(source, "assets/img/button_"..Character.sex..".png")

		Character.index = 1
		updateCharacter(Character.list[Character.sex][Character.index])

		return
	end

	if source == UI.character.b_skin_prev or source == UI.character.b_skin_next then -- смена скина
		local currentIndex = tonumber(Character.index)
		local maxIndex = tonumber(#Character.list[Character.sex])

		if source == UI.character.b_skin_next then -- следующий
			if currentIndex < maxIndex then
				Character.index = Character.index + 1
			else
				Character.index = 1
			end
		else 									   -- предыдущий
			if currentIndex > 1 then
				Character.index = Character.index - 1
			else
				Character.index = maxIndex
			end
		end

		updateCharacter(Character.list[Character.sex][Character.index])

		return
	end
	
	if source == UI.character.b_city_next or source == UI.character.b_city_prev then -- смена города
		local currentIndex = tonumber(Character.city_index)
		local maxIndex = tonumber(#Character.city)

		if source == UI.character.b_city_next then -- следующий
			if currentIndex < maxIndex then
				Character.city_index = Character.city_index + 1
			else
				Character.city_index = 1
			end
		else 									   -- предыдущий
			if currentIndex > 1 then
				Character.city_index = Character.city_index - 1
			else
				Character.city_index = maxIndex
			end
		end

		guiSetText(UI.character.labelCity, Character.city[Character.city_index].name)

		return
	end
end)

function startCreateCharacter(isLogin) 
	Character.list = exports.queenShared.getCharacterSkins() 	-- список скинов
	Character.ped = nil						                 	-- ped
	Character.sex = 'male'									 	-- пол
	Character.index = 1                                         -- индекс персонажа
	Character.model = Character.list['male'][Character.index]

	Character.city = exports.queenShared.getSpawnCity()			-- список городов
	Character.city_index = 1	

	fadeCamera(false, 2) 

	setTimer(function() 
		triggerEvent('queenLoadingScreen.stopCamera', localPlayer) -- отключаем камеру
		triggerEvent('queenShaders.blurShaderStop', localPlayer)   -- отключаем размытие
	end, 2000, 1)

	setTimer(function()  
		fadeCamera(true, 2)
		setCameraMatrix(1683, 1752.5, 12, 0, 1750, -600, 0, 0)
		showCharacter()
	end, 2200, 1)

	if isLogin then -- если создаем после авторизации
		destroyLoginWindow()
		showCursor(true)
	end

	setTimer(drawCharacterWindow, 2400, 1)
end
addEvent('queenLogin.startCreateCharacter', true)
addEventHandler('queenLogin.startCreateCharacter', root, startCreateCharacter)