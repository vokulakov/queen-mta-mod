-- BLIPS --
for _, hospital in ipairs(Config.hospitalPosition) do
	createBlip(hospital.x, hospital.y, hospital.z, 17, 0, 255, 0, 0, 255, 0, 450)
end
-----------

Dead = {}

Dead.pedPosition = {
	--back left
    {
        x=870.099,
        y=-1102.699,
        z=24.5,
        rotZ=270,
        initX=893.4,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },
	
    --middle left
    {
        x=871,
        y=-1102.699,
        z=24.5,
        rotZ=270,
        initX=894.200,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },
	
    --front left
    {
        x=872.099,
        y=-1102.700,
        z=24.5,
        rotZ=270,
        initX=895.099,
        initY=-1089.9,
        initZ=24.299,
        initRotZ=180
    },
	
    --back right
    {
        x=870.099,
        y=-1101.299,
        z=24.5,
        rotZ=270,
        initX=896,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },  
	
    --middle right
    {
        x=871,
        y=-1101.300,
        z=24.5,
        rotZ=270,
        initX=896.799,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    },
	
    --front right
    {
        x=872.099,
        y=-1101.300,
        z=24.5,
        rotZ=270,
        initX=897.599,
        initY=-1090,
        initZ=24.299,
        initRotZ=180
    }
}

Dead.animations = { "dance_loop", "dan_down_a", "dan_left_a" }

Dead.coffinCameraPos = {
	{876.04760742188, -1102.0268554688, 24.955196380615, 776.07507324219, -1100.548828125, 23.136426925659},
    {871.17047119141, -1098.109375, 25.18699836731, 869.30242919922, -1197.7568359375, 17.008024215698},
    {875.92095947266, -1103.0090332031, 24.648569107056, 777.544921875, -1085.0686035156, 24.103551864624}
}

