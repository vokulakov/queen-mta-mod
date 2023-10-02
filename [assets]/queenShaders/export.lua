function createShader(name, ... )
	local element = dxCreateShader("assets/"..name, ...)
	if not element then 
		return false
	end
	return element
end

-- НЕОБХОДИМО СДЕЛАТЬ ОЧИСТКУ!