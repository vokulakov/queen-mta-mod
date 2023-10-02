--[[
********************************************************************************
	Project owner:		Vladimir Kulakov
    Owner Contacts: 	vk:		vk.com/vokulakov
    					tg: 	@vokulakov
    					inst:	@vokulakov

	Project name: 		Queen × MTA:SA
	Project link: 		vk.com/mtaqueen
	Developers:   		vokulakov
	
	Version:    		Closed source
	Status:     		Pre-Alpha
********************************************************************************
--]]

MAP_NAME = "San-Andreas" -- карта
GAME_TYPE = "Идет разработка..." -- игровой режим
MOD_INFO = "Queen MTA 1.0.0" -- информация о моде
SERVER_PASSWORD = "" -- пароль

SHOW_MESSAGE = true -- показывать сообщение в чате перед выключением
KICK_PLAYERS = true -- кикакть игроков перед выключением

startupResources = { -- загружаемые ресурсы

	-- ASSETS --
	"queenFonts",
	"queenShaders",
	"queenSounds",
	"queenTextures",

	-- CORE --
	"queenUtils",
	"queenCore",
	"queenLogger",
 	"queenShared",
 	
    -- MODELS --
    --"queenModelsSkin",
    --"queenModelsVehicle",
    
    -- GAMEPLAY --
    "queenVehicleHorn",
    "queenVehicleControl",
    "queenHunger",
    "queenSkinShop",
    "queenRestaurants",
    "queenVehicleFuel",
    "queenPlayerDead",
    
    -- SHADERS --
    "vehicleLights",
    
	-- UI --
	"queenShowUI",
	"queenMap",
	"queenNametag",
	"queenChat",
	"queenHUD",
	"queenLoadingScreen",
	"queenNotification",
	"queenScoreboard",

	"queenLogin"
}
