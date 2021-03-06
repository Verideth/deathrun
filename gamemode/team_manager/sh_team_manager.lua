DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table

-- cleanup derma objects.
if (DEATHRUN_ADDONS.TeamManager != nil) then
    if ( DEATHRUN_ADDONS.TeamManager.CleanUp != nil) then
        DEATHRUN_ADDONS.TeamManager.CleanUp()
    end
end

DEATHRUN_ADDONS.TeamManager = {}

if SERVER then

    util.AddNetworkString("deathrunRequestSwitchToDeath")
    util.AddNetworkString("deathrunRequestSwitchToRunners")

    net.Receive("deathrunRequestSwitchToDeath", function(len, ply)
        DEATHRUN_ADDONS.TeamManager.SwitchToDeath(ply)
    end)

    net.Receive("deathrunRequestSwitchToRunners", function(len, ply)
        DEATHRUN_ADDONS.TeamManager.SwitchToRunners(ply)
    end)

    DEATHRUN_ADDONS.TeamManager.CleanUp = function()

    end

    DEATHRUN_ADDONS.TeamManager.PlayerSpawned = function(ply)
        if (ply:Team() == TEAM_SPECTATOR) then
            ply:Spectate(OBS_MODE_ROAMING)
            ply:StripWeapons()
            return
        end

        --[[
            This section of code assigned the person to the correct team
        ]]

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
                -- the number of death players has been reached, this player can now be a runner.
                ply:SetTeam(TEAM_RUNNERS)
                DEATHRUN_ADDONS.Notify.NotifyAll(ply:Nick() .. " has joined the Runners team!", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
            end
        end


        --[[
            This section of code makes the player spawn with given things.
        ]]
    end

    DEATHRUN_ADDONS.TeamManager.PlayerDeath = function(ply)
        ply:SetTeam(TEAM_SPECTATOR)
        ply:Spawn()
    end
    
    DEATHRUN_ADDONS.TeamManager.SwitchToDeath = function(ply)
        if (ply:Team() == TEAM_DEATH) then
            DEATHRUN_ADDONS.Notify.Notify(ply, "You are on this team", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
            return
        end

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

    DEATHRUN_ADDONS.TeamManager.SwitchToRunners = function(ply)
        if (ply:Team() == TEAM_RUNNERS) then
            DEATHRUN_ADDONS.Notify.Notify(ply, "You are on this team", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
            return
        end

        ply:SetTeam(TEAM_RUNNERS)
        DEATHRUN_ADDONS.Notify.NotifyAll(ply:Nick() .. " has joined the Runners team!", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
            
    end
    
elseif CLIENT then

    DEATHRUN_ADDONS.TeamManager.CleanUp = function()

    end

    DEATHRUN_ADDONS.TeamManager.SwitchToDeath = function()
        net.Start("deathrunRequestSwitchToDeath")
        net.SendToServer()
    end

    DEATHRUN_ADDONS.TeamManager.SwitchToRunners = function()
        net.Start("deathrunRequestSwitchToRunners")
        net.SendToServer()
    end

    DEATHRUN_ADDONS.TeamManager.GetQMenuDermaPanel = function(pDermaSheet)
        local qMenuPanel = vgui.Create("DScrollPanel", pDermaSheet)
        qMenuPanel:Dock(FILL)

        local buttonList = vgui.Create( "DIconLayout", qMenuPanel )
        buttonList:Dock( FILL )
        buttonList:SetSpaceY( 5 ) -- Sets the space in between the panels on the Y Axis by 5
        buttonList:SetSpaceX( 5 ) -- Sets the space in between the panels on the X Axis by 5

        local deathsButton = buttonList:Add( "DButton" ) -- Add DPanel to the DIconLayout
        deathsButton:SetText( "Deaths" )
        deathsButton:Dock(TOP)
        deathsButton.DoClick = function()				// A custom function run when clicked ( note the . instead of : )
            DEATHRUN_ADDONS.TeamManager.SwitchToDeath()
        end

        local runnersButton = buttonList:Add( "DButton" ) -- Add DPanel to the DIconLayout
        runnersButton:SetText( "Runners" )
        runnersButton:Dock(TOP)
        runnersButton.DoClick = function()
            DEATHRUN_ADDONS.TeamManager.SwitchToRunners()
        end

        return qMenuPanel
    end

    DEATHRUN_ADDONS.TeamManager.GetQMenuButtonInfo = function()
        return { ButtonName = "Change Team", IconName = "icon16/tick.png" }
    end

end