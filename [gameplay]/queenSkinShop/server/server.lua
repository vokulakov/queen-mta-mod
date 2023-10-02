addEvent("queenSkinShop.onPlayerSkinChange",true)
addEventHandler("queenSkinShop.onPlayerSkinChange",getRootElement(),function(skinid, skinprice)
	--if getPlayerMoney(source) >= skinprice then

		--takePlayerMoney(source, tonumber(skinprice))
		--triggerClientEvent(source, 'exv_notify.addInformation', source, 'МАГАЗИН СКИНОВ: -'..skinprice..'$', true)

		setElementModel(source, skinid)
		--outputChatBox("Вы купили скин за "..skinprice.." $", source)
	--else
		--triggerClientEvent(source, 'exv_notify.addNotification', source, 'У вас недостаточно средств.', 1, false)
	--end
end)

local function onPickupHitEnter(player)
	local pickup_data = getElementData(source, 'queenSkinShop.PickupInfo')

	fadeCamera(player, false, 1)

	setTimer(function()
		setElementPosition(player, pickup_data.x, pickup_data.y, pickup_data.z)
		setPedRotation(player, 0) 
		setElementDimension(player, pickup_data.dim)
		setElementInterior(player, pickup_data.int) 

		triggerClientEvent(player, 'queenSkinShop.music', player, not pickup_data.exit)
		
		setCameraTarget(player, player)
		fadeCamera(player, true, 1)
	end, 1500, 1)

end

addEventHandler('onResourceStart', getResourceRootElement(), function()
	for _, shop in ipairs(skinShopTable) do

		local pickup_entrance = createPickup(
			shop.entrance.x, 
			shop.entrance.y,
			shop.entrance.z, 
		3, 1318, 1)
		setElementData(pickup_entrance, 'queenSkinShop.PickupInfo', 
			{ 
				x = shop.exit.x, 
				y = shop.exit.y,
				z = shop.exit.z, 
				dim = shop.dim,
				int = shop.int,
				text = 'Магазин скинов',
				textZ = 1
			}
		)
		--createBlipAttachedTo(pickup_entrance, 45)
		addEventHandler("onPickupHit", pickup_entrance, onPickupHitEnter)
		
		local pickup_exit = createPickup(
			shop.exit.x, 
			shop.exit.y,
			shop.exit.z, 
		3, 1318, 1)
		setElementDimension(pickup_exit, shop.dim)
		setElementInterior(pickup_exit, shop.int)

		setElementData(pickup_exit, 'queenSkinShop.PickupInfo', 
			{ 
				x = shop.entrance.x, 
				y = shop.entrance.y,
				z = shop.entrance.z, 
				dim = 0,
				int = 0,
				exit = true,
				text = 'Выход',
				textZ = 1
			}
		)
		addEventHandler("onPickupHit", pickup_exit, onPickupHitEnter)
	end
end)