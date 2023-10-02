function createFontDX(name, ...)
	local element = dxCreateFont("assets/"..tostring(name), ...)
	return element	
end

function createFontGUI(name, ...)
	local element = guiCreateFont("assets/"..tostring(name), ...)
	return element
end

-- НЕОБХОДИМО СДЕЛАТЬ ОЧИСТКУ!