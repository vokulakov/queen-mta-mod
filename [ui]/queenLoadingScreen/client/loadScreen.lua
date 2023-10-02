sx, sy = guiGetScreenSize()
loadingScreen = { }

local ugol, radius = 60, 60 -- Начальный угол поворота камеры и радиус окружности
local center = {["x"] = 1521, ["y"] = -1621, ["z"] = 129} -- Точка для центровки кадра

function startCamera()
	ugol = ugol+0.05 --Добавляем для угла значения
	local x = center.x+radius*math.cos(math.rad(ugol)) --Новые координаты X
	local y = center.y-radius*math.sin(math.rad(ugol)) --Новые коодинаты Y
	setCameraMatrix(x, y, center.z+70, center.x, center.y, center.z, 0, 90) -- Двигаем камеру

	--dxDrawRectangle(sx/2-1/2, 0, 1, sy, tocolor(0, 255, 255, 150))
end

addEvent('queenLoadingScreen.stopCamera', true)
addEventHandler('queenLoadingScreen.stopCamera', root, function()
	removeEventHandler('onClientPreRender', root, startCamera)
end)

local function loadingRound()
	local seconds = getTickCount() / 1000
	local angle = math.sin(seconds) * 360

	loadingScreen.TEXTURE_LOAD = exports["queenTextures"]:createTexture("assets/system_img/load.png")
	dxDrawImage(sx-62, (sy-200/2)+5, 26, 26, loadingScreen.TEXTURE_LOAD, angle, 0, 0, _, true)
end

local function onLoginLoad()
	setTimer( function() 
    	destroyElement(loadingScreen.LABEL_LOAD)
    	loadingScreen.LABEL_LOAD = nil

    	removeEventHandler("onClientPreRender", root, loadingRound)
    	destroyElement(loadingScreen.TEXTURE_LOAD)
    	loadingScreen.TEXTURE_LOAD = nil

    end, 1500, 1)

    setTimer( function() 
		loadingScreen.PRESS_ENTER = exports["queenNotification"]:drawHelpButton(sx/2-170/2+10, sy-200/2, 170, "Продолжить", 15, 0.7, "b_enter")

    	bindKey("enter", "down", showWelcomeScreen)
	end, 2500, 1)

end

local function showLoadingScreen()
	loadingScreen.WELCOME_SOUND = exports["queenSounds"]:playSound("load_sound", true)
	setSoundVolume(loadingScreen.WELCOME_SOUND, 0.5)

	triggerEvent('queenShaders.blurShaderStart', localPlayer)
	addEventHandler("onClientPreRender", root, startCamera)

	fadeCamera(true, 2) -- открываем камеру

	setTimer( function() 
		loadingScreen.LOGO = exports["queenTextures"]:staticImage(sx/2-200/2, sy/2-200/2, 200, 200, "assets/system_img/queen_logo.png", false)
		loadingScreen.LABEL_LOAD = exports["queenNotification"]:drawHelpButton(sx-290, sy-200/2, 270, "Идет загрузка ресурсов", 15, 0.7, "")
		addEventHandler("onClientPreRender", root, loadingRound)
	end, 200, 1)

end

local includesResource = {
	['queenSounds'] 		= true,
	['queenShaders'] 		= true,
	['queenTextures'] 		= true,
	['queenNotification'] 	= true,
}

local function checkingIsLoginDownload()
	local resource = getResourceFromName('queenLogin')

	if getResourceState(resource) == 'running' then

		if isTimer(loadingScreen.checkTimer) then 
			killTimer(loadingScreen.checkTimer)
			loadingScreen.checkTimer = nil
		end

		onLoginLoad()
	end
end

local function checkingIsDownload()
	local result = {}

	for resourceName in pairs(includesResource) do
		local resource = getResourceFromName(resourceName)
		result[resourceName] = getResourceState(resource)
	end

	for _, state in pairs(result) do
		if state ~= 'running' then
			return
		end
	end

	if isTimer(loadingScreen.checkTimer) then 
		killTimer(loadingScreen.checkTimer)
		loadingScreen.checkTimer = nil
	end

	loadingScreen.checkTimer = setTimer(checkingIsLoginDownload, 500, 0)

	showLoadingScreen()
end
loadingScreen.checkTimer = setTimer(checkingIsDownload, 500, 0)
