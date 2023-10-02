local welcomeScreen = {}

local function drawWelcomeScreen()
	welcomeScreen.WELCOME_SOUND = exports["queenSounds"]:playSound("login_sound", true)
	setSoundVolume(welcomeScreen.WELCOME_SOUND, 0.3)

	-- WELCOME SCREEN --
	fadeCamera(true, 1)
	setCameraMatrix(2006, 1267, 83, -200, -650, 1000, 0, 0)

	setTimer(function() 
		welcomeScreen.WELCOME = exports["queenTextures"]:staticImage(sx/2-800/2, sy/2-512/2, 800, 512, "assets/system_img/welcome_screen.png", false)
	end, 1000, 1)
	--------------------

	setTimer(function()
		destroyElement(welcomeScreen.WELCOME)
		welcomeScreen.WELCOME = nil

		fadeCamera(false, 2) 
	end, 4000, 1)

	setTimer(function()  
		fadeCamera(true, 2)
		addEventHandler("onClientPreRender", root, startCamera)
	end, 6000, 1)

	-- Запускаем панель авторизации
	setTimer(triggerEvent, 6200, 1, 'queenLogin.startLoginUI', localPlayer)
end

function showWelcomeScreen()
	-- Бинд
	unbindKey("enter", "down", showWelcomeScreen)

	-- Лого
	destroyElement(loadingScreen.LOGO)
	loadingScreen.LOGO = nil

   	-- Кнопка 'Продолжить'
   	destroyElement(loadingScreen.PRESS_ENTER)
   	loadingScreen.PRESS_ENTER = nil

   	-- Камера
   	fadeCamera(false, 2)

   	setTimer(function(sound) 
   		-- Музыка
		stopSound(sound)
		removeEventHandler("onClientPreRender", root, startCamera)
	end, 2000, 1, loadingScreen.WELCOME_SOUND)

   	loadingScreen.WELCOME_SOUND = nil
   	loadingScreen = { }

   	setTimer(drawWelcomeScreen, 3000, 1)

end

addEvent('queenLoadingScreen.stopSound', true)
addEventHandler('queenLoadingScreen.stopSound', root, function()
	destroyElement(welcomeScreen.WELCOME_SOUND)
	welcomeScreen.WELCOME_SOUND = nil
end)