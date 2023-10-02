addEvent("queenChat.broadcastMessage", true)
addEventHandler("queenChat.broadcastMessage", root, function (rawMessage)
	local sender
	if not client then
		sender = source
	else
		sender = client
	end

	if sender.muted then
		return
	end

	exports.queenLogger:log("chat", string.format("%s (%s): %s",
		tostring(sender.name),
		tostring(sender.name),
		tostring(rawMessage))
	)

	-- Локальный чат
	for i, player in ipairs(getElementsByType("player")) do
		local distance = (player.position - sender.position):getLength()
		if distance < 100 then
			triggerClientEvent(player, "queenChat.broadcastMessage", root, rawMessage, sender, distance)
		end
	end
end)
