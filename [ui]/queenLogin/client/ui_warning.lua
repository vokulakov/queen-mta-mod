UI.warning = { }

UI.warning.bg = guiCreateStaticImage(sx/2-307/2, 30, 307, 60, "assets/img/warning.png", false)

UI.warning.info = guiCreateLabel(0, 15, 307, 20, "ОШИБКА!", false, UI.warning.bg)
guiSetFont(UI.warning.info, UI_FONTS['LOGIN_B_9'])
guiLabelSetColor(UI.warning.info, 80, 80, 80)
guiLabelSetHorizontalAlign(UI.warning.info, "center")

UI.warning.text = guiCreateLabel(0, 35, 307, 20, "", false, UI.warning.bg)
guiSetFont(UI.warning.text, UI_FONTS['LOGIN_M_9'])
guiLabelSetColor(UI.warning.text, 80, 80, 80)
guiLabelSetHorizontalAlign(UI.warning.text, "center")

guiSetVisible(UI.warning.bg, false)

function showWarningBox(text)
	if guiGetVisible(UI.warning.bg) then 
		return 
	end
	
	if isElement(UI.warning.sound) then
		stopSound(UI.warning.sound)
		UI.warning.sound = nil
	end

	UI.warning.sound = exports["queenSounds"]:playSound("error", false)
	setSoundVolume(UI.warning.sound, 0.5)

	guiSetVisible(UI.warning.bg, true)
	guiSetText(UI.warning.text, text)

	setTimer(guiSetVisible, 3000, 1, UI.warning.bg, false)
end
addEvent("queenLogin.isWarning", true)
addEventHandler("queenLogin.isWarning", root, showWarningBox)

--setTimer(showWarningBox, 5000, 1, "Такой акканут уже существует")