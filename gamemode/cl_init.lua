if SERVER then
end

if CLIENT then
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("misc/sh_rounds.lua")
AddCSLuaFile("misc/sh_claim.lua")
AddCSLuaFile("notifications/sh_notifications.lua")

include("shared.lua")
include("misc/sh_claim.lua")
include("cl_hud.lua")

local hide = {
	["CHudBattery"] = true,
	["CHudHealth"] = true,
	["CHudAmmo"] = true,
    ["CHudCrosshair"] = true
}

function GM:HUDPaint()
    draw_crosshair(ScrW() / 2, ScrH() / 2)
    draw_player_hud()
end

function GM:Think()

end

hook.Add("HUDShouldDraw", "hide_hud", function(name)
	if (hide[name]) then return false end
end)
end
