--[[
	* Проверка логина игрока, который пригласил
	** В будующем сделать, чтобы в editBox можно было вставить текст из буфера
--]]


local function startLoginUI()
	drawLoginWindow()

	local fields = Autologin.load()
	if fields then
		setEditBoxText(UI.login.edit_login, fields.username)
		setEditBoxText(UI.login.edit_pass, fields.password)
		setCheckBoxState(UI.login.check_save, true)
	end

   	toggleAllControls(true, true, true) 
	toggleControl("radar", false) -- отключение стандартной карты

	showCursor(true)
end
addEvent('queenLogin.startLoginUI', true)
addEventHandler('queenLogin.startLoginUI', root, startLoginUI)

--startLoginUI()

local function stopLoginUI()
	fadeCamera(false, 2) 

	setTimer(function() 
		triggerEvent('queenLoadingScreen.stopCamera', localPlayer) -- отключаем камеру
		triggerEvent('queenShaders.blurShaderStop', localPlayer)   -- отключаем размытие
	end, 2000, 1)

	destroyLoginWindow()
	showCursor(false)

	setTimer(triggerEvent, 2200, 1, 'queenLoadingScreen.stopSound', localPlayer)
end
addEvent('queenLogin.stopLoginUI', true)
addEventHandler('queenLogin.stopLoginUI', root, stopLoginUI)

addEventHandler('onClientGUIClick', root, function(button)
	if not button == 'left' then 
		return 
	end

	if source == UI.login.b_reg then -- ОКНО РЕГИСТРАЦИИ
		destroyLoginWindow()

		drawRegistrationWindow()
	elseif source == UI.reg.b_back then -- ВЕРНУТЬСЯ НА ОКНО АВТОРИЗАЦИИ
		destroyRegistrationWindow()

		drawLoginWindow()
	end

	-- АВТОРИЗАЦИЯ --
	if source == UI.login.b_login then
		local loginStr, _loginEdit = getEditBoxText(UI.login.edit_login)
		local passStr, _passEdit = getEditBoxText(UI.login.edit_pass)

		if loginStr == "" or loginStr == _loginEdit or passStr == "" or passStr == _passEdit then
			return showWarningBox("Для авторизации введите логин и пароль.")
		end
		
		Autologin.remember(tostring(loginStr), tostring(passStr))

		triggerServerEvent('queenCore.onRequestLogin', localPlayer, tostring(loginStr), tostring(passStr), getCheckBoxState(UI.login.check_save))
	end

	-- РЕГИСТРАЦИЯ --
	if source == UI.reg.b_reg then
		local loginStr, _loginEdit = getEditBoxText(UI.reg.edit_login)
		local passStr, _passEdit = getEditBoxText(UI.reg.edit_pass)
		local emailStr, _emailStr = getEditBoxText(UI.reg.edit_email)

		if loginStr == "" or loginStr == _loginEdit or passStr == "" or passStr == _passEdit then
			return showWarningBox("Для регистрации заполните все поля.")
		end

		local loginStrLen = getEditBoxTextLen(UI.reg.edit_login)
		local passStrLen = getEditBoxTextLen(UI.reg.edit_pass)

		if (loginStrLen > 2 and loginStrLen < 11) then
			if not string.find(loginStr, "^%w+$") then
				return showWarningBox("Введены недопустимые символы (A-Z, 0-9)")
			end
		else
			return showWarningBox("Мин. коли-во символов логина - 2, макс. 10")
		end

		if (passStrLen < 6) then
			return showWarningBox("Мин. коли-во символов пароля - 6")
		end

		if not string.find(emailStr, "^%w+@%w+.%w+$") then
			return showWarningBox("Проверьте правильность данных эл. почты")
		end

		triggerServerEvent('queenCore.onRequestRegister', localPlayer, tostring(loginStr), tostring(passStr), tostring(emailStr))
	end

	-- СОЗДАНИЕ ПЕРСОНАЖА --
	if source == UI.succes_reg.b_next then
		destroySuccesRegistrationWindow()
		startCreateCharacter()
	end

	-- НАЧАТЬ ИГРУ --
	if source == UI.character.button_start then
		local playerData = {
			sex  = Character.sex,
			skin = Character.model,

			city = {
				x    = Character.city[Character.city_index].x,
				y	 = Character.city[Character.city_index].y,
				z    = Character.city[Character.city_index].z
			}

		}

		triggerServerEvent('queenCore.onCreateCharacter', localPlayer, playerData)

		destroyCharacterWindow()

		stopLoginUI()

		setTimer(triggerServerEvent, 3000, 1, 'queenCore.spawnPlayer', localPlayer)
	end
end)

addEvent('queenLogin.successRegistration', true)
addEventHandler('queenLogin.successRegistration', root, function(username, password, email)
	destroyRegistrationWindow()
	drawSuccesRegistrationWindow(username, password, email)
end)
