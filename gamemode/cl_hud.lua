if SERVER then print("[DRF] loaded hud interface") end

if CLIENT then
local hud_round_time = 0
local round_start_time = 540
timer_on = false

timer.Create("hud_round_time_timer", 1, round_start_time, function()
    if (timer_on == false) then
        hud_round_time = 0
        timer_on = true
    end

    if (timer_on == true) then
        hud_round_time = hud_round_time + 1
    end
end)

function draw_crosshair(x, y)
    surface.SetDrawColor(110, 25, 250, 255)

    surface.DrawRect(x, y - 9, 2, 9)
    surface.DrawRect(x, y, 2, 9)
    surface.DrawRect(x - 7, y - 1, 9, 2)
    surface.DrawRect(x, y - 1, 9, 2)
end

function draw_claim_text(ply)
    local ent = ply:GetEyeTrace().Entity

    if (ent:GetClass() == "class C_BaseEntity") then
        if (ply:KeyPressed(KEY_F)) then
            ent.is_claimed = true
            ply.claimed_ent = ent
            ent.claimed_ply = ply
        end

        if (ent.is_claimed == false) then
            surface.SetTextPos(ScrW() / 2 - 15, ScrH() / 2 - 35)
            surface.SetFont("HudHintTextLarge")
            surface.SetTextColor(Color(20, 200, 20, 255))
            surface.DrawText("UNCLAIMED BUTTON")

            surface.SetFont("HudHintTextLarge")
            surface.SetTextColor(Color(150, 100, 100, 255))
            surface.SetTextPos(ScrW() / 2 + 5, ScrH() / 2 - 35)
            surface.DrawText("(PRESS F TO CLAIM)")
        end


        if (ent.is_claimed == true and
        ent.claimed_ply == ply and
        ply.claimed_ent == ent) then
            surface.SetFont("HudHintTextLarge")
            surface.SetTextColor(Color(150, 100, 200, 255))
            surface.SetTextPos(ScrW() / 2 + 5, ScrH() / 2 - 35)
            surface.DrawText("YOU CURRENTLY OWN THIS BUTTON")
        end
    end

    if (ent.is_claimed and ent.claimed_ply != ply) then
        surface.SetTextPos(ScrW() / 2 - 15, ScrH() / 2 - 35)
        surface.SetFont("CloseCaption_Normal")
        surface.SetTextColor(Color(200, 20, 20, 255))
        surface.DrawText("CLAIMED BY ANOTHER DEATH")
    end

    return true
end

function draw_target_name(ply)
    local target = ply:GetEyeTrace().Entity

    if (target:IsPlayer()) then
        if (target != ply) then
            surface.SetTextPos(ScrW() / 2 - 15, ScrH() / 2 - 35)
            surface.SetFont("CenterPrintText")
            surface.SetTextColor(Color(255, 255, 255, 255))
            surface.DrawText(target:Nick())
        end
    end
end

function draw_player_hud()
    -- backdrop
    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(10, ScrH() - 110, 402, 97)

    -- health
    local w = 385 -- base width

    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(16, ScrH() - 103, 391, 40)

    surface.SetDrawColor(20, 20, 20, 255)
    surface.DrawRect(19, ScrH() - 99, w, 33)

    surface.SetDrawColor(255, 20, 20, 255)
    surface.DrawRect(19, ScrH() - 99, w * (LocalPlayer():Health() / 100), 33)

    surface.SetDrawColor(255, 150, 150, 255)
    surface.DrawRect(19, ScrH() - 99, w * (LocalPlayer():Health() / 100), 13)

    local text_health = string.format("HEALTH %iHP", LocalPlayer():Health())
    surface.SetTextPos(26, ScrH() - 94)
    surface.SetFont("ScoreboardDefault")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText(text_health)

    -- velocity
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(16, ScrH() - 60, 166, 40)

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(19, ScrH() - 57, 160, 34)

    local text_vel = string.format("SPEED %iU/S", LocalPlayer():GetVelocity():Length())
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
    surface.DrawText(LocalPlayer():GetName())

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
    surface.DrawText("TIME REMAINING: " .. (round_start_time - hud_round_time))

    -- view player box
    draw_target_name(LocalPlayer())

    -- deathrun claim
    draw_claim_text(LocalPlayer())
end
end
