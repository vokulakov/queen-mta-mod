local function playerSpawn()
	local playerData = source:getData('player.userData')

	if not playerData then
		return --outputDebugString('Не! Ну это просто GG')
	end

	local location = fromJSON(playerData.user_location)

	spawnPlayer(
		source, 

		location.x, 
		location.y, 
		location.z, 
		90, 

		playerData.user_skin, 
		playerData.user_int, 
		playerData.user_dim
	)

	triggerEvent('queenCore.setWorldTime', source)
	fadeCamera(source, true, 5)
	setCameraTarget(source, source)

	triggerClientEvent(source, "queenShowUI.setVisiblePlayerUI", source, true) -- показываем HUD
end
addEvent("queenCore.spawnPlayer", true)
addEventHandler("queenCore.spawnPlayer", root, playerSpawn)
