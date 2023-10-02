local bg  = dxCreateTexture('assets/project.png')
local posX, posY = 0, 0

ServerINFO = {}
ServerINFO.visible = false

ServerINFO.TEXT = {url = 'VK.COM/MTAQUEEN'}

local function drawServerInfo()
	--dxDrawRectangle(0, 40-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(10-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(posX+70-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(posX+215-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(posX+258-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	
	dxDrawImage(posX, posY, 268, 80, bg, 0, 0, 0, tocolor(255, 255, 255, 255))
	dxDrawText(ServerINFO.TEXT.url, posX+70, posY+10, posX+215, posY+40, tocolor(255, 255, 255, 255), 1, HUD.FONTS['server_font_RR'],  "center", "center", false, false)

	-- Онлайн
	local players = getElementsByType('player')
	dxDrawText('Онлайн: '..#players..'/'..getElementData(root, 'queenServerMaxPlayers'), posX+70, posY+40, posX+215, posY+70, tocolor(255, 255, 255, 255), 1, HUD.FONTS['server_font_RR8'],  "center", "center")
end

addEventHandler('onClientRender', root, function()
	if not ServerINFO.visible then
		return
	end

	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['hud'] then return end

	drawServerInfo()
end)

function ServerINFO.setVisible(visible)
	ServerINFO.visible = not not visible
end
