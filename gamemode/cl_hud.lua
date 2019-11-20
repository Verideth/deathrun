local hud_round_time = 0

function draw_crosshair(x, y)
    surface.SetDrawColor(110, 25, 250, 255)

    surface.DrawRect(x, y - 9, 2, 9)
    surface.DrawRect(x, y, 2, 9)
    surface.DrawRect(x - 7, y - 1, 9, 2)
    surface.DrawRect(x, y - 1, 9, 2)
end

function draw_target_name(ply)
    local target = ply:GetEyeTrace().Entity

    if (IsValid(target) and target:Alive() and target != ply) then
        surface.SetTextPos(ScrW() / 2 - 15, ScrH() / 2 - 35)
        surface.SetFont("CenterPrintText")
        surface.SetTextColor(Color(255, 255, 255, 255))
        surface.DrawText(target:Nick())
    end
end

function draw_player_hud()
    local ply = LocalPlayer()

    -- backdrop
    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(10, ScrH() - 110, 402, 97)

    -- health
    local w = 385 -- base width

    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(16, ScrH() - 103, 391, 40)

    surface.SetDrawColor(20, 20, 20, 255)
    surface.DrawRect(19, ScrH() - 99, w, 32)

    surface.SetDrawColor(255, 20, 20, 255)
    surface.DrawRect(19, ScrH() - 99, w * (ply:Health() / 100), 33)

    surface.SetDrawColor(255, 150, 150, 255)
    surface.DrawRect(19, ScrH() - 99, w * (ply:Health() / 100), 13)

    local text_health = string.format("HEALTH %iHP", ply:Health())
    surface.SetTextPos(26, ScrH() - 97)
    surface.SetFont("ScoreboardDefault")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText(text_health)

    -- velocity
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(16, ScrH() - 60, 166, 40)

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(19, ScrH() - 57, 160, 34)

    local text_vel = string.format("SPEED %iU/S", ply:GetVelocity():Length())
    surface.SetTextPos(26, ScrH() - 52 )
    surface.SetFont("ScoreboardDefault")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText(text_vel)

    -- player info
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(187, ScrH() - 60, 220, 40)

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(190, ScrH() - 57, 214, 34)

    surface.SetTextPos(194, ScrH() - 55)
    surface.SetFont("ChatFont")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText(ply:GetName())

    surface.SetTextPos(194, ScrH() - 40)
    surface.SetFont("ChatFont")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText(game.GetMap())

    -- round time
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(ScrW() / 2 - 103, 15, 220, 20)

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(ScrW() / 2 - 100, 17, 214, 16)

    surface.SetTextPos(ScrW() / 2 - 68, 18)
    surface.SetFont("HudHintTextLarge")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText("TIME REMAINING: " .. hud_round_time)

    -- view player box
    draw_target_name(ply)
end
