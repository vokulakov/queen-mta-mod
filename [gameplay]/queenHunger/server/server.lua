local time_hung = 92000 -- время через которое снимает голод (в мс)
local take_hp = 3 		-- сколько снимать hp

local THE_TIMERS = { }

local Hunger = {}

function Hunger.takePlayerHunger(player)
	if not player then return end
	
	local userData = player:getData("player.userData")

	if tonumber(userData.user_eat) <= 0 then
		setElementHealth(player, getElementHealth(player) - take_hp)

		setPedAnimation(player, "ped", "gas_cwr", -1, false, false, false, false)
		triggerClientEvent(player, 'queenHunger.warning', player)
	else
		userData.user_eat = userData.user_eat - 1
		player:setData("player.userData", userData)
	end
	
end

function Hunger.setPlayerHungerData(player)
	if not player then 
		return 
	end

	local userData = player:getData("player.userData")
	if not userData.user_eat then
		userData.user_eat = 100
		player:setData('player.userData', userData)
	end
	--setElementData(player, 'queenPlayer.hungerLevel', tonumber(getElementData(player, 'queenPlayer.hungerLevel')) or 100)

	if not isTimer(THE_TIMERS[source]) then
		THE_TIMERS[player] = setTimer(Hunger.takePlayerHunger, time_hung, 0, player)
	end
	
end

setPlayerHungerData = Hunger.setPlayerHungerData

addEvent('queenHunger.givePlayerHunger', true)
addEventHandler('queenHunger.givePlayerHunger', root, function(player, value)
	if not player then return end
	
	local userData = player:getData("player.userData")

	local new_value = tonumber(userData.user_eat) + value
	
	if new_value >= 100 then
		new_value = 100
	end
	
	userData.user_eat = new_value
	player:setData("player.userData", userData)
	
end)
--[[
addEventHandler('onResourceStart', resourceRoot, function()
	for _, player in ipairs(getElementsByType('player')) do
		Hunger.setPlayerHungerData(player)
	end
end)
]]
addEventHandler('onPlayerQuit', root, function()
	if isTimer(THE_TIMERS[source]) then
	    killTimer(THE_TIMERS[source])
	    THE_TIMERS[source] = nil
	end
end)

--[[
addEventHandler('onPlayerLogin', root, function(_, acc)
    --setElementData(source, 'queenPlayer.hungerLevel', 100)
    Hunger.setPlayerHungerData(source)
end)
]]

