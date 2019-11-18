GM.Name = "Deathrun"
GM.Author = "N/A"
GM.Email = "N/A"
GM.Website = "N/A"

function GM:Initialize()

end

function GM:CreateTeams()
    TEAM_RUNNERS = 1
    team.SetUp(TEAM_RUNNERS, "Runners", Color(100, 255, 100, 255), false)
    team.SetSpawnPoint(TEAM_RUNNERS, "info_player_counterterrorist")

    TEAM_DEATH = 2
    team.SetUp(TEAM_DEATH, "Death", Color(255, 100, 100, 255), false)
    team.SetSpawnPoint(TEAM_DEATH, info_player_terrorist)

    team.SetUp(3, "Spectator", Color(100, 100, 100, 200), false)
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
