if SERVER then
AddCSLuaFile("cl_hud.lua")
AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("misc/sh_rounds.lua")
AddCSLuaFile("misc/sh_claim.lua")
AddCSLuaFile("notifications/sh_notifications.lua")
--AddCSLuaFile("modules/rounds_system/sh_rounds.lua")
--AddCSLuaFile("modules/sounds_system/sh_sounds.lua")
--AddCSLuaFile("modules/notification_system/sh_notifications.lua")
--AddCSLuaFile("modules/weapons_system/sh_weapons.lua")

include("shared.lua")
include("notifications/sh_notifications.lua")
include("misc/sh_rounds.lua")
include("misc/sh_claim.lua")
--include("modules/rounds_system/sh_rounds.lua")

function GM:Initialize()
	DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
    init_claim_system()
end

function GM:PlayerSpawn(ply)
    timer.Stop("hud_round_time_timer")
    timer.Start("hud_round_time_timer")

    if (ply:Team() == TEAM_SPECTATOR) then
        ply:Spectate(OBS_MODE_ROAMING)
        ply:StripWeapons()
        return nil
    end

    ply:SetNoCollideWithTeammates(true)
    ply:Give("weapon_crowbar")
    ply:StripWeapon("weapon_knife")

    timer.Start("check_game")

    local model = math.random(0, 20)
    if (ply:Team() == TEAM_RUNNERS) then
        if (model == 0) then
            ply:SetModel("models/player/barney.mdl")
        end

        if (model == 1) then
            ply:SetModel("models/player/alyx.mdl")
        end

        if (model == 2) then
            ply:SetModel("models/player/breen.mdl")
        end

        if (model == 3) then
            ply:SetModel("models/player/p2_chell.mdl")
        end

        if (model == 4) then
            ply:SetModel("models/player/eli.mdl")
        end

        if (model == 5) then
            ply:SetModel("models/player/gman_high.mdl")
        end

        if (model == 6) then
            ply:SetModel("models/player/kleiner.mdl")
        end

        if (model == 7) then
            ply:SetModel("models/player/monk.mdl")
        end

        if (model == 8) then
            ply:SetModel("models/player/police.mdl")
        end

        if (model == 9) then
            ply:SetModel("models/player/police_fem.mdl")
        end

        if (model == 10) then
            ply:SetModel("models/player/combine_super_soldier.mdl")
        end

        if (model == 11) then
            ply:SetModel("models/player/Group01/male_07.mdl")
        end

        if (model == 12) then
            ply:SetModel("models/player/Group01/male_09.mdl")
        end

        if (model == 13) then
            ply:SetModel("models/player/Group03m/female_05.mdl")
        end

        if (model == 14) then
            ply:SetModel("models/player/Group03m/female_06.mdl")
        end

        if (model == 15) then
            ply:SetModel("models/player/Group03m/female_03.mdl")
        end

        if (model == 16) then
            ply:SetModel("models/player/Group03m/female_02.mdl")
        end

        if (model == 17) then
            ply:SetModel("models/player/leet.mdl")
        end

        if (model == 18) then
            ply:SetModel("models/player/hostage/hostage_04.mdl")
        end

        if (model == 19) then
            ply:SetModel("models/player/Group03m/male_05.mdl")
        end

        if (model == 20) then
            ply:SetModel("models/player/Group03m/male_02.mdl")
        end

        ply:SetWalkSpeed(250)
        ply:SetRunSpeed(300)
        ply:SetJumpPower(220)
    end

    if (ply:Team() == TEAM_DEATH) then
        ply:SetModel("models/player/skeleton.mdl")
        ply:SetWalkSpeed(500)
        ply:SetRunSpeed(750)
        ply:SetJumpPower(340)
    end

    ply:SetHealth(100)

    if (ply:Team() == TEAM_DEATH) then
        -- select a random spawn point
        local deathSpawnPoints = ents.FindByClass("info_player_terrorist")
        table.insert(deathSpawnPoints, #deathSpawnPoints, ents.FindByClass("info_player_combine"))
        local randomIndex = math.Rand(1, table.Count(deathSpawnPoints))

        ply:SetPos(deathSpawnPoints[1]:GetPos())
    elseif (ply:Team() == TEAM_RUNNERS) then
        local runnersSpawnPoints = ents.FindByClass("info_player_counterterrorist")
        table.insert(runnersSpawnPoints, #runnersSpawnPoints, ents.FindByClass("info_player_rebel"))
        local randomIndex = math.Rand(1, table.Count(runnersSpawnPoints))

        ply:SetPos(runnersSpawnPoints[1]:GetPos())
    end
end

function GM:PlayerSwitchFlashlight(ply, enabled)
    if (ply:KeyPressed(IN_USE)) then
        enabled = true
        ply:Flashlight(true)
        print("Flashlight is on!")
        return true
    end
end

function GM:PlayerShouldTakeDamage(ply, attacker)
    if (ply:IsPlayer()) then
        if (!IsValid(ply) and !IsValid(attacker)) then
            return false
        end

        if (IsValid(ply) and !IsValid(attacker)) then
            return false
        end

        if (!IsValid(ply) and IsValid(attacker)) then
            return false
        end

        if (ply:IsPlayer() and attacker:IsPlayer()) then
            if (ply:Team() == attacker:Team()) then
                return false
            elseif (ply:Team() == TEAM_SPECTATOR or
                attacker:Team() == TEAM_SPECTATOR) then
                return false
            end
        end

        if (ply:Team() == TEAM_DEATH and
        attacker:IsWorld()) then
            return false
        end

        return true
    end
end

function GM:PlayerLoadout(ply)
    ply:Give("weapon_crowbar")

    return true
end

function GM:GetFallDamage(ply, speed)
	return (speed / 8)
end

function GM:CanPlayerSuicide(ply)
    if (ply:Team() == TEAM_DEATH) then
        return false
    end

    if (ply:Team() == TEAM_SPECTATOR) then
        return false
    end
end
end
