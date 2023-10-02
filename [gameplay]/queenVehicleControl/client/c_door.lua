
local sendingPause = 250

local GUI = {
	scrollpane = {},
	label = {},
	button = {
		closeDoor = {},
		openDoor = {},
	},
	window = {},
	scrollbar = {},
	staticimage = {},
}
addEventHandler("onClientResourceStart", resourceRoot, function()
	local screenW, screenH = guiGetScreenSize()
	GUI.window.main = guiCreateWindow(screenW-390-20, (screenH-430)/2, 390, 430, "Контроль над авто", false)
	guiWindowSetSizable(GUI.window.main, false)
	
	local movable = {
		{id = "bonnet", name = "Капот", shift = 45},
		{id = "doors", name = "Все двери", shift = 40},
		{id = "doorsF", name = "Передние двери", shift = 35},
		{id = "doorsR", name = "Задние двери", shift = 45},
		{id = "trunk", name = "Багажник", shift = 50},
		{id = "doorLF", name = "Передняя левая дверь", shift = 35},
		{id = "doorRF", name = "Передняя правая дверь", shift = 40},
		{id = "doorLR", name = "Задняя левая дверь", shift = 35},
		{id = "doorRR", name = "Задняя правая дверь", shift = 50},
	}
	local scrollpaneShift = 0
	for _, data in ipairs(movable) do
		local scrollpane = guiCreateScrollPane(10, 25 + scrollpaneShift, 310, 35, false, GUI.window.main)
		GUI.scrollpane[data.id] = scrollpane
		scrollpaneShift = scrollpaneShift + data.shift
		
		GUI.button.closeDoor[data.id] = guiCreateButton(0, 5, 40, 30, "Закр.", false, scrollpane)
		GUI.label[data.id] = guiCreateLabel(45, 0, 220, 15, data.name, false, scrollpane)
		guiLabelSetHorizontalAlign(GUI.label[data.id], "center", false)
		guiSetFont(GUI.label[data.id], "default-bold-small")
		GUI.scrollbar[data.id] = guiCreateScrollBar(45, 18, 220, 17, true, false, scrollpane)
		addEventHandler("onClientGUIScroll", GUI.scrollbar[data.id], onGUIScroll)
		GUI.button.openDoor[data.id] = guiCreateButton(270, 5, 40, 30, "Откр.", false, scrollpane)
	end
	GUI.staticimage[1] = guiCreateStaticImage(320, 25, 60, 360, "dependencies.png", false, GUI.window.main)
	GUI.button.close = guiCreateButton(270, 395, 110, 25, "Закрыть панель", false, GUI.window.main)

	guiSetVisible(GUI.window.main, false)
end)

addEventHandler("onClientGUIClick", resourceRoot, function()
	if (source == GUI.button.close) then
		togglePanel()
		return
	end
	
	for elementName, element in pairs(GUI.button.closeDoor) do
		if (source == element) then
			guiScrollBarSetScrollPosition(GUI.scrollbar[elementName], 0.0)
			return
		end
	end
	
	for elementName, element in pairs(GUI.button.openDoor) do
		if (source == element) then
			guiScrollBarSetScrollPosition(GUI.scrollbar[elementName], 100.0)
			return
		end
	end
end)

function onGUIScroll()
	local vehicle = getPedOccupiedVehicle(localPlayer)
	local seat = getPedOccupiedVehicleSeat(localPlayer)
	if (not vehicle) or (seat ~= 0) then return end
	
	for elementName, thisScrollbar in pairs(GUI.scrollbar) do
		if (source == thisScrollbar) then
			local value = guiScrollBarGetScrollPosition(thisScrollbar)
			antiDOSsend(elementName, sendingPause, "exv_vehControl.setDoorRatio", resourceRoot, vehicle, elementName, value/100)
			
			local scrollsToUpdate
			if (elementName == "doors") then
				scrollsToUpdate = {"doorsF","doorsR", "doorLF","doorRF","doorLR","doorRR"}
			elseif (elementName == "doorsF") then
				scrollsToUpdate = {"doorLF","doorRF"}
			elseif (elementName == "doorsR") then
				scrollsToUpdate = {"doorLR","doorRR"}
			end
			if (scrollsToUpdate) then
				for _, door in ipairs(scrollsToUpdate) do
					updateScrollbar(GUI.scrollbar[door], value)
					antiDOSsend(door, sendingPause, false)
				end
			end
			break
		end
	end
end

function updateScrollbar(element, value)
	removeEventHandler("onClientGUIScroll", element, onGUIScroll)
	guiScrollBarSetScrollPosition(element, value)
	addEventHandler("onClientGUIScroll", element, onGUIScroll)
end


--	==========     Открытие/закрытие панели     ==========
function togglePanel()
	if guiGetVisible(GUI.window.main) then
		guiSetVisible(GUI.window.main, false)
		showCursor(false)
	else
		local vehicle = getPedOccupiedVehicle(localPlayer)
		if (vehicle) then
			updateScrollbar(GUI.scrollbar.bonnet, getVehicleDoorOpenRatio(vehicle, 0)*100)
			updateScrollbar(GUI.scrollbar.trunk, getVehicleDoorOpenRatio(vehicle, 1)*100)
			local doorLF = getVehicleDoorOpenRatio(vehicle, 2)*100
			local doorRF = getVehicleDoorOpenRatio(vehicle, 3)*100
			local doorLR = getVehicleDoorOpenRatio(vehicle, 4)*100
			local doorRR = getVehicleDoorOpenRatio(vehicle, 5)*100
			updateScrollbar(GUI.scrollbar.doors, (doorLF+doorRF+doorLR+doorRR)/4)
			updateScrollbar(GUI.scrollbar.doorsF, (doorLF+doorRF)/2)
			updateScrollbar(GUI.scrollbar.doorsR, (doorLR+doorRR)/2)
			updateScrollbar(GUI.scrollbar.doorLF, doorLF)
			updateScrollbar(GUI.scrollbar.doorRF, doorRF)
			updateScrollbar(GUI.scrollbar.doorLR, doorLR)
			updateScrollbar(GUI.scrollbar.doorRR, doorRR)
		
			guiSetVisible(GUI.window.main, true)
			showCursor(true)
		end
	end
end
addCommandHandler("carcontrol", togglePanel)
--bindKey("5", "down", "carcontrol")


--	==========     Слоумод на кнопку/действие     ==========
local sendData = {}
local sendTimers = {}

function antiDOSsend(actionGroup, pause, ...)
	local args = {...}
	if isTimer(sendTimers[actionGroup]) then
		sendData[actionGroup] = args[1] and args
	else
		if (args[1]) then
			triggerServerEvent(...)
			sendData[actionGroup] = false
			sendTimers[actionGroup] = setTimer(slowSend, pause, 1, actionGroup)
		end
	end
end

function slowSend(actionGroup)
	if (sendData[actionGroup]) then
		triggerServerEvent(unpack(sendData[actionGroup]))
		sendData[actionGroup] = nil
	end
end
