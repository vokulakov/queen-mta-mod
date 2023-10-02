local screenX, screenY = guiGetScreenSize()

local INFO = guiCreateLabel(screenX-205, screenY-30, 200, 20, MOD_INFO, false)
guiLabelSetHorizontalAlign(INFO, "right")
guiLabelSetColor (INFO, 200, 200, 200)