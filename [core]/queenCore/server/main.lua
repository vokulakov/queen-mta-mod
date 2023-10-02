addEventHandler("onResourceStart", resourceRoot, function()
	if not Database.connect() then -- подключаем Базу Данных (SQL)
		outputDebugString("ERROR: Database connection failed")
		return
	end

	outputDebugString("Database connection success")
	outputDebugString("Creating and setting up tables...")

	Accounts.setup()
	Users.setup()


	setElementData(root, 'queenServerMaxPlayers', getMaxPlayers())
end)

addEventHandler("onResourceStop", resourceRoot, function()

	-- Сохранение данных в момент выключения мода
	for i, player in ipairs(getElementsByType("player")) do
        Users.saveAccount(player)
    end

    Database.disconnect()
end)