local posX, posY

hud = {}
hud.visible = false

local hudStart = false
local TXT = {}

local function getPlMoney()
	local money = getPlayerMoney()
	local dCount = 9 - tostring(money):len()

	return string.format("#333333%0"..dCount.."d#ffffff%d", 0, money)
end

local function drawHUD()
	--
	--[[
	dxDrawRectangle(posX-5-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(posX-26-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(posX-5-102-20-1/2, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(posX-5-102-40-5-5, 0, 1, sH, tocolor(0, 255, 255, 255), true)

	dxDrawRectangle(0, posY-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(0, posY+15-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(0, posY+30-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(0, posY+45-1/2, sW, 1, tocolor(0, 255, 255, 255), true)
	dxDrawRectangle(0, posY+60-1/2, sW, 1, tocolor(0, 255, 255, 255), true)


	dxDrawRectangle(0, posY+30-1/2+2, sW, 1, tocolor(255, 0, 0, 255), true)
	dxDrawRectangle(0, posY+30-1/2+27, sW, 1, tocolor(255, 0, 0, 255), true)

	--dxDrawRectangle(posX-1/2-134, 0, 1, sH, tocolor(0, 255, 255, 255), true)
	--dxDrawRectangle(posX-1/2-40, 0, 1, sH, tocolor(0, 255, 255, 255), true)

	--dxDrawRectangle(0, posY+15-1/2-8, sW, 1, tocolor(255, 0, 0, 255), true)
	--dxDrawRectangle(0, posY+15-1/2+8, sW, 1, tocolor(255, 0, 0, 255), true)
	--]]
	--

	local userDATA = localPlayer:getData("player.userData")
	if not userDATA then
		return 
	end

	dxDrawImage(posX-295, posY, 295, 60, TXT.bg)

	-- Level
	dxDrawImage(posX-5-102-40-5, posY+15-10, 20, 20, TXT.i_level)
	dxDrawImage(posX-5-102-40-5-125, posY+15-11, 122, 22, TXT.hud_l_low)

	local MAX_EXP = 1000
	local EXP = userDATA.user_exp
	local EXP_BAR = 122/MAX_EXP*EXP

	dxDrawImageSection(posX-5-102-40-5-125, posY+15-11, EXP_BAR, 22, 0, 0, EXP_BAR, 22, TXT.hud_level)
	dxDrawText(EXP.."/"..MAX_EXP, posX-5-102-40-5-125, posY+15-8, posX-5-102-40-5, posY+15+8, tocolor(255, 255, 255, 255), 1, HUD.FONTS['hud_font_RB_EXP'], "center", "center") 

	-- Health
	local HP_BAR = 102/100*getElementHealth(localPlayer)
	dxDrawImage(posX-5-20, posY+15-10, 20, 20, TXT.i_health)
	dxDrawImage(posX-5-102-22, posY+15-11, 102, 22, TXT.hud_low)
	dxDrawImageSection(posX-5-102-22, posY+15-11, HP_BAR, 22, 0, 0, HP_BAR, 22, TXT.hud_heal)

	-- Eat
	local EAT_LEVEL = userDATA.user_eat
	local EAT_BAR = 102/100*EAT_LEVEL
	dxDrawImage(posX-5-102-40-5, posY+30, 19, 20, TXT.i_eat)
	dxDrawImage(posX-5-102-40-5-102, posY+30, 102, 22, TXT.hud_low)
	dxDrawImageSection(posX-5-102-40-5-102, posY+30, EAT_BAR, 22, 0, 0, EAT_BAR, 22, TXT.hud_eat)

	-- Money
	dxDrawImage(posX-5-24, posY+30/2+16.5, 26, 26, TXT.i_money)
	dxDrawText(getPlMoney(), posX-5-102-22, posY+30/2+16.5-2, posX-5-25, 20, tocolor(255, 255, 255, 255), 1, HUD.FONTS['hud_font_RB'], 'right', nil, false, false, false, true)
	dxDrawText(tonumber(userDATA.user_donate), posX-5-102-22, posY+45, posX-5-25, posY+55, tocolor(186, 186, 186, 255), 1, HUD.FONTS['hud_font_RB8'], 'right', 'center')
end

addEventHandler('onClientRender', root, function()
	if not hud.visible then
		return
	end

	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['hud'] then return end

	drawHUD()
end)

function hud.start()
	if hudStart then
		return
	end

	hudStart = true

	posX, posY = HUD.hud.posX, HUD.hud.posY

	TXT = {
		bg 			= dxCreateTexture('assets/imgHUD/hud_bg.png'),
		hud_low 	= dxCreateTexture('assets/imgHUD/hud_low.png'),
		hud_l_low 	= dxCreateTexture('assets/imgHUD/hud_l_low.png'),

		hud_eat 	= dxCreateTexture('assets/imgHUD/hud_eat.png'),
		hud_level	= dxCreateTexture('assets/imgHUD/hud_level.png'),
		hud_heal	= dxCreateTexture('assets/imgHUD/hud_heal.png'),

		i_eat		= dxCreateTexture('assets/imgHUD/hud_e.png'),
		i_health 	= dxCreateTexture('assets/imgHUD/hud_h.png'),
		i_level 	= dxCreateTexture('assets/imgHUD/hud_l.png'),
		i_money 	= dxCreateTexture('assets/imgHUD/hud_m.png')
	}

end

function hud.setVisible(visible)
	hud.visible = not not visible
end