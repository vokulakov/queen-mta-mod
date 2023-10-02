local cruiseSpeedKey = "c";
local screenw, screenh = guiGetScreenSize ();

local cruiseSpeedEnabled, cruiseSpeed;

local function cruiseSpeedChecker ()
	local theVehicle = getPedOccupiedVehicle (getLocalPlayer ());
	local vX, vY, vZ = getElementVelocity (theVehicle);
	local iv = 1/math.sqrt (vX^2 + vY^2 + vZ^2);
	local mX, mY, mZ = vX * iv * cruiseSpeed, vY * iv * cruiseSpeed, vZ * iv * cruiseSpeed;
	setElementVelocity (theVehicle, mX, mY, mZ);
end;

__cruiseSpeedCollisionChecker = {};
local function cruiseSpeedCollisionChecker ()
	__cruiseSpeedCollisionChecker ();
end;



function toggleCruiseSpeed ()
	local theVehicle = getPedOccupiedVehicle (getLocalPlayer ());
	if not cruiseSpeedEnabled then
		if not getVehicleEngineState (theVehicle) then return end
		if getVehicleCurrentGear (theVehicle) == 0 then return end
		local vX, vY, vZ = getElementVelocity (theVehicle);
		cruiseSpeed = math.sqrt (vX^2 + vY^2 + vZ^2);
		if cruiseSpeed < (10/180) then return; end;
		triggerServerEvent ("queenVehicleControl.enableVehicleCruiseSpeed", theVehicle, true);
		addEventHandler ("onClientPreRender", getRootElement (), cruiseSpeedChecker);
		addEventHandler ("onClientVehicleCollision", theVehicle, cruiseSpeedCollisionChecker);

		bindKey ("accelerate", "down", toggleCruiseSpeed);
		bindKey ("brake_reverse", "down", toggleCruiseSpeed);
	else
		triggerServerEvent ("queenVehicleControl.enableVehicleCruiseSpeed",  getPedOccupiedVehicle (getLocalPlayer ()), false);
		removeEventHandler ("onClientPreRender", getRootElement (), cruiseSpeedChecker);
		removeEventHandler ("onClientVehicleCollision", getPedOccupiedVehicle (getLocalPlayer ()), cruiseSpeedCollisionChecker);

		unbindKey ("accelerate", "down", toggleCruiseSpeed);
		unbindKey ("brake_reverse", "down", toggleCruiseSpeed);
	end;
	cruiseSpeedEnabled = not cruiseSpeedEnabled;
	setElementData(theVehicle, "queenVehicle.cruiseSpeedEnabled", cruiseSpeedEnabled)
end
addEvent("queenVehicleControl.toggleCruiseSpeed", true)
addEventHandler ("queenVehicleControl.toggleCruiseSpeed", getRootElement (), toggleCruiseSpeed)

setmetatable (__cruiseSpeedCollisionChecker, {__call = function () toggleCruiseSpeed (); end});

local function onClientVehicleEnterHandler ()
	bindKey (cruiseSpeedKey, "down", toggleCruiseSpeed);
	cruiseSpeedEnabled = false;
end;

addEventHandler ("onClientVehicleEnter", getRootElement (), function (thePlayer, seat)
	if (thePlayer == getLocalPlayer ()) and (seat == 0) then onClientVehicleEnterHandler () end
end)

addEventHandler ("onClientResourceStart", getResourceRootElement (getThisResource ()), function ()
	if isPedInVehicle (getLocalPlayer()) then
		local theVehicle = getPedOccupiedVehicle (getLocalPlayer ())
		if getVehicleController (theVehicle) == getLocalPlayer () then onClientVehicleEnterHandler() end
	end
end)

addEventHandler ("onClientVehicleExit", getRootElement (), function (thePlayer, seat)
	if (thePlayer == getLocalPlayer ()) and (seat == 0) then
		unbindKey (cruiseSpeedKey, "down", toggleCruiseSpeed)
	end
end)

addEventHandler("onClientElementDestroy", getRootElement(), function ()
	if getElementType(source) == "vehicle" then
		unbindKey (cruiseSpeedKey, "down", toggleCruiseSpeed)
	end
end)