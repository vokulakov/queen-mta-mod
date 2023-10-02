local function _login(player, account, username, password)
	local res = logIn(player, account, tostring(password))

	if not res then
		triggerClientEvent(player, "queenLogin.isWarning", player, 'Не удалось авторизоваться.')
		return false
	end

	-- Загрузка данных
	Users.loadAccount(player)

	-- Обновить данные об аккаунте
	Accounts.updateLastseen(player, username, 1)
	exports.queenLogger.log("", "queen_auth", string.format("User login: '%s'", username))

	return true
end

local function loginPlayer(username, password, isSave)
	local account = getAccount(username, password)
	if account == false then
		return triggerClientEvent(source, 'queenLogin.isWarning', source, 'Вы ввели неверный логин или пароль.')
	end

	if not _login(source, account, username, password) then
		return
	end

	if not source:getData('player.userData') then -- Проверить, создан ли персонаж?
		triggerClientEvent(source, 'queenLogin.startCreateCharacter', source, true)
		return
	end

	if isSave then
		triggerClientEvent(source, 'queenLogin.autologinRemember', source, username, password)
	else
		triggerClientEvent(source, 'queenLogin.autologinDelete', source)
	end

	triggerClientEvent(source, 'queenLogin.stopLoginUI', source)

	setTimer(triggerEvent, 3000, 1, 'queenCore.spawnPlayer', source)
end
addEvent('queenCore.onRequestLogin', true)
addEventHandler('queenCore.onRequestLogin', root, loginPlayer)

local function onPlayerRegistration(username, password, email)
	local account = getAccount(username, password)

	if account then
		return triggerClientEvent(source, 'queenLogin.isWarning', source, 'Введенный логин уже зарегистрирован.')
	end

	if not getEmailFromAllAccounts(email) then
		return triggerClientEvent(source, 'queenLogin.isWarning', source, 'Введенная эл. почта уже используется.') 
	end

	local accountID = #getAccounts() + 1
	local accountAdded = addAccount(tostring(username), tostring(password))

	if not accountAdded then
		return triggerClientEvent(source, 'queenLogin.isWarning', source, 'Попробуйте ввести другие данные.') 
	end


	Accounts.addAccount(source, username, email)
	exports.queenLogger.log("", "queen_auth", string.format("New user registered: '%s'", username))

	if not _login(source, accountAdded, username, password) then
		return
	end

	triggerClientEvent(source, 'queenLogin.successRegistration', source, username, password, email)
end
addEvent('queenCore.onRequestRegister', true)
addEventHandler('queenCore.onRequestRegister', root, onPlayerRegistration)

-- ВАЛИДНОСТЬ ЭЛ. ПОЧТЫ --

function getEmailFromAllAccounts(email) -- проверка по БД
	local db = Database.getConnection()
	if not db then return end

	local accountTable = dbPoll(dbQuery(db, "SELECT email FROM accounts"), -1)

	for _, v in ipairs(accountTable) do
		if tostring(v.email) == email then 
			return false 
		end
	end

	return true
end

--[[
local function myCallback(responseData, error, playerToReceive)
	if error == 0 then
		local result = fromJSON(responseData)
		outputDebugString(responseData)
		if result['format_valid'] == 'Email валидный' then
			outputDebugString(responseData)
		end
	end
end

function emailVerification(email)
	fetchRemote("https://htmlweb.ru/json/service/email?email="..tostring(email), myCallback)
end
addEvent('queenCore.emailVerification', true)
addEventHandler('queenCore.emailVerification', root, emailVerification)
]]