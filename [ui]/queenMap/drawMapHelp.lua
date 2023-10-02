MapHelp = {}

local isHelpPanel

function MapHelp.drawHelpButton()
	local HELP_PANEL = exports.queenNotification:drawRectangle(mW-460+25, screenH-MAP_MARGIN-35, 460, 30, 0.7, true)
	
	local HELP_MOVE_L = exports.queenNotification:drawHelpButton(mW-435, screenH-MAP_MARGIN-35, 0, "Перемещение", 12, 0, "mouse_left")
	setElementParent(HELP_MOVE_L, HELP_PANEL)

	local HELP_ZOOM_L = exports.queenNotification:drawHelpButton(mW-290, screenH-MAP_MARGIN-35, 0, "Масштаб", 12, 0, "mouse_wheel")
	setElementParent(HELP_ZOOM_L, HELP_PANEL)

	local HELP_LEGEND_L = exports.queenNotification:drawHelpButton(mW-177, screenH-MAP_MARGIN-35, 0, "Легенда", 12, 0, "b_space")
	setElementParent(HELP_LEGEND_L, HELP_PANEL)

	local HELP_CLOSE_L = exports.queenNotification:drawHelpButton(mW-73, screenH-MAP_MARGIN-35, 0, "Закрыть", 12, 0, "b_f11")
	setElementParent(HELP_CLOSE_L, HELP_PANEL)

	isHelpPanel = HELP_PANEL
end

function MapHelp.setVisible(isVisible)
	if isVisible then
		MapHelp.drawHelpButton()
		return
	end

	if not isHelpPanel then
		return
	end

	destroyElement(isHelpPanel)
end