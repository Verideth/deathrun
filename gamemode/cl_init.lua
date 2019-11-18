if SERVER then
    return false
end

if CLIENT then
include("shared.lua")
include("drf_draw.lua"
include("bams_scripts.lua"))

surface.CreateFont("fdr_futuristic", {
    font = "NeuropolXRg-Regular",
    size = 32,
    weight = 700,
    antialias = true
})

surface.CreateFont("fdr_hud_text", {
    font = "Domotika Trial Heavy",
    size = 12,
    weight = 700,
    antialias = true
})

function GM:HUDPaint()
    local ply = LocalPlayer()
    local ob = ply:GetObserverTarget()

    if (ob:IsPlayer()) then
        if (ply:Team() ~= TEAM_SPECTATOR and
        ob:IsAlive() and
        ob:IsPlayer() and
        IsValid(ob)) then
            if (ob:Team() == TEAM_RUNNERS) then
                drf_draw.draw_simple_text2d(ob:GetName(),
                Color(100, 100, 220, 255),
                800,
                800)
            end

            if (ob:Team() == TEAM_DEATH) then
                drf_draw.draw_simple_text2d(ob:GetName(),
                Color(220, 100, 100, 255),
                800,
                800)
            end
        end
    end

    if (ply:Team() == TEAM_RUNNERS) then
        drf_draw.draw_future_text2d("RUNNERS",
        Color(100, 100, 220, 255),
        200,
        200)
    end

    if (ply:Team() == TEAM_DEATH) then
        drf_draw.draw_future_text2d("DEATH",
        Color(220, 100, 100, 255),
        200,
        200)
    end
end
end
