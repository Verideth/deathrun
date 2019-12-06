DEATHRUN_ADDONS = {}
include("shared.lua")

local hide = {
	["CHudBattery"] = true,
	["CHudHealth"] = true,
	["CHudAmmo"] = true,
 	["CHudCrosshair"] = true
}

concommand.Add("drf_get_team", function()
    for k, v in pairs(player.GetAll()) do
        print("Player " .. v:Nick() .. " is on team (1 = spectator, 2 = runner, 3 = death) " .. v:Team())
    end
end)

function GM:HUDPaint()
    draw_crosshair(ScrW() / 2, ScrH() / 2)
    draw_player_hud()
end

function GM:Tick()
    local ply = LocalPlayer()

    if (IsValid(ply)) then
        local ent = ply:GetEyeTraceNoCursor().Entity
        think_button_claim(ply, ent)
    end
end

hook.Add("HUDShouldDraw", "hide_hud", function(name)
	if (hide[name]) then return false end
end)

hook.Add("GetHandsModel", "hands", function()
	return { model = "models/weapons/c_arms_hev.mdl", skin = 1, body = "0100000" }
end)
