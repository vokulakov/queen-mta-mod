addEvent('queenHorn.breakModelChange', true)
addEventHandler('queenHorn.breakModelChange', root, function(model)
	if not source then 
		return 
	end
	outputDebugString('\nWarning! Извини, но это костыль.', 0, 170, 160, 0)
	setElementModel(source, model)
end)
