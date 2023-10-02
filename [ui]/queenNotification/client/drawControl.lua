local sW, sH = guiGetScreenSize()

Control = {}

Control.isVisible = true


local FONTS = {
	['TITTLE'] 		= exports.queenFonts:createFontDX("Roboto-Bold.ttf", 8, false, "draft"),
	['CONTROL'] 	= exports.queenFonts:createFontDX("Roboto-Regular.ttf", 8, false, "draft"),
	['HELP'] 		= exports.queenFonts:createFontDX("Roboto-Regular.ttf", 7, false, "draft")
}

local CONTROLS = { }

local plControl = { 
	{'F11', 'Карта штата'},
	{'F7', 'Включить/отключить чат'},

	{'TAB', 'Список игроков'},
	{'T', 'Сообщение в чат'},
}

local offset = 30
local width, height 
local posX, posY 


local function drawHelpControl()
	local ACTIVE_UI = getElementData(localPlayer, "queenPlayer.ACTIVE_UI")
	if not Control.isVisible or ACTIVE_UI and ACTIVE_UI ~= 'chat' then
		return
	end

	width, height = 230, #CONTROLS*offset+20
	posX, posY = sW-width-10, sH/2+height/2-30

	local PLAYER_UI = getElementData(localPlayer, "queenPlayer.UI") or {}
	if not PLAYER_UI['control'] then return end

	-- ШАПКА --
	dxDrawRectangle(posX, posY-24-height, width, 20, tocolor(0, 0, 0, 245), false)
	
	dxDrawText('Управление', posX+5, posY-21-height, width, 20, tocolor(255, 255, 255, 255), 1, FONTS['TITTLE'], 'left', 'top')
	dxDrawRectangle(posX, posY-height-4, width, height, tocolor(0, 0, 0, 200), false)

	local prev = 15
	for index, data in ipairs(CONTROLS) do

		-- КНОПКА --
		dxDrawRectangle(posX+5, posY-(prev)-offset, 30, 18, tocolor(255, 168, 0, 215), false)
		dxDrawText(data[1], posX+5, posY-(10+prev), posX+5+30, posY-(prev)-offset, tocolor(255, 255, 255, 255), 1, FONTS['TITTLE'], 'center', 'center')
		
		-- ДЕЙСТВИЕ --
		dxDrawText(data[2], posX, posY-(10+prev), posX+width-5, posY-(prev)-offset, tocolor(255, 255, 255, 150), 1, FONTS['CONTROL'], 'right', 'center')
		
		-- ПОЛОСКА --
		dxDrawRectangle(posX+5, posY-(10+prev), width-10, 1, tocolor(255, 255, 255, 100), false)
		prev = prev + offset
	end

	dxDrawText("Скрыть/показать окно помощи 'F5'", posX+5, posY-20, width, 20, tocolor(255, 255, 255, 100), 1, FONTS['HELP'])
end

addEventHandler("onClientRender", root, drawHelpControl)

addEventHandler('onClientResourceStart', resourceRoot, function()
	for _, control in ipairs(plControl) do
		Control.addControl(control[1], control[2])
	end
end)

function Control.addControl(but, act)
	table.insert(CONTROLS, {but, act})
end

function Control.removeControl(but)
	for i, control in ipairs(CONTROLS) do
		if control[1] == but then
			table.remove(CONTROLS, i)
			return true
		end
	end

	return false
end

function Control.setVisible()
	Control.isVisible = not Control.isVisible
end

-- VEHICLES --
local vehControl = {
	{'H', 'Гудок'},
	--{'B', 'Ремень безопасности'},
	{'K', 'Двери'},
	{'L', 'Фары'},
	{'2', 'Двигатель'},
	{',', 'Левый поворотник'},
	{'.', 'Правый поворотник'},
	{'/', 'Аварийка'},
	{'c', 'Круиз-контроль'}

}

function Control.onClientVehicle(state)
	if not state then
		for _, control in ipairs(vehControl) do
			Control.removeControl(control[1])
		end

		for _, control in ipairs(plControl) do
			Control.addControl(control[1], control[2])
		end

		return
	end

	for _, control in ipairs(plControl) do
		Control.removeControl(control[1], control[2])
	end

	for _, control in ipairs(vehControl) do
		Control.addControl(control[1], control[2])
	end
end

addEventHandler("onClientVehicleEnter", root, function (thePlayer, seat)
	if thePlayer == localPlayer and seat == 0 then
		Control.onClientVehicle(true)
	end
end)

addEventHandler("onClientVehicleStartExit", root, function(thePlayer, seat)
    if thePlayer == localPlayer and seat == 0 then
    	Control.onClientVehicle(false)
    end
end)

bindKey("F5", "down", Control.setVisible)


addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" and getPedOccupiedVehicle(getLocalPlayer()) == source then
	    if thePlayer == localPlayer and seat == 0 then
	    	for _, control in ipairs(vehControl) do
				Control.removeControl(control[1])
			end
	    end
	end
end)

addEventHandler("onClientPlayerWasted", getLocalPlayer(), function()
	if not getPedOccupiedVehicle(source) then return end
    if thePlayer == localPlayer and seat == 0 then
    	for _, control in ipairs(vehControl) do
			Control.removeControl(control[1])
		end
    end
end)
