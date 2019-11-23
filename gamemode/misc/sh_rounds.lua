print("[DRF] loaded new round system")

DRF_CURRENT_GAMESTATE = 0
DRF_GAMESTATE_WAITING = 1
DRF_GAMESTATE_ROUND = 2
DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table

current_round = 0

local death_ratio = (1 / 4) -- for every 4 players 1 death

SetGlobalInt("drf_round_time", 360)
SetGlobalInt("drf_max_death", 6)
SetGlobalInt("drf_max_rounds", 6)

if SERVER then
timer.Create("drf_check_round", 10, 0, function()
    if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_WAITING) then
        if (#player.GetAll() >= 2) then
            start_round()
        end
    end
end)

function death_needed()
    local players_on_death = #team.GetPlayers(TEAM_DEATH)
    local num_players = #player.GetAll()

    if (players_on_death <= 1 and num_players <= 1) then return 0 end

    if (num_players >= 2) then
        local needed = math.Clamp(math.Round(num_players * death_ratio), 1, GetGlobalInt("drf_max_death"))
        return needed
    end

    return 0
end

function sort_players()
    local iter = 0

    if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_WAITING) then
        if (death_needed() != 0) then
            -- hard coded but idc, its for test purposes
            local player_1 = 0

            if (death_needed() == 1) then
                player_1 = math.random(1, #player.GetAll())
            end

            for k, v in pairs(player.GetAll()) do
                iter = iter + 1

                if (iter == player_1) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                elseif (iter == player_2) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                elseif (iter == player_3) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                elseif (iter == player_4) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                elseif (iter == player_5) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                elseif (iter == player_6) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                end

                if (iter != player_1) then
                    v:ChatPrint("You are on Runners!")
                    v:SetTeam(TEAM_RUNNERS)
                    v:Spawn()
                end
            end
        end
    end
end

function start_round()
    if (current_round > GetGlobalInt("drf_max_rounds")) then
        PrintMessage(HUD_PRINTCENTER, "THE GAME IS FINISHED. CHANGING MAP.....")

        timer.Simple(5, function() end)

        RunConsoleCommand("changelevel", "deathrun_marioworld_finalob")
    end

    PrintMessage(HUD_PRINTCENTER, "STARTING NEW ROUND....")
    timer.Simple(5, function() end)
    sort_players()
    DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ROUND
    print("GAME_STATE=ROUND")
end

function check_if_done()
    local num_on_death = #team.GetPlayers(TEAM_DEATH)
    local num_on_runners = #team.GetPlayers(TEAM_RUNNERS)

    if (num_on_death < 1) then
        current_round = current_round + 1

        PrintMessage(HUD_PRINTCENTER, "RUNNERS HAVE WON THE ROUND.. STARTING NEXT ONE")
        timer.Simple(5, function() end)
        start_round()

        DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
    end

    if (num_on_runners < 1) then
        current_round = current_round + 1

        PrintMessage(HUD_PRINTCENTER, "DEATHS HAVE WON THE ROUND.. STARTING NEXT ONE")
        timer.Simple(5, function() end)
        start_round()

        DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
    end
end

function round_think(ply)
    if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ROUND) then

    end
end
net.Receive("drf_net_roundthink", round_think)

function player_death_round(victim, inflictor, attacker)
    if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ROUND) then
        if (victim:Team() == TEAM_DEATH) then
            victim:SetTeam(TEAM_SPECTATOR)
            victim:Spectate(OBS_MODE_ROAMING)
            victim:Spawn()
            victim:StripWeapons()
            PrintMessage(HUD_PRINTTALK, victim:Nick() .. " has died.")
            check_if_done()
        end

        if (victim:Team() == TEAM_RUNNERS) then
            victim:SetTeam(TEAM_SPECTATOR)
            victim:Spectate(OBS_MODE_ROAMING)
            victim:Spawn()
            victim:StripWeapons()
            PrintMessage(HUD_PRINTTALK, victim:Nick() .. " has died.")
            check_if_done()
        end
    end
end
hook.Add("PlayerDeath", "player_death_round", player_death_round)
end

if CLIENT then

end
