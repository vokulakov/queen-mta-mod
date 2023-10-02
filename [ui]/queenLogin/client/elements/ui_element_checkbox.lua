local checkBox = { }

addEventHandler("onClientElementDestroy", root, function()
	if not checkBox[source] then
		return
	end
	
	checkBox[source] = nil
end)


function createCheckBox(x, y, text, parent, accept)
	local back = guiCreateStaticImage(x, y, 19, 19, "assets/img/checkbox.png", false, parent)

	checkBox[back] = {}
	checkBox[back].back = back
	checkBox[back].accept = isAccept or false

	setCheckBoxState(back, accept)

	checkBox[back].text = guiCreateLabel(0.6, 0.65, 1, 1, "ЗАПОМНИТЬ", true, parent)
	guiSetFont(checkBox[back].text, UI_FONTS['LOGIN_R_9'])
	guiLabelSetColor(checkBox[back].text, 80, 80, 80)

	return back
end

function getCheckBoxState(element)
	if not element then
		return
	end

	if not checkBox[element] then
		return
	end

	return checkBox[element].accept
end

function setCheckBoxState(element, state)
	if not element then
		return
	end

	if not checkBox[element] then
		return
	end

	if state then
		guiStaticImageLoadImage(checkBox[element].back, "assets/img/checkbox_active.png")
	else
		guiStaticImageLoadImage(checkBox[element].back, "assets/img/checkbox.png")
	end

	checkBox[element].accept = state
end

addEventHandler("onClientGUIClick", root, function(button)
	if not button == 'left' then return end

	if not checkBox[source] then
		return
	end

	setCheckBoxState(source, not checkBox[source].accept)
end)