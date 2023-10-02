local activePosition = getLocalPlayer()

function mypos ()
	local x, y, z = getElementPosition(activePosition)
	setClipboard("{x = "..x..", y = "..y..", z = "..z.."},")
	outputChatBox(( "Позиция скопирована в буфер обмена: \n#FFFFFF"..x..", "..y..", "..z.." "), 0, 255, 0, true)
end
addCommandHandler ("pos", mypos)