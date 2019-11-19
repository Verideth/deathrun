if SERVER then
    return false
end

if CLIENT then
include("shared.lua")
include("drf_draw.lua")
include("cl_hud.lua")

local hide = {
	["CHudBattery"] = true,
	["CHudHealth"] = true,
	["CHudAmmo"] = true,
    ["CHudCrosshair"] = true
}

local root = GM.FolderName .. "/gamemode/modules/"
local _, folders = file.Find(root .. "*", "LUA")

for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(root .. folder .. "/sh_*.lua", "LUA"), true) do
        include(root .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(root .. folder .. "/cl_*.lua", "LUA"), true) do
        include(root .. folder .. "/" .. File)
    end
end

concommand.Add("drf_hide_crosshair", function()
    drf_hud.should_draw_crosshair = false
end)

concommand.Add("drf_show_crosshair", function()
    drf_hud.should_draw_crosshair = true
end)

function GM:HUDPaint()
    draw_crosshair(ScrW() / 2, ScrH() / 2)
    draw_player_hud()
end

hook.Add("HUDShouldDraw", "hide_hud", function(name)
	if (hide[name]) then return false end
end)
end