function Dead.getRandomDanceMove()
	return Dead.animations[math.random(#Dead.animations)]
end

function Dead.getRandomCameraPos()
	return unpack(Dead.coffinCameraPos[math.random(#Dead.coffinCameraPos)])
end

local coffinDance = {}

function Dead.createPedsAndCoffin()
	coffinDance.theCoffin = createObject(2896, 871, -1102, 25.25)
	setElementCollisionsEnabled(coffinDance.theCoffin, false)
	
	coffinDance.peds = {}
	
	for i, pedData in pairs(Dead.pedPosition) do
        coffinDance.peds[i] = createPed(296, pedData.initX, pedData.initY, pedData.initZ, pedData.initRotZ)    
    end
end

function Dead.adjustCoffinPosition()
	if not isElement(coffinDance.theCoffin) then
		return
	end
	
    local sx, sy, sz = getPedBonePosition(coffinDance.peds[1], 32)
    local x, y, z = getElementPosition(coffinDance.theCoffin)
    setElementPosition(coffinDance.theCoffin, x, y, sz+0.38)
end

function Dead.changeMovesAndCamera()
    local randomMove = Dead.getRandomDanceMove()
	
    for i, ped in pairs(coffinDance.peds) do
        setPedAnimation(coffinDance.peds[i], "dancing", randomMove, -1, true)
    end
	
    local x, y, z, lx, ly, lz = Dead.getRandomCameraPos()
    setCameraMatrix(x, y, z, lx, ly, lz)
end

function Dead.movePedsAndCoffin()
	local randomMove = Dead.getRandomDanceMove()
	
	for i, ped in pairs(coffinDance.peds) do
		local pedData = Dead.pedPosition[i]
        setElementPosition(coffinDance.peds[i], pedData.x, pedData.y, pedData.z)
        setElementRotation(coffinDance.peds[i], 0,0, pedData.rotZ)
        setPedAnimation(coffinDance.peds[i], "dancing", randomMove, -1, true)
    end
	
	setCameraMatrix(874.66851806641, -1103.0676269531, 26.115673065186, 783.24334716797, -1071.3548583984, 0.90169233083725)
	coffinDance.changeCameraTimer = setTimer(Dead.changeMovesAndCamera, 3000, 0)
end

local NAMETAG_FONT = "default-bold"

local function dxDrawNametagText(text, x1, y1, x2, y2, color, scale)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, NAMETAG_FONT, "center", "center")
	dxDrawText(text, x1, y1, x2, y2, color, scale, NAMETAG_FONT, "center", "center")
end

function Dead.drawNameTag()
	local rx, ry, rz = getElementPosition(coffinDance.theCoffin)
	local sx, sy = getScreenFromWorldPosition(rx, ry, rz+0.65, 0.06)
	if not sx then
		return
	end
	
	dxDrawNametagText(coffinDance.playerName, sx, sy, sx, sy, tocolor(255, 255, 255, 255), 1)
	dxDrawRectangle(sx-50/2, sy+10, 50, 6, tocolor(0, 0, 0, 150))
	--dxDrawRectangle(sx-48/2, sy+11, 0, 4, tocolor(200, 0, 0, 250))
end

function Dead.startCoffinDance()
	local player = localPlayer

	coffinDance.playerName = utf8.gsub(player:getName(), "#%x%x%x%x%x%x", "") -- ник
	coffinDance.soundBackGround = playSound("assets/sound/music.mp3") -- музыка

	triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, false)

	Dead.createPedsAndCoffin()
	setTimer(Dead.stopCoffinDance, 20000, 1)
	smoothMoveCamera(895.61645507813, -1090.732421875, 25.03558921814, 800.69714355469, -1059.275390625, 25.923006057739, 895.61645507813, -1090.732421875, 25.03558921814, 989.95971679688, -1057.6175537109, 23.375392913818, 5000)
	
	setTimer(Dead.movePedsAndCoffin, 5000, 1)
	
	addEventHandler("onClientRender", root, Dead.adjustCoffinPosition)
	addEventHandler("onClientRender", root, Dead.drawNameTag)
end
addEvent('queenPlayerDead.onStartCoffinDance', true)
addEventHandler('queenPlayerDead.onStartCoffinDance', root, Dead.startCoffinDance)

function Dead.stopCoffinDance()
	fadeCamera(false)
	removeEventHandler("onClientRender", root, Dead.drawNameTag)
	
	setTimer(function()
		triggerEvent("queenShowUI.setVisiblePlayerUI", localPlayer, true)
		triggerServerEvent('queenPlayerDead.onStopCoffinDance', localPlayer)

		if (isTimer(coffinDance.changeCameraTimer)) then 
        	killTimer(coffinDance.changeCameraTimer)
   		end
	
		if isElement(coffinDance.soundBackGround) then
			stopSound(coffinDance.soundBackGround)
		end
		
		removeEventHandler("onClientRender", root, Dead.adjustCoffinPosition)

		for i, pedData in pairs(coffinDance.peds) do
	        if (isElement(coffinDance.peds[i])) then
	            destroyElement(coffinDance.peds[i])
	        end
	    end
		
	    if (isElement(coffinDance.theCoffin)) then
	        destroyElement(coffinDance.theCoffin)
	    end

	    coffinDance = {}
	end, 2000, 1)
end

-- ///////////// smoothmove camera script from mta Wiki

local sm = {}
sm.moov = 0

local function removeCamHandler()
	if(sm.moov == 1)then
		sm.moov = 0
	end
end

local start
local animTime
local tempPos = {{},{}}
local tempPos2 = {{},{}}

local function camRender()
	local now = getTickCount()
	if (sm.moov == 1) then
		local x1, y1, z1 = interpolateBetween(tempPos[1][1], tempPos[1][2], tempPos[1][3], tempPos2[1][1], tempPos2[1][2], tempPos2[1][3], (now-start)/animTime, "InOutQuad")
		local x2,y2,z2 = interpolateBetween(tempPos[2][1], tempPos[2][2], tempPos[2][3], tempPos2[2][1], tempPos2[2][2], tempPos2[2][3], (now-start)/animTime, "InOutQuad")
		setCameraMatrix(x1,y1,z1,x2,y2,z2)
	else
		removeEventHandler("onClientRender",root,camRender)
		fadeCamera(true)
	end
end

function smoothMoveCamera(x1,y1,z1,x1t,y1t,z1t,x2,y2,z2,x2t,y2t,z2t,time)
	if(sm.moov == 1) then
		killTimer(timer1)
		killTimer(timer2)
		removeEventHandler("onClientRender",root,camRender)
		fadeCamera(true)
	end
	fadeCamera(true)
	sm.moov = 1
	timer1 = setTimer(removeCamHandler,time,1)
	timer2 = setTimer(fadeCamera, time-1000, 1, false) -- 
	start = getTickCount()
	animTime = time
	tempPos[1] = {x1,y1,z1}
	tempPos[2] = {x1t,y1t,z1t}
	tempPos2[1] = {x2,y2,z2}
	tempPos2[2] = {x2t,y2t,z2t}
	addEventHandler("onClientRender",root,camRender)
	return true
end