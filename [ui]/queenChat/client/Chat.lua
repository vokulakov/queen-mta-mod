Chat = {}

local MAX_CHAT_HISTORY = 500
local MAX_CHAT_LINES = 10
local MAX_LINE_LENGTH = 80

local posX, posY = 10, 70 -- положение чата

local isVisible = true
local chatHistoryCurrent

messages = {}

function Chat.isVisible()
	return isVisible
end


function Chat.setVisible(visible)
	visible = not not visible

	if visible == isVisible then
		return false
	end

	if not visible then
		Input.close()
	end

	isVisible = visible
end

function Chat.message(text, r, g, b, colorCoded)
	if type(text) ~= "string" then
		return false
	end

	local color
	if r and g and b then
		color = tocolor(r, g, b)
	end
	if colorCoded == nil then
		colorCoded = true
	else
		colorCoded = not not colorCoded
	end

	-- удаление переносов строк
	text = utf8.gsub(text, "\n", " ")

	-- перенос строки
	local rest
	local textWithoutColors = utf8.gsub(text, "#%x%x%x%x%x%x", "")
	if utf8.len(textWithoutColors) > MAX_LINE_LENGTH then
		local colorsLength = #text - #textWithoutColors
		local foundSpace = false
		local spaceStart = MAX_LINE_LENGTH + colorsLength
		local spaceEnd = spaceStart - 20

		for i = spaceStart, spaceEnd, -1 do
			local c = utf8.sub(text, i, i)
			if c == ' ' then
				foundSpace = true
				rest = utf8.sub(text, i + 1, -1)
				text = utf8.sub(text, 1, i - 1)
				break
			end
		end
		-- если пробела нет, текст переносится принудительно
		if not foundSpace then
			rest = utf8.sub(text, MAX_LINE_LENGTH + colorsLength + 1, -1)
			text = utf8.sub(text, 1, MAX_LINE_LENGTH + colorsLength)
		end
		-- перенос цвета на следующую строку
		local match = pregMatch(text, "(#[0-9A-F]{6})")
		if match then
			rest = match[#match] .. rest
		end
		textWithoutColors = utf8.gsub(text, "#%x%x%x%x%x%x", "")
	end

	-- сообщение
	local message = {
		text = text,
		textWithoutColors = textWithoutColors,
		timestamp = getRealTime().timestamp,
		color = color,
		colorCoded = colorCoded
	}

	-- удалить самое старое сообщение при достижении лимита истории
	if #messages >= MAX_CHAT_HISTORY then
		table.remove(messages, 1)
	end
	-- добавление сообщения
	table.insert(messages, message)

	-- отправить перенесённую часть сообщения
	if rest and utf8.len(rest) > 0 then
		Chat.message(rest, r, g, b, colorCoded)
	end
end

local function drawMessages()
	local messageCount = #messages

	local j = MAX_CHAT_LINES - 1

	local endIndex
	if chatHistoryCurrent then
		endIndex = chatHistoryCurrent
	else
		endIndex = messageCount
	end
	local firstIndex = math.max(1, endIndex - MAX_CHAT_LINES + 1)

	for i = endIndex, firstIndex, -1 do
		local message = messages[i]
		
		if message == nil then
			return
		end

		local text = message.text
		local textWithoutColors = message.textWithoutColors

		local time = getRealTime(message.timestamp, true)
		local timeString = ("[%02d:%02d:%02d] "):format(time.hour, time.minute, time.second)
		text = timeString .. text
		textWithoutColors = timeString .. textWithoutColors
		
		dxDrawText(textWithoutColors, posX+3, posY+7 + j * 20, 0, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, false, false, false, true)
		dxDrawText(text, posX+2, posY+6 + j * 20, 0, 0, message.color, 1.0, "default-bold", "left", "top", false, false, false, message.colorCoded, true)
		j = j - 1
	end
end

function drawInput()
	if not Input.isActive() then
		return
	end

	local text = 'Сообщение' .. ": " .. Input.getText()
	local right = posX+2 + dxGetTextWidth(utf8.sub(text, 1, 96), 1, "default-bold")
	dxDrawText(text, posX+3, posY+7 + MAX_CHAT_LINES * 20, right + 1, 0, 0xFF000000, 1.0, "default-bold", "left", "top", false, true, false, false, true)
	dxDrawText(text, posX+2, posY+6 + MAX_CHAT_LINES * 20, right, 0, 0xFFFFFFFF, 1.0, "default-bold", "left", "top", false, true, false, false, true)
end

function Chat.historyUp()
	if not isVisible then
		return false
	end

	if chatHistoryCurrent == nil then
		chatHistoryCurrent = math.max(1, #messages - MAX_CHAT_LINES / 2)
	elseif chatHistoryCurrent == 1 then
		return false
	else
		chatHistoryCurrent = math.max(1, chatHistoryCurrent - MAX_CHAT_LINES / 2)
	end
	return true
end

function Chat.historyDown()
	if not isVisible then
		return false
	end

	if type(chatHistoryCurrent) == "number" then
		chatHistoryCurrent = math.min(#messages, chatHistoryCurrent + MAX_CHAT_LINES / 2)
		if chatHistoryCurrent == #messages then
			chatHistoryCurrent = nil
		end
	else
		return false
	end
	return true
end

addEventHandler("onClientRender", root, function()
	if not isVisible then
		return
	end

	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['chat'] then return end

	drawMessages()
	drawInput()
end)

setTimer(showChat, 1000, 0, false)
bindKey("F7", "down", function()
	Chat.setVisible(not Chat.isVisible())
end)

bindKey("pgup", "down", Chat.historyUp)
bindKey("pgdn", "down", Chat.historyDown)