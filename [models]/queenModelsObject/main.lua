local objects = {
	{id = 7476, txd = "assets/autoschool_sf.txd", dff = "assets/autoschool_sf.dff", col = "assets/autoschool_sf.col"}, 
	--{id = 1806, txd = "assets/triangle.txd", dff = "assets/triangle.dff", col = "assets/triangle.col"},
	--{id = 1337, txd = "assets/paint_garage.txd", dff = "assets/paint_garage.dff", col = "assets/paint_garage.col"},
	--{id = 1860, txd = "assets/tun_garage.txd", dff = "assets/tun_garage.dff", col = "assets/tun_garage.col"},
}

addEventHandler ( 'onClientResourceStart', resourceRoot, function () 
	for _, v in ipairs(objects) do
	    local txd = engineLoadTXD (v.txd)
        engineImportTXD (txd, v.id)

        local dff = engineLoadDFF (v.dff, 0)
        engineReplaceModel (dff, v.id)
  
        local col = engineLoadCOL (v.col)
        engineReplaceCOL (col, v.id)
	end
end) 