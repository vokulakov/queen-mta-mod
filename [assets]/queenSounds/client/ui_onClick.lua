local buttonsActive = {}

local function onClientGUI(button)
	if not button or buttonsActive[button] then
		return
	end
	
	local isClick = button:getData('queenSounds.UI')

	if not isClick then
		return
	end

	playSound(tostring(isClick))

	buttonsActive[button] = true

	setTimer(function()
		buttonsActive[button] = nil
	end, 500, 1)
end

addEventHandler("onClientGUIClick", root, function()
	onClientGUI(source)
end)

addEventHandler("onClientGUIMouseDown", root, function()
	onClientGUI(source)
end)