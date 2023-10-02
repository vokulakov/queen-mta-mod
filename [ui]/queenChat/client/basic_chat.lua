-- Расстояние, на котором видны локальные сообщения
local MAX_MESSAGE_DISTANCE = 100
-- Цвет сообщений при наибольшем расстоянии; 0 - черный, 1 - белый
local MIN_BRIGHTNESS = 0.4


local function RGBToHex(red, green, blue, alpha)
	if((red < 0 or red > 255 or green < 0 or green > 255 or blue < 0 or blue > 255) or (alpha and (alpha < 0 or alpha > 255))) then
		return nil
	end
	if(alpha) then
		return string.format("#%.2X%.2X%.2X%.2X", red,green,blue,alpha)
	else
		return string.format("#%.2X%.2X%.2X", red,green,blue)
	end
end

local function getColorFromDistance(distance, r, g, b)
	local multiplier = MIN_BRIGHTNESS + math.min(1 - distance / MAX_MESSAGE_DISTANCE, 1) * (1 - MIN_BRIGHTNESS)
	if not r or not g or not b then
		r, g, b = 255, 255, 255
	end
	r = math.floor(multiplier * r)
	g = math.floor(multiplier * g)
	b = math.floor(multiplier * b)
	return RGBToHex(r, g, b)
end


addEvent("queenChat.message", true)
addEventHandler("queenChat.message", root, function (message)

	if AntiFlood.isMuted() then
		AntiFlood.onMessage()
		Chat.message("#FF0000" .. 'Не флуди!')
		return
	end

	triggerServerEvent("queenChat.broadcastMessage", root, message)
	AntiFlood.onMessage()
end)

addEvent("queenChat.broadcastMessage", true)
addEventHandler("queenChat.broadcastMessage", root, function (message, sender, distance)
	message = WordsFilter.filter(message)

	message = sender.name .. tostring(getColorFromDistance(distance)) .. ": " .. tostring(message)

	Chat.message(message)
end)