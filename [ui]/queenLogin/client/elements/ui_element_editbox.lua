local editBox = { }

local function showLineActive(element)
	if not element then 
		return 
	end

	if not guiGetVisible(element) then
		guiSetVisible(element, true)
		guiStaticImageLoadImage(element, "assets/img/line_active.png")
	else
		guiSetVisible(element, false)
	end
end	

addEventHandler("onClientElementDestroy", root, function()
	if not editBox[source] then
		return
	end
	editBox[source] = nil
end)

function createEditBox(x, y, text, parent, mask)
	local back = guiCreateStaticImage(x, y, 224, 28, "assets/img/editbox.png", false, parent)

	editBox[back] = {}
	editBox[back].text = "" -- текст 
	editBox[back].isMask = mask or false -- используется ли маска
	editBox[back].textMask = ""          -- текст маски (открытый)

	if text ~= "" then
		editBox[back].startText = text   -- начальный текст
	end

	editBox[back].active = false         -- активно ли поле ввода
	editBox[back].back = back

	editBox[back].lineActive = guiCreateStaticImage(10, 7, 1, 13, "assets/img/line_active.png", false, back)
	guiSetVisible(editBox[back].lineActive, false)

	editBox[back].labelText = guiCreateLabel(0.05, 0, 1, 1, text, true, back)
	guiSetFont(editBox[back].labelText, UI_FONTS['LOGIN_R_8'])
	guiLabelSetColor(editBox[back].labelText, 170, 170, 170)
	guiLabelSetVerticalAlign(editBox[back].labelText, "center")

	editBox[editBox[back].labelText] = { back = back } -- костыль для event's

	addEventHandler("onClientCharacter", root, function(ch)
		local source = back	

		if not editBox[source] then
			return 
		end

		if not editBox[source].active then 
			return
		end

		if (getEditBoxTextLen(source) == 28) then return end
		editBox[source].text = editBox[source].text..ch
		editBox[source].textMask = setCharMask(source)

		guiSetText(editBox[source].labelText, editBox[source].textMask)
		guiSetPosition(editBox[source].lineActive, guiLabelGetTextExtent(editBox[source].labelText) + 12, 7, false)
	end)

	addEventHandler("onClientKey", root, function(button, press) 
		if (button == "backspace") then
			local source = back	

			if not editBox[source] then
				return 
			end

			if not editBox[source].active then 
				return
			end

			if not press then return end

			editBox[source].text = delCharOnEditBox(editBox[source].text)
			editBox[source].textMask = getCharMask(source)

			guiSetText(editBox[source].labelText, editBox[source].textMask)
			guiSetPosition(editBox[source].lineActive, guiLabelGetTextExtent(editBox[source].labelText) + 12, 7, false)
		end
	end)

	return back
end


function delCharOnEditBox(element)
	if not element then
		return
	end

	if (element:len() == 0) then return element end

	local s = string.byte(element:sub(element:len(), element:len()))

	if (s > 127 and s < 256) then 
		element = string.sub(element, 0, element:len() - 2)
	else
		element = string.sub(element, 0, element:len() - 1)
	end

	return element
end

function setEditBoxText(element, text)
	if not element then
		return
	end

	editBox[element].text = text
	editBox[element].textMask = ""

	if text == "" then 
		return 
	end

	if not editBox[element].isMask then 
		return guiSetText(editBox[element].labelText, text)
	end

	local value = getEditBoxTextLen(element)

	for i = 1, value do
		editBox[element].textMask = editBox[element].textMask.."•"
		guiSetText(editBox[element].labelText, editBox[element].textMask)
	end

end

function setCharMask(element)
	if not element then
		return
	end

	if not editBox[element].isMask then 
		return editBox[element].text 
	end

	return editBox[element].textMask.."•"
end

function getCharMask(element)
	if not element then
		return
	end

	if not editBox[element].isMask then 
		return editBox[element].text 
	end

	if(editBox[element].textMask:len() == 0) then 
		return editBox[element].textMask
	end

	return string.sub(editBox[element].textMask, 0, editBox[element].textMask:len() - 3)
end

function getEditBoxTextLen(element)
	if not element then
		return
	end

	local text = editBox[element].text
	local value = 0

	if text == "" then
		return value
	end

	repeat
		local s = string.byte(text:sub(text:len(), text:len()))
		if(s > 127 and s < 256) then
			text = string.sub(text, 0, text:len() - 2)
		else
			text = string.sub(text, 0, text:len() - 1)
		end
		value = value + 1
	until text == "" 

	return value
end

function getEditBoxText(element)
	if not element then
		return
	end

	return editBox[element].text, editBox[element].startText
end

local editBoxActive = { } -- активные поля ввода

addEventHandler("onClientGUIClick", root, function(button)
	if not button == 'left' then return end

	-- --
	for i, isEditBox in pairs(editBoxActive) do
		if editBox[isEditBox].active then

			guiStaticImageLoadImage(editBox[isEditBox].back, "assets/img/editbox.png")
			editBox[isEditBox].active = false
			guiSetVisible(editBox[isEditBox].lineActive, false)

			if editBox[isEditBox].startText and guiGetText(editBox[isEditBox].labelText):len() == 0 then
				guiSetText(editBox[isEditBox].labelText, editBox[isEditBox].startText)
			end

			if isTimer(editBox[isEditBox].lineTimer) then 
				killTimer(editBox[isEditBox].lineTimer) 
			end

			table.remove(editBoxActive, i)
		end
	end
	-- --

	if not editBox[source] then 
		return 
	end

	local source = editBox[source].back

	if editBox[source].active then 
		return
	end

	guiStaticImageLoadImage(editBox[source].back, "assets/img/editbox_active.png")
	
	if guiGetText(editBox[source].labelText) == editBox[source].startText then
		guiSetText(editBox[source].labelText, "")
	end

	guiSetPosition(editBox[source].lineActive, guiLabelGetTextExtent(editBox[source].labelText) + 12, 7, false)
	editBox[source].lineTimer = setTimer(showLineActive, 1000, 0, editBox[source].lineActive)

	editBox[source].active = true

	table.insert(editBoxActive, source)
end)

addEventHandler("onClientMouseEnter", root, function()
	if not editBox[source] then 
		return 
	end

	local source = editBox[source].back

	if editBox[source].active then 
		return 
	end

	guiStaticImageLoadImage(source, "assets/img/editbox_active.png")
end)

addEventHandler("onClientMouseLeave", root, function()
	if not editBox[source] then 
		return 
	end

	local source = editBox[source].back

	if editBox[source].active then 
		return 
	end

	guiStaticImageLoadImage(source, "assets/img/editbox.png")
end)