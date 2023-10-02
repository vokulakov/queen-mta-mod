local texturesimg = {
	{"assets/Flare.png", "coronastar"},
	{"assets/4.png", "headlight1"},
	{"assets/5.png", "headlight"},
	--{"assets/on.png", "vehiclelightson128"},
}


addEventHandler("onClientResourceStart", resourceRoot, function()
	for i = 1, #texturesimg do
		local shader = exports.queenShaders:createShader("texreplace.fx")
		engineApplyShaderToWorldTexture(shader, texturesimg[i][2])
		dxSetShaderValue(shader, "TEXTURE_REMAP", dxCreateTexture(texturesimg[i][1]))
	end
end)
