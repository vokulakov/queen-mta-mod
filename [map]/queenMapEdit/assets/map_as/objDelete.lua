addEventHandler("onResourceStart", resourceRoot, function()
	createObject(7476, -2053.5, -210, 34.34, 0, 0, 90)		-- Объект трассы автошколы
	removeWorldModel(11099, 100, -2056.99, -184.547, 34.4141) -- Следы автошкола

	--removeWorldModel(11012, 100, -2166.87, -236.508, 40.8672)	-- Здание завода у автошколы
	--removeWorldModel(11270, 100, -2166.87, -236.508, 40.8672)	-- Здание завода у автошколы (LOD)
end)