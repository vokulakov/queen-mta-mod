local screenW, screenH = guiGetScreenSize()
local SB_WIDTH, SB_HEIGHT = 492, 446
local SB_POSX, SB_POSY = screenW/2-SB_WIDTH/2, screenH/2-SB_HEIGHT/2

local SB_TEXTURE = dxCreateTexture('assets/bg.png')
local SB_VISIBLE

local playersList = {}
local playersOnlineCount = 0
local playersMaxCount 
local scrollOffset = 0

local HEAD_FONT 	= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 14.5, false, "draft")
local COLUMNS_FONT 	= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 12, false, "draft")
local ITEM_FONT		= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 10.5, false, "draft")

-- SETUPS --
local itemsCount 		= 10
local headerColor 		= tocolor(80, 80, 80, 255) 
local columnsColor 		= tocolor(80, 80, 80, 255)
local playerLocalColor 	= tocolor(255, 168, 0, 255)
local playerAunColor 	= tocolor(80, 80, 80, 125)
local playerColor 		= tocolor(80, 80, 80, 255)

local columns = {
	{ name = "ID",			size = 0.1,		data = "id" 	},
	{ name = "Ник", 		size = 0.4, 	data = "name"	},
	{ name = "Уровень", 	size = 0.37, 	data = "level"	},
	{ name = "Пинг", 		size = 0.1						}
}

local function drawScoreBoard()
	dxDrawImage(SB_POSX, SB_POSY, SB_WIDTH, SB_HEIGHT, SB_TEXTURE)

	dxDrawText("СПИСОК ИГРОКОВ", SB_POSX+15, SB_POSY, SB_POSX+SB_WIDTH, SB_POSY+51, headerColor, 1, HEAD_FONT, 'left', 'center')
	dxDrawText(playersOnlineCount.."/"..playersMaxCount, SB_POSX+15, SB_POSY, SB_POSX+SB_WIDTH-15, SB_POSY+51, headerColor, 1, HEAD_FONT, 'right', 'center')

	--dxDrawRectangle(SB_POSX+15-1/2, 0, 1, screenH, tocolor(0, 255, 255, 255))
	--dxDrawRectangle(SB_POSX+SB_WIDTH-15-1/2, 0, 1, screenH, tocolor(0, 255, 255, 255))

	-- КОЛОНКИ --
	local x = SB_POSX
	for i, column in ipairs(columns) do
		local width = SB_WIDTH * column.size
		dxDrawText(tostring(column.name), x, SB_POSY+51, x+width, SB_POSY+51+44, columnsColor, 1, COLUMNS_FONT, "center", "center")
		x = x + width
	end
	dxDrawRectangle(SB_POSX+15, SB_POSY+51+44, SB_WIDTH-32, 1, tocolor(186, 186, 186, 255))

	-- ТАБЛИЦА --
	local y = SB_POSY+51+31
	for i = scrollOffset + 1, math.min(itemsCount + scrollOffset, #playersList) do
		local item = playersList[i]
		local color = playerColor
		if item.isLocalPlayer then
			color = playerLocalColor
		end
		if item.isLogin then
			color = playerAunColor
		end
		x = SB_POSX
		for j, column in ipairs(columns) do
			local text = item[column.data]
			if text == nil then text = getPlayerPing(item.player) end
			local width = SB_WIDTH * column.size
			dxDrawText(tostring(text), x, y, x+width, y+65, color, 1, ITEM_FONT, "center", "center")
			x = x + width
		end
		y = y + 35
	end

end

local function mouseDown()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset + 1
	if scrollOffset > #playersList - itemsCount then
		scrollOffset = #playersList - itemsCount + 1
	end
end

local function mouseUp()
	if #playersList <= itemsCount then
		return
	end
	scrollOffset = scrollOffset - 1
	if scrollOffset < 0 then
		scrollOffset = 0
	end
end

local function addPlayerToList(player, login, isLocalPlayer)
	if type(player) == "table" then
		table.insert(playersList, player)
		return
	end

	local pl_name = utf8.gsub(player:getName(), "#%x%x%x%x%x%x", "")
	local pl_lvl = '-'

	if login then
		pl_name = "Авторизовывается"
	end

	local userData = player:getData('player.userData')

	if type(userData) == 'table' then
		pl_lvl = userData.user_lvl
	end

	table.insert(playersList, {
		isLogin = login,
		isLocalPlayer = isLocalPlayer,
		id = player:getData('serverId'),
		level = pl_lvl,
		name = pl_name,
		player = player 
	})
end

local function startScoreBoard()
	addEventHandler("onClientRender", root, drawScoreBoard)
	triggerEvent("queenShaders.blurShaderStart", localPlayer) -- включаем размытие

	local players = getElementsByType("player")

	playersList = {}
	playersOnlineCount = #players
	playersMaxCount = getElementData(root, 'queenServerMaxPlayers')

	addPlayerToList(localPlayer, false, true)

	if #players > 0 then
		for i, player in ipairs(players) do
			if player ~= localPlayer then
				addPlayerToList(player, not player:getData('player.userData'), false)
			end
		end
	end

	bindKey("mouse_wheel_up", "down", mouseUp)
	bindKey("mouse_wheel_down", "down", mouseDown)
end

local function stopScoreBoard()
	removeEventHandler("onClientRender", root, drawScoreBoard)
	triggerEvent("queenShaders.blurShaderStop", localPlayer) -- выключаем размытие
	
	unbindKey("mouse_wheel_up", "down", mouseUp)
	unbindKey("mouse_wheel_down", "down", mouseDown)
end

local function setScoreBoardVisible()
	local ACTIVE_UI = getElementData(localPlayer, "queenPlayer.ACTIVE_UI")
	if ACTIVE_UI and ACTIVE_UI ~= 'scoreboard' then return end

	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['scoreboard'] then return end

	SB_VISIBLE = not SB_VISIBLE
	showCursor(SB_VISIBLE)
	--showChat(not SB_VISIBLE)
	
	if SB_VISIBLE then
		startScoreBoard()
		setElementData(localPlayer, "queenPlayer.ACTIVE_UI", "scoreboard")
	else
		stopScoreBoard()
		setElementData(localPlayer, "queenPlayer.ACTIVE_UI", false)
	end

	-- СКРЫТИЕ HUD
	triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, not SB_VISIBLE)
	triggerEvent("queenShowUI.setVisiblePlayerComponentUI", localPlayer, "scoreboard", true)
end
bindKey("tab", "down", setScoreBoardVisible)
bindKey("tab", "up", setScoreBoardVisible)