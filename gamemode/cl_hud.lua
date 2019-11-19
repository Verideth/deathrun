surface.CreateFont("fdr_futuristic", {
    font = "NeuropolXRg-Regular",
    size = 64,
    weight = 700,
    antialias = true
})

surface.CreateFont("fdr_futuristic_outline", {
    font = "NeuropolXRg-Regular",
    size = 65,
    weight = 700,
    antialias = true
})

surface.CreateFont("fdr_hud_text", {
    font = "Domotika Trial Heavy",
    size = 12,
    weight = 700,
    antialias = true
})

function draw_crosshair(x, y)
    surface.SetDrawColor(180, 255, 180, 255)

    surface.DrawRect(x, y - 9, 2, 9)
    surface.DrawRect(x, y   , 2, 9)
    surface.DrawRect(x - 7, y - 1, 9, 2)
    surface.DrawRect(x, y - 1, 9, 2)
end

function draw_target_name()

end

function draw_player_hud()
    local ply = LocalPlayer()

    -- backdrop
    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(10, ScrH() - 110, 402, 97)

    -- health
    local w = 385 -- base width

    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(16, ScrH() - 103, 391, 38)

    surface.SetDrawColor(20, 20, 20, 255)
    surface.DrawRect(19, ScrH() - 101, w, 33)

    surface.SetDrawColor(255, 20, 20, 255)
    surface.DrawRect(19, ScrH() - 101, w * (ply:Health() / 100), 33)

    surface.SetDrawColor(255, 150, 150, 255)
    surface.DrawRect(19, ScrH() - 101, w * (ply:Health() / 100), 13)

    local text_health = string.format("HEALTH %iHP", ply:Health())
    surface.SetTextPos(21, ScrH() - 101)
    surface.SetFont("ScoreboardDefault")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText(text_health)

    -- velocity
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(16, ScrH() - 60, 166, 40)

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(19, ScrH() - 57, 160, 34)

    local text_vel = string.format("SPEED = %i u/s", ply:GetVelocity():Length())
    surface.SetTextPos(22, ScrH() - 52  )
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
end
