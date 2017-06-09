local SpinCamRunning, CameraDistanceMax;
SpinCamData = SpinCamData or {};
---------------------------------------------------------------------------
SlashCmdList["SPINCAM"] = function(msg)
	local msg = string.lower(msg)
	local cmd,arg1 = strsplit(" ",msg);
	if (arg1 ~= "on") and (arg1 ~= "off") then
		if (SpinCamData.Disable) then arg1 = "on"; else arg1 = "off"; end
	end
	if (arg1 == "on") then
		SpinCamData.Disable = nil;
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SpinCam|r: Feature Enabled");
	elseif (arg1 == "off") then
		SpinCamData.Disable = true;
		DEFAULT_CHAT_FRAME:AddMessage("|cff33ff99SpinCam|r: Feature Disabled");
	end
	if (SpinCamData.Disable) and (SpinCamRunning) then
		MoveViewRightStop();
		SetCVar("cameraYawMoveSpeed","230");
		SetCVar("cameraDistanceMax",CameraDistanceMax or 200);
		SetView(5);
	end
end;
SLASH_SPINCAM1 = "/spincam";
---------------------------------------------------------------------------
function strsplit(delim, str, maxNb, onlyLast)
	-- Eliminate bad cases...
	if string.find(str, delim) == nil then
		return { str }
	end
	if maxNb == nil or maxNb < 1 then
		maxNb = 0
	end
	local result = {}
	local pat = "(.-)" .. delim .. "()"
	local nb = 0
	local lastPos
	for part, pos in string.gfind(str, pat) do
		nb = nb + 1
		result[nb] = part
		lastPos = pos
		if nb == maxNb then break end
	end
	-- Handle the last field
	if nb ~= maxNb then
		result[nb+1] = string.sub(str, lastPos)
	end
	if onlyLast then
		return result[nb+1]
	else
		return result[1], result[2]
	end
end
---------------------------------------------------------------------------
SetCVar("cameraYawMoveSpeed","230");
local frame = CreateFrame("Frame");
frame:RegisterEvent("CHAT_MSG_SYSTEM");
frame:RegisterEvent("PLAYER_ENTERING_WORLD");
frame:SetScript("OnEvent",function()
	if event == "CHAT_MSG_SYSTEM" then
		if (arg1 == format(MARKED_AFK_MESSAGE,DEFAULT_AFK_MESSAGE)) and (not SpinCamData.Disable) then
			SetCVar("cameraYawMoveSpeed","8");
			MoveViewRightStart();
			SpinCamRunning = true;
			SetView(5);
		elseif (arg1 == CLEARED_AFK) and (SpinCamRunning) then
			MoveViewRightStop();
			SetCVar("cameraYawMoveSpeed","230");
			SpinCamRunning = nil;
			SetView(5);
		end
	elseif event == "PLAYER_LEAVING_WORLD" then
		if (SpinCamRunning) then
			MoveViewRightStop();
			SetCVar("cameraYawMoveSpeed","230");
			SpinCamRunning = nil;
			SetView(5);
		end
	end
end);
---------------------------------------------------------------------------
if (IsAddOnLoaded("SpartanUI")) then
	local options = LibStub("AceAddon-2.0"):GetAddon("SpartanUI").options;
	options.args["spincam"] = {
		type = "input",
		name = "Toggle SpinCam",
		desc = "Toggles SpinCam on and off",
		set = function(info,val)
			if val then val = " "..val; end
			SlashCmdList["SPINCAM"]("spincam"..val);
		end
	};
end
