print("[DRF] loaded new round system")

DRF_GAMESTATE_WAITING = 1
DRF_GAMESTATE_ROUND = 2
DRF_GAMESTATE_END = 3
DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table

current_round = 0

local death_ratio = (1 / 4) -- for every 4 players 1 death

SetGlobalInt("drf_round_time", 360)
SetGlobalInt("drf_max_death", 6)
SetGlobalInt("drf_max_rounds", 6)
SetGlobalInt("drf_current_gamestate", DRF_GAMESTATE_WAITING)

if SERVER then
timer.Create("drf_check_game", 5, 0, function()
    if (#player.GetAll() >= 2) then
        start_round()
        timer.Stop("drf_check_game")
    end
end)

function set_gamestate(id)
    SetGlobalInt("drf_current_gamestate", id)
    return DRF_CURRENT_GAMESTATE
end

function death_needed()
    local players_on_death = #team.GetPlayers(TEAM_DEATH)
    local num_players = #player.GetAll()

    if (players_on_death <= 1 and num_players <= 1) then return 0 end

    if (num_players) then
        local needed = math.Clamp(math.Round(num_players * death_ratio), 1, GetGlobalInt("drf_max_death"))
        return needed
    end

    return 0
end

function sort_players()
    if (GetGlobalInt("drf_current_gamestate") == DRF_GAMESTATE_WAITING) then
        if (death_needed() != 0) then
            -- hard coded but idc, its for test purposes
            local player_1 = math.random(1, #player.GetAll())
            local player_2 = math.random(4, #player.GetAll())
            local player_3 = math.random(8, #player.GetAll())
            local player_4 = math.random(12, #player.GetAll())
            local player_5 = math.random(16, #player.GetAll())
            local player_6 = math.random(20, #player.GetAll())

            for k, v in pairs(player.GetAll()) do
                if (player.GetAll()[player_1] == v) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                    v:UnSpectate()
                elseif (player.GetAll()[player_2] == v) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                    v:UnSpectate()
                elseif (player.GetAll()[player_3] == v) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                    v:UnSpectate()
                elseif (player.GetAll()[player_4] == v) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                    v:UnSpectate()
                elseif (player.GetAll()[player_5] == v) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                    v:UnSpectate()
                elseif (player.GetAll()[player_6] == v) then
                    v:ChatPrint("You are on Deaths!")
                    v:SetTeam(TEAM_DEATH)
                    v:Spawn()
                    v:UnSpectate()
                else
                    v:ChatPrint("You are on Runners!")
                    v:SetTeam(TEAM_RUNNERS)
                    v:Spawn()
                    v:UnSpectate()
                end
            end

            return true
        end
    end
end

-- will only fully be executed when DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
-- because sort_players requires it to be.
function start_round()
    if (current_round > GetGlobalInt("drf_max_rounds")) then
        PrintMessage(HUD_PRINTCENTER, "THE GAME IS FINISHED. CHANGING MAP.....")
        timer.Simple(5, function()
            RunConsoleCommand("changelevel", "dr_combinecastle_mpqcfix.bsp")
        end)
    end

    set_gamestate(DRF_GAMESTATE_WAITING)
    sort_players()
    set_gamestate(DRF_GAMESTATE_ROUND)
end

function check_if_done()
    local num_on_death = #team.GetPlayers(TEAM_DEATH)
    local num_on_runners = #team.GetPlayers(TEAM_RUNNERS)

    if (num_on_death < 1) then
        current_round = current_round + 1
        return true
    end

    if (num_on_runners < 1) then
        current_round = current_round + 1
        return true
    end

    return false
end

function do_endround()
    if (GetGlobalInt("drf_current_gamestate") == DRF_GAMESTATE_END) then
        game.CleanUpMap()
    end
end

hook.Add("PlayerDeath", "rounds_ply_death_hk", function(victim, inflictor, attacker)
    if (GetGlobalInt("drf_current_gamestate") == DRF_GAMESTATE_ROUND) then
        if (victim:Team() == TEAM_RUNNERS) then
            victim:SetTeam(TEAM_SPECTATOR)
            victim:Spectate(OBS_MODE_ROAMING)
            victim:StripWeapons()

            if (check_if_done() == true) then
                PrintMessage(HUD_PRINTCENTER, "STARTING NEW ROUND IN 10 SECONDS. DEATHS WON")
                set_gamestate(DRF_GAMESTATE_END)
                do_endround()
                timer.Simple(10, function() start_round() end)
            end
        end

        if (victim:Team() == TEAM_DEATH) then
            victim:SetTeam(TEAM_SPECTATOR)
            victim:Spectate(OBS_MODE_ROAMING)
            victim:StripWeapons()

            if (check_if_done() == true) then
                PrintMessage(HUD_PRINTCENTER, "STARTING NEW ROUND IN 10 SECONDS. RUNNERS WON")
                set_gamestate(DRF_GAMESTATE_END)
                timer.Simple(10, function() start_round() end)
            end
        end
    end
end)
end
