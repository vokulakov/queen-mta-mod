function staticImage(name, ...)
	return GuiStaticImage(name, ...)
end

function createTexture(name, ...)
	local element = dxCreateTexture(name, ...)
	return element
end

-- НЕОБХОДИМО СДЕЛАТЬ ОЧИСТКУ! 