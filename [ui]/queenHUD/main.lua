sW, sH = guiGetScreenSize()

HUD = { radar = {}, speed = {}, server = {}, hud = {} }

HUD.FONTS = {
	['radar_font'] 			= exports.queenFonts:createFontDX("SPEED_0.ttf", 12, false, "draft"),

	['speed_font_Osw'] 		= exports.queenFonts:createFontDX("SPEED_0.ttf", 13.5, false, "draft"),
	['speed_font_Osw12'] 	= exports.queenFonts:createFontDX("SPEED_0.ttf", 12, false, "draft"),
	['speed_font_RR'] 		= exports.queenFonts:createFontDX("Roboto-Regular.ttf", 7.5, false, "draft"),
	['speed_font_RR6']		= exports.queenFonts:createFontDX("Roboto-Regular.ttf", 6, false, "draft"),

	['server_font_RR'] 		= exports.queenFonts:createFontDX("Roboto-Regular.ttf", 10, false, "draft"),
	['server_font_RR8'] 	= exports.queenFonts:createFontDX("Roboto-Regular.ttf", 8, false, "draft"),

	['hud_font_RB']			= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 11.5, false, "draft"),
	['hud_font_RB_EXP']	 	= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 7, false, "draft"),
	['hud_font_RB8']	 	= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 7.5, false, "draft")
} 

-- Настройки
HUD.radar.posX, HUD.radar.posY = 30, sH-210
HUD.speed.posX, HUD.speed.posY = sW, sH-35
HUD.server.posX, HUD.server.posX = 0, 0
HUD.hud.posX, HUD.hud.posY = sW-10, 10

ServerINFO.setVisible(true)

Radar.start()
Radar.setVisible(true)

Speed.start()
Speed.setVisible(true)

hud.start()
hud.setVisible(true)

-- Blips
--local playerPosition = Vector3(localPlayer.position)
--createBlip(playerPosition.x, playerPosition.y, playerPosition.z, 47, 0, 255, 0, 0, 255, 0, 450)