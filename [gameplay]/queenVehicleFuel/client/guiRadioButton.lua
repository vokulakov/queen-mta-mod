guiRadioButton = {}
guiRadioButton.UI = {}

local sW, sH = guiGetScreenSize()

function guiRadioButton.createRadioButton(x, y, text, state, parent)
	local back = guiCreateStaticImage(x, y, 19, 20, "assets/img/gui_radio_button.png", false, parent)
	back:setData('queenSounds.UI', 'ui_change') -- звук клика

	guiRadioButton.UI[back] = {}
	guiRadioButton.UI[back].img = back
	guiRadioButton.UI[back].state = state
	guiRadioButton.UI[back].parent = parent

	guiRadioButton.UI[back].text = guiCreateLabel(x+22, y, 50, 20, text, false, parent)
	guiSetFont(guiRadioButton.UI[back].text, UI.FONTS['RADIOBUTTON'])
	guiLabelSetColor(guiRadioButton.UI[back].text, 80, 80, 80)
	guiLabelSetVerticalAlign(guiRadioButton.UI[back].text, "center")
	
	guiRadioButton.setState(back, state)

	return back
end

function guiRadioButton.getState(isRadioButton)
	if not guiRadioButton.UI[isRadioButton] then
		return
	end

	return guiRadioButton.UI[isRadioButton].state
end

function guiRadioButton.setState(isRadioButton, state, update)
	if not guiRadioButton.UI[isRadioButton] then
		return
	end

	local isParent = guiRadioButton.UI[isRadioButton].parent
	--local isState  = guiRadioButton.UI[isRadioButton].state

	guiRadioButton.UI[isRadioButton].state = state

	if state then

		-- СМЕНА ТИПА ТОПЛИВА --
		fuelType = guiGetText(guiRadioButton.UI[isRadioButton].text)
		if update then exports.queenSounds:playSound('azs_pistolet_remove') end

		setTimer(function()
			exports.queenSounds:playSound('azs_pistolet_insert')

			local progress = guiProgressBar.getProgress(UI.pb) 
			UI.updateFuelingInfo(progress)

			guiStaticImageLoadImage(guiRadioButton.UI[isRadioButton].img, "assets/img/gui_radio_button_active.png")
		end, 1000, 1)
   		------------------------
	else
		guiStaticImageLoadImage(guiRadioButton.UI[isRadioButton].img, "assets/img/gui_radio_button.png")
	end

	if not update then
		return
	end

	for element in pairs(guiRadioButton.UI) do
		local radioButton = guiRadioButton.UI[element]
		if radioButton.parent == isParent and radioButton.img ~= guiRadioButton.UI[isRadioButton].img then
			guiRadioButton.setState(radioButton.img, not state, false)
		end
	end
end

addEventHandler("onClientGUIClick", root, function(button)
	if not guiRadioButton.UI[source] or not guiGetVisible(guiRadioButton.UI[source].img) and not button == "left" then
		return
	end

	if guiRadioButton.getState(source) then
		return
	end
    
	guiRadioButton.setState(source, true, true)
end)