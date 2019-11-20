GM.Name = "Deathrun"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

TEAM_RUNNERS = 2
TEAM_DEATH = 3

function GM:CreateTeams()
    team.SetUp(TEAM_SPECTATOR, "Spectator", Color(100, 100, 100, 200), false)
    team.SetUp(TEAM_RUNNERS, "Runners", Color(100, 100, 220, 255), false)
    team.SetUp(TEAM_DEATH, "Death", Color(220, 100, 100, 255), false)

    team.SetSpawnPoint(TEAM_RUNNERS, "info_player_counterterrorist")
    team.SetSpawnPoint(TEAM_DEATH, "info_player_terrorist")
    team.SetSpawnPoint(TEAM_SPECTATOR, "worldspawn")
end

function GM:PhysgunPickup(ply, entity)
    if (not ply:IsSuperAdmin()) then
        return false
    end

    if (not IsValid(entity)) then
        return false
    end

    if (not entity:IsWeapon()) then
        return false
    end

    return true
end

function GM:PlayerNoClip(ply, state)
    if not ply:IsAdmin() then
        return false
    else
        return true
    end
end

function GM:PlayerUse(ply, ent)
    if (ply:Alive() == false) then
        return false
    end

    if (ent:IsValid() == nil) then
        return false
    end

    return true
end
