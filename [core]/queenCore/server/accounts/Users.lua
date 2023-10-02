local function onCreateCharacter(characterData)
	local player = source

	local playerData = Accounts.getData(player)

	Users.addUser(player, playerData.user_id, playerData.username, characterData)

	Users.loadAccount(player)
end
addEvent('queenCore.onCreateCharacter', true)
addEventHandler('queenCore.onCreateCharacter', root, onCreateCharacter)


-- СОХРАНЕНИЕ

-- Время автосохранения в минутах
local AUTOSAVE_INTERVAL = 7

function Users.loadAccount(player) -- загрузка данных аккаунта
    if not isElement(player) then
        return false
    end

    local accountData = Accounts.getData(player)

    if not accountData then
        return false
    end

    local userData = Users.getUserData(accountData['user_id'])

    if not userData then
        return false
    end

    if not accountData.playtime then accountData.playtime = 0 end

    player:setData('queenPlayer.playtime', accountData.playtime)

    setPlayerMoney(player, userData.user_money)
    setElementModel(player, userData.user_skin)
    setElementHealth(player, userData.user_hp)

    -- Данные аккаунта
    player:setData('player.accountData', accountData)

    -- Данные игрока
    player:setData('player.userData', userData)

    exports.queenHunger:setPlayerHungerData(player)

    return true
end

function Users.saveAccount(player) -- сохранение данных аккаунта
	if not isElement(player) then
        return false
    end

    local accountData = player:getData("player.accountData")

    if not accountData then
        return
    end

    local userDATA = player:getData("player.userData")

    -- Обновление наигранного времени
    if not accountData.playtime then accountData.playtime = 0 end

    player:setData('queenPlayer.playtime', accountData.playtime)

    local db = Database.getConnection()

    dbExec(db, "UPDATE "..ACCOUNTS_TABLE_NAME.." SET playtime = ? WHERE username = ?", 
    	tonumber(player:getData("queenPlayer.playtime")), 
    	accountData.username
    ) 

    -- Обновление данных игрока
    local fields = {
        user_money = getPlayerMoney(player),
        user_donate = userDATA.user_donate,

        user_hp = getElementHealth(player),
        user_eat = userDATA.user_eat,

        user_lvl = userDATA.user_lvl,
        user_exp = userDATA.user_exp,

        user_location = toJSON({x = player.position.x, y = player.position.y, z = player.position.z}),
        user_dim = getElementDimension(player),
        user_int = getElementInterior(player),

        user_skin = getElementModel(player),
    }


    dbExec(db, "UPDATE `"..USERS_TABLE_NAME.."` SET user_money = ?, user_donate = ?, user_hp = ?, user_eat = ?, user_lvl = ?, user_exp = ?, user_location = ?, user_dim = ?, user_int = ?, user_skin = ? WHERE user_id = ?", 
        fields.user_money,
        fields.user_donate,
        fields.user_hp,
        fields.user_eat,
        fields.user_lvl,
        fields.user_exp,
        fields.user_location,
        fields.user_dim,
        fields.user_int,
        fields.user_skin,
        tostring(accountData.user_id)
    )

    return 
end

addCommandHandler('save', function(player, cmd)
    --outputDebugString()
    Users.saveAccount(player)
end)

addEventHandler("onPlayerQuit", root, function() -- игрок выходит с сервера
	local account = getPlayerAccount(source)
	if (account) then

        if not source:getData("player.accountData") then
            return
        end
        
		local username = source:getData("player.accountData").username

		Accounts.updateLastseen(source, username, 0)

    	exports.queenLogger:log("auth", string.format("User '%s' has logged out (%s)", username, tostring(source.name)))
		
		Users.saveAccount(source)
	end
end)

addEventHandler("onPlayerChangeNick", root, function(oldNick, newNick, changedByPlayer) -- смена ника
	if not changedByPlayer then
		return
	end
	exports.queenLogger:log("nicknames", ("Player %s changed nickname to %s"):format(tostring(oldNick), tostring(newNick)), true)
end)

setTimer(function()
	for i, player in ipairs(getElementsByType("player")) do
		local currentPlaytime = tonumber(player:getData("queenPlayer.playtime"))

		if currentPlaytime then
			player:setData("queenPlayer.playtime", currentPlaytime + 1)
		end
	end
end, 60000, 0)

setTimer(function ()
    for i, player in ipairs(getElementsByType("player")) do
        Users.saveAccount(player)
    end

    exports.queenLogger:log("auth", "Autosave completed")
end, AUTOSAVE_INTERVAL * 60 * 1000, 0)