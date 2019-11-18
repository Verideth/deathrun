AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("drf_draw.lua")
AddCSLuaFile("sounds_loader.lua")

include("shared.lua")

function GM:PlayerInitialSpawn(ply)

end

function GM:PlayerSpawn(ply)
    if (ply:Team() == TEAM_SPECTATOR) then
        ply:Spectate(OBS_MODE_ROAMING)
        ply:StripWeapons()
        ply:SetWalkSpeed(300)
        ply:SetRunSpeed(1000)
        return nil
    end

    ply:Give("weapon_crowbar")

    local team = math.random(1, 2)
    if (team == 1) then
        ply:SetTeam(TEAM_RUNNERS)
    end

    if (team == 2) then
        ply:SetTeam(TEAM_DEATH)
    end

    if (ply:Team() == TEAM_RUNNERS) then
        if (math.random(0, 20) == 0) then
            ply:SetModel("models/player/barney.mdl")
        end

        if (math.random(0, 20) == 1) then
            ply:SetModel("models/player/alyx.mdl")
        end

        if (math.random(0, 20) == 2) then
            ply:SetModel("models/player/breen.mdl")
        end

        if (math.random(0, 20) == 3) then
            ply:SetModel("models/player/p2_chell.mdl")
        end

        if (math.random(0, 20) == 4) then
            ply:SetModel("models/player/eli.mdl")
        end

        if (math.random(0, 20) == 5) then
            ply:SetModel("models/player/gman_high.mdl")
        end

        if (math.random(0, 20) == 6) then
            ply:SetModel("models/player/kleiner.mdl")
        end

        if (math.random(0, 20) == 7) then
            ply:SetModel("models/player/monk.mdl")
        end

        if (math.random(0, 20) == 8) then
            ply:SetModel("models/player/police.mdl")
        end

        if (math.random(0, 20) == 9) then
            ply:SetModel("models/player/police_fem.mdl")
        end

        if (math.random(0, 20) == 10) then
            ply:SetModel("models/player/combine_super_soldier.mdl")
        end

        if (math.random(0, 20) == 11) then
            ply:SetModel("models/player/Group01/male_07.mdl")
        end

        if (math.random(0, 20) == 12) then
            ply:SetModel("models/player/Group01/male_09.mdl")
        end

        if (math.random(0, 20) == 13) then
            ply:SetModel("models/player/Group03m/female_05.mdl")
        end

        if (math.random(0, 20) == 14) then
            ply:SetModel("models/player/Group03m/female_06.mdl")
        end

        if (math.random(0, 20) == 15) then
            ply:SetModel("models/player/Group03m/female_03.mdl")
        end

        if (math.random(0, 20) == 16) then
            ply:SetModel("models/player/Group03m/female_02.mdl")
        end

        if (math.random(0, 20) == 17) then
            ply:SetModel("models/player/leet.mdl")
        end

        if (math.random(0, 20) == 18) then
            ply:SetModel("models/player/hostage/hostage_04.mdl")
        end

        if (math.random(0, 20) == 19) then
            ply:SetModel("models/player/Group03m/male_05.mdl")
        end

        if (math.random(0, 20) == 20) then
            ply:SetModel("models/player/Group03m/male_02.mdl")
        end

        ply:SetWalkSpeed(250)
        ply:SetRunSpeed(60)
        ply:SetJumpPower(250)
    end

    if (ply:Team() == TEAM_DEATH) then
        ply:SetModel("models/player/skeleton.mdl")
        ply:SetWalkSpeed(500)
        ply:SetRunSpeed(750)
        ply:SetJumpPower(500)
    end

    ply:SetHealth(100)
end

function GM:PlayerLoadout(ply)
    ply:Give("weapon_crowbar")

    return true
end
