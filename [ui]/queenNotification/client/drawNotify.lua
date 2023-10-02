local messages = {}
local sW, sH = guiGetScreenSize()

local posY = sH-220

-- Настройки
local FONT = 'default-bold' -- шрифт
local offset = dxGetFontHeight(1, FONT)

local tick = getTickCount()

-- ОТОБРАЖЕНИЕ УВЕДОМЛЕНИЙ [НАЧАЛО] --
addEventHandler("onClientRender", root, function()
	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['notify'] then return end

	if getElementInterior(localPlayer) ~= 0 then
		posY = sH-10
	else
		posY = sH-220
	end

	tick = getTickCount()
	local prev = 0

	if (#messages > 3) then
		table.remove(messages, 1)
	end

	for index, data in ipairs(messages) do

		local v1 = data[1] -- текст
		local v2 = data[2] -- количество строк
		local v3 = data[3] -- ширина текста
		local v4 = data[4] -- время
		local v5 = data[5] -- альфа
		local v6 = data[6] -- цвет полоски

		dxDrawRectangle(15, posY-(v3+prev)-(index*5), 230, offset*v2+5, tocolor(0, 0, 0, v5))
		dxDrawRectangle(15, posY-(v3+prev)-(index*5), 2, offset*v2+5, tocolor(v6[1], v6[2], v6[3], v5))

		dxDrawText(v1, 25, posY-(v3+prev)-(index*5)+2, 230, posY, tocolor(255, 255, 255, v5 + 75), 1, FONT, 'left', 'top')

		if (tick >= v4) then
			messages[index][5] = v5 - 2
			if (v5 <= 25) then
				table.remove(messages, index)
			end
		end

		prev = prev + v3 + 5
	end

end)
-- ОТОБРАЖЕНИЕ УВЕДОМЛЕНИЙ [КОНЕЦ] --

local function addNotification(text, type, _sound)
	local color
	local line_count = 1

	local sound = true

	if _sound ~= nil then sound = _sound end

	for S in string.gmatch(text, "\n") do
		line_count = line_count + 1
	end

	if type == 1 then
		color = {0, 255, 0}
		if sound then
			exports.queenSounds:playSound('notify')
		end
	elseif type == 2 then
		color = {255, 0, 0}
		if sound then
			exports.queenSounds:playSound('error')
		end
	end

	table.insert(messages, {text, line_count, offset*line_count, tick + 10000, 180, color})

end
addEvent("queenNotification.addNotification", true)
addEventHandler("queenNotification.addNotification", root, addNotification)

--addNotification('Тестовое уведомление!\nДобро пожаловать на Queen MTA.\nПриятной игры!', 1, true)
--addNotification('Тестовое уведомление!\nДобро пожаловать на Queen MTA.\nПриятной игры!', 2, true)

--[[
local DX_TEXT_FONT = exports["exv_fonts"]:createFont("AEROMATICS_BOLD.ttf", 12)
local infomsg = {}
local tick = getTickCount()

local function dxDrawCustomText(text, x1, y1, x2, y2, color, alignX, alignY)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), 1, DX_TEXT_FONT, alignX, alignY)
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), 1, DX_TEXT_FONT, alignX, alignY)
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), 1, DX_TEXT_FONT, alignX, alignY)
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), 1, DX_TEXT_FONT, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, 1, DX_TEXT_FONT, alignX, alignY)
end

addEventHandler("onClientRender", root, function()
	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI")
	if not PLAYER_UI['notify'] then return end

	tick = getTickCount()

	local IND 

	for index, data in ipairs(infomsg) do
		local v1 = data[1] -- текст
		local v2 = data[8] -- time
		local v3 = data[9] -- alpha

		if IND == index or IND == nil then

			dxDrawCustomText(v1, data[2], data[3], data[4], data[5], tocolor(255, 255, 255, v3), data[6], data[7])

			if (tick >= v2) then
				infomsg[index][9] = v3 - 2
				if (v3 <= 25) then
					table.remove(infomsg, index)
				end
			end

			return
		end

		IND = index
	end

end)

local function addInformation(text, _sound)

	local veh = getPedOccupiedVehicle(localPlayer)

	local x1, y1, x2, y2, alignX, alignY = sW, sH-100, sW-20, sH, "right", "center"

	if veh and getPedOccupiedVehicleSeat(localPlayer) == 0 then
		x1, y1, x2, y2, alignX, alignY = sW/2, sH-30, sW/2, sH-30, "center", "center"
	end

	table.insert(infomsg, {text, x1, y1, x2, y2, alignX, alignY, tick + ((#infomsg+1)*5000), 255})

	if _sound then
		if #infomsg == 1 then
			exports["exv_sounds"]:playSound('sell')
			return
		end

		setTimer(function()
			exports["exv_sounds"]:playSound('sell')
		end, infomsg[#infomsg][8]-tick-5000+2300, 1)
	end

end
addEvent("queenNotification.addInformation", true)
addEventHandler("queenNotification.addInformation", root, addInformation)
]]
