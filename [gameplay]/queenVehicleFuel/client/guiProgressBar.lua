guiProgressBar = { }

local sW, sH = guiGetScreenSize()
local isProgressBarActive 

function guiProgressBar.createProgressBar(x, y, scroll, parent)
	local back = guiCreateStaticImage(x, y, 383, 44, "assets/img/gui_bar.png", false, parent)
	guiSetEnabled(back, false)

	guiProgressBar[back] = { }
	guiProgressBar[back].scroll = scroll
	guiProgressBar[back].x = x
	guiProgressBar[back].y = y
	guiProgressBar[back].active = false

	guiProgressBar[back].roundLeft = guiCreateStaticImage(x+10, y+3, 7, 17, "assets/img/gui_bar_active_left.png", false, parent)
	guiSetEnabled(guiProgressBar[back].roundLeft, false)

	guiProgressBar[back].activeLine = guiCreateStaticImage(x+17, y+6, scroll, 10, "assets/img/pane.png", false, parent)
	guiSetProperty(guiProgressBar[back].activeLine, "ImageColours", "tl:ffffa800 tr:ffffa800 bl:ffffa800 br:ffffa800")
	guiSetEnabled(guiProgressBar[back].activeLine, false)

	guiProgressBar[back].round = guiCreateStaticImage(x+8, y-3, 26, 26, "assets/img/gui_bar_round.png", false, parent)
	guiProgressBar[guiProgressBar[back].round] = {progressBar = back} -- костыль
	guiProgressBar[back].round:setData('queenSounds.UI', 'ui_change') -- звук клика
	
	guiProgressBar.setProgress(back, scroll)

	return back
end

function guiProgressBar.setProgress(progressBar, progress)
	if not guiProgressBar[progressBar] then
		return
	end

	-- от 0 до 340
	local value = 340/100*progress

	guiSetPosition(guiProgressBar[progressBar].round, value+26-8, guiProgressBar[progressBar].y-3, false)
	guiSetSize(guiProgressBar[progressBar].activeLine, value, 10, false)

	-- --
	UI.updateFuelingInfo(progress)
	-- --

	guiProgressBar[progressBar].scroll = progress
end

function guiProgressBar.getProgress(progressBar)
	if not guiProgressBar[progressBar] then
		return
	end

	return tonumber(guiProgressBar[progressBar].scroll)
end

local function setProgressBarProgress(_, _, xMove)
	if not isElement(isProgressBarActive) or not guiProgressBar[isProgressBarActive] then 
		return 
	end

	if not guiProgressBar[isProgressBarActive].active then
		return
	end

	local scrollPosition = Vector2(guiGetPosition(guiProgressBar[isProgressBarActive].round, false))

	if xMove >= sW/2-400/2 and xMove <= sW/2+400/2 then

		local value = math.floor(((xMove-(sW/2)+170)/340)*100)
 		if value <= 0 then value = 0
 		elseif value >= 100 then value = 100
 		end

		guiProgressBar.setProgress(isProgressBarActive, value)
	end

end

local function onClientGUIMouseUp(button, state)
	if not isElement(isProgressBarActive) or not guiProgressBar[isProgressBarActive] then 
		return 
	end

	if button == "left" and state == "up" then

		if guiProgressBar[isProgressBarActive].active then
			guiProgressBar[isProgressBarActive].active = false
			isProgressBarActive = nil

			removeEventHandler("onClientCursorMove", root, setProgressBarProgress)
			removeEventHandler("onClientClick", root, onClientGUIMouseUp)
		end
	end
end

addEventHandler("onClientGUIMouseDown", root, function(button)
	if not guiProgressBar[source] then 
		return 
	end

	if not guiProgressBar[source].progressBar then
		return
	end

	local progressBar = guiProgressBar[source].progressBar

	if button == "left" then
		if not guiProgressBar[progressBar].active then
			guiProgressBar[progressBar].active = true
			isProgressBarActive = progressBar

			addEventHandler("onClientCursorMove", root, setProgressBarProgress)
			addEventHandler("onClientClick", root, onClientGUIMouseUp)
		end
	end
end)