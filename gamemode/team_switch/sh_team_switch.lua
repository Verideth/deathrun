DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table

-- cleanup derma objects.
if (DEATHRUN_ADDONS.TeamSwitch != nil) then
    if ( DEATHRUN_ADDONS.TeamSwitch.CleanUp != nil) then
        DEATHRUN_ADDONS.TeamSwitch.CleanUp()
    end
end

DEATHRUN_ADDONS.TeamSwitch = {}

if SERVER then

    util.AddNetworkString("deathrunRequestSwitchToDeath")
    util.AddNetworkString("deathrunRequestSwitchToRunners")

    net.Receive("deathrunRequestSwitchToDeath", function(len, ply)
        DEATHRUN_ADDONS.TeamSwitch.SwitchToDeath(ply)
    end)

    net.Receive("deathrunRequestSwitchToRunners", function(len, ply)
        DEATHRUN_ADDONS.TeamSwitch.SwitchToRunners(ply)
    end)


    DEATHRUN_ADDONS.TeamSwitch.CleanUp = function()

    end

    DEATHRUN_ADDONS.TeamSwitch.SwitchToDeath = function(ply)
        if (ply:GetTeam() == TEAM_DEATH) then return end

        -- Select the correct team for a player that has just spawned.
        local deathPlayers = team.GetPlayers(TEAM_DEATH)
        local runnerPlayers = team.GetPlayers(TEAM_RUNNERS)

        -- to play a game, there must be at least 1 death player.
        local numberOfDeathPlayers = table.Count(deathPlayers)
        local numberOfRunnerPlayers = table.Count(runnerPlayers)

        if (numberOfDeathPlayers < 1) then
            -- this player who spawned, must go to the deaths team since nobody is in it.
            ply:SetTeam(TEAM_DEATH)
            DEATHRUN_ADDONS.Notify.NotifyAll(ply:Nick() .. " has joined the Death team!", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
        else
            -- there must be 1 death for every 5 players.
            -- number of deaths = number of players / 5
            local maxNumberOfDeathPlayers = math.Round(numberOfRunnerPlayers / 5)
            if (maxNumberOfDeathPlayers == 0) then maxNumberOfDeathPlayers = 1 end

            -- if we need 2 death players, but we currently have 1, force this player to join the death team.
            if (maxNumberOfDeathPlayers > numberOfDeathPlayers) then
                ply:SetTeam(TEAM_DEATH)
                DEATHRUN_ADDONS.Notify.NotifyAll(ply:Nick() .. " has joined the Death team!", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
            else
                DEATHRUN_ADDONS.Notify.Notify(ply, "Death team is full.", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
            end
        end
    end

    DEATHRUN_ADDONS.TeamSwitch.SwitchToRunners = function(ply)
        if (ply:GetTeam() == TEAM_RUNNERS then return end

        ply:SetTeam(TEAM_RUNNERS)
    end
    
elseif CLIENT then

    DEATHRUN_ADDONS.TeamSwitch.CleanUp = function()

    end

    DEATHRUN_ADDONS.TeamSwitch.SwitchToDeath = function()
        net.Start("deathrunRequestSwitchToDeath")
        net.SendToServer()
    end

    DEATHRUN_ADDONS.TeamSwitch.SwitchToRunners = function()
        net.Start("deathrunRequestSwitchToRunners")
        net.SendToServer()
    end

    DEATHRUN_ADDONS.TeamSwitch.GetQMenuSheet = function()

    end

    DEATHRUN_ADDONS.TeamSwitch.GetQMenuSheetButtonInfo = function()
    end

end