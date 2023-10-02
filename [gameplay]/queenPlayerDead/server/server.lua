local function getHospitalForPlayer(player)
	if not player then return end
	local playerHospital = { }

	local xPlayer, yPlayer, zPlayer = getElementPosition(player)
	for i, hospital in ipairs(Config.hospitalPosition) do
		local distance = getDistanceBetweenPoints3D (hospital.x, hospital.y, hospital.z, xPlayer, yPlayer, zPlayer)
		playerHospital[i] = {}
		playerHospital[i].num = i
		playerHospital[i].dis = distance
	end

	local hospitalPosition = Config.hospitalPosition
	local n = #hospitalPosition
	for i = 1, n - 1 do
		for j = 1, n - i do
			if playerHospital[j].dis > playerHospital[j+1].dis then
				local nH, dH = playerHospital[j].num, playerHospital[j].dis
				playerHospital[j].num = playerHospital[j+1].num
				playerHospital[j].dis = playerHospital[j+1].dis
				playerHospital[j+1].num = nH
				playerHospital[j+1].dis = dH
			end
		end
	end

	return hospitalPosition[playerHospital[1].num].x, hospitalPosition[playerHospital[1].num].y, hospitalPosition[playerHospital[1].num].z
end

addEventHandler("onPlayerWasted", root, function()
	triggerClientEvent(source, "queenPlayerDead.showDeadScreen", source, true)

	setTimer(fadeCamera, 1500, 1, source, false)

	setTimer(
		function(player)
			triggerClientEvent(player, "queenPlayerDead.showDeadScreen", player, false)
			triggerClientEvent(player, 'queenPlayerDead.onStartCoffinDance', player)
		end, 
	2500, 1, source)

end)

addEvent("queenPlayerDead.onStopCoffinDance", true)
addEventHandler("queenPlayerDead.onStopCoffinDance", root, function()
	local player = source

	local x, y, z = getHospitalForPlayer(player)
			
	spawnPlayer(player, x, y, z, 
		getElementRotation(player), 
		getPedSkin(player), 
		getElementInterior(player), 
		getElementDimension(player)
	)

	fadeCamera(player, true)
	setCameraTarget(player, player)
	-- Необходимо добавить списание денег за лечение

end)
--[[
addCommandHandler('kill', function(player, cmd)
	setElementHealth(player, 0)
end)

addCommandHandler('spawn', function(player, cmd)
	triggerEvent('queenPlayerDead.onStopCoffinDance', player)
end)
]]