global_timer = 0
round_started = false
max_rounds = 9
next_map = ""
round_count = 1
round_time = 0
round_start_time = 540 -- 9 minutes
death_points = 0
runner_points = 0
has_checked_players_balance = false

DRF_GAMESTATE_OUT_OF_THINK = -1
DRF_GAMESTATE_WAITING = 1
DRF_GAMESTATE_ROUND = 2
DRF_GAMESTATE_ENDROUND = 3
DRF_CURRENT_GAMESTATE = 0

local death_count = 0
local runner_count = 0

local death_win_messages = {
	"[DRF_MESSAGE]: DEATH IS VICTORIOUS. THE RUNNERS ARE VANQUISHED",
	"[DRF_MESSAGE]: DEATH HAS DESTROYED THE RUNNERS",
	"[DRF_MESSAGE]: HUMANS ARE NO MORE, THANKS TO DEATH",
	"[DRF_MESSAGE]: DEATH HAS COMPLETELY ABOLISHED THE HUMANS",
	"[DRF_MESSAGE]: AWESOME JOB DEATH, YOU HAVE SUCCESSFULLY DECIMATED THE HUMANS"
}

local runner_win_messages = {
	"[DRF_MESSAGE]: RUNNERS ARE VICTORIOUS. DEATH IS NO MORE",
	"[DRF_MESSAGE]: RUNNERS HAVE OUTWITTED DEATH AGAIN",
	"[DRF_MESSAGE]: RUNNERS HAVE DESTROYED THE FOUL DEMONS",
	"[DRF_MESSAGE]: DEMONS ARE NO MORE",
	"[DRF_MESSAGE]: AWESOME WORK RUNNERS"
}

if SERVER then
function can_start_round()
	if (#player.GetAll() > 1) then return true end

	return false
end

timer.Create("drf_timer_countdown", 1, round_start_time, function()
	round_time = round_time + 1
end)

timer.Create("drf_check_game", 5, 0, function()
    print("[DRF] CHECKING IF THE SERVER CAN START A GAME....")

    if (can_start_round() == true) then
		start_game()
        return
    end

    print("[DRF] CANNOT START ROUND....")
    DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
end)

function push_round_number()
	round_count = round_count + 1
end

function check_death_to_runner()
	local it = 0

	if (#player.GetAll() >= 2 and #player.GetAll() <= 5) then
		local selected_one_death = math.random(1, 5)

		for _, v in pairs(player.GetAll()) do
			it = it + 1

			if (selected_one_death == it) then -- checks if the selected player is equivalent to the iteration (if the player is next up in the for loop)
				v:SetTeam(TEAM_DEATH)
			end

            if (selected_one_death ~= it) then
                v:SetTeam(TEAM_RUNNERS)
                v:Kill()
                v:Respawn()
            end
		end

        has_checked_players_balance = true
		return true
	end

	if (#player.GetAll() >= 6 and #player.GetAll() <= 9) then
		local selected_two_death_one = math.random(1, 4)
		local selected_two_death_two = math.random(5, 9)

		for _, v in pairs(player.GetAll()) do
			it = it + 1

			if ((selected_two_death_one == it) or
			(selected_two_death_two == it)) then
				v:SetTeam(TEAM_DEATH)
                v:Kill()
				v:Respawn()
			end

            if ((selected_two_death_one ~= it) or
			(selected_two_death_two ~= it)) then
				v:SetTeam(TEAM_RUNNERS)
                v:Kill()
				v:Respawn()
			end
		end

        has_checked_players_balance = true
		return true
	end

	if (#player.GetAll() >= 10 and #player.GetAll() <= 14) then
		local selected_three_death_one = math.random(1, 4)
		local selected_three_death_two = math.random(5, 9)
		local selected_three_death_three = math.random(10, 14)

		for _, v in pairs(player.GetAll()) do
			it = it + 1

			if ((selected_three_death_one == it) or
			(selected_three_death_two == it) or
			(selected_three_death_three == it)) then
				v:SetTeam(TEAM_DEATH)
                v:Kill()
				v:Respawn()
			end

            if ((selected_three_death_one ~= it) or
            (selected_three_death_two ~= it) or
            (selected_three_death_three ~= it)) then
                v:SetTeam(TEAM_RUNNERS)
                v:Kill()
                v:Respawn()
            end
		end

        has_checked_players_balance = true
		return true
	end

	if (#player.GetAll() >= 15 and #player.GetAll() <= 19) then
		local selected_four_death_one = math.random(1, 4)
		local selected_four_death_two = math.random(5, 9)
		local selected_four_death_three = math.random(10, 14)
		local selected_four_death_four = math.random(15, 19)

		for _, v in pairs(player.GetAll()) do
			it = it + 1

			if ((selected_four_death_one == it) or
			(selected_four_death_two == it) or
			(selected_four_death_three == it) or
			(selected_four_death_four == it)) then
				v:SetTeam(TEAM_DEATH)
				v:Respawn()
			end

            if ((selected_four_death_one ~= it) or
            (selected_four_death_two ~= it) or
            (selected_four_death_three ~= it) or
            (selected_four_death_four ~= it)) then
                v:SetTeam(TEAM_RUNNERS)
                v:Kill()
                v:Respawn()
            end
		end

        has_checked_players_balance = true
		return true
	end

	if (#player.GetAll() >= 20 and #player.GetAll() <= 24) then
		local selected_five_death_one = math.random(1, 4)
		local selected_five_death_two = math.random(5, 9)
		local selected_five_death_three = math.random(10, 14)
		local selected_five_death_four = math.random(15, 19)
		local selected_five_death_five = math.random(20, 24)

		for _, v in pairs(player.GetAll()) do
			it = it + 1

			if ((selected_five_death_one == it) or
			(selected_five_death_two == it) or
			(selected_five_death_three == it) or
			(selected_five_death_four == it) or
			(selected_five_death_five == it)) then
				v:SetTeam(TEAM_DEATH)
				v:Respawn()
			end

            if ((selected_five_death_one ~= it) or
            (selected_five_death_two ~= it) or
            (selected_five_death_three ~= it) or
            (selected_five_death_four ~= it) or
            (selected_five_death_five ~= it)) then
                v:SetTeam(TEAM_RUNNERS)
                v:Kill()
                v:Respawn()
            end
		end

        has_checked_players_balance = true
		return true
	end

	return false
end

local list = {}
function get_players_alive_team(id)
	for _, v in pairs(team.GetPlayers(id)) do
		if (v:Alive()) then
			list[#list + 1] = v
		end
	end

	return list
end

function on_round_start()
    push_round_number()

    if (check_death_to_runner() == true) then
        check_death_to_runner()
        return true
    else
        return false
    end
end

function on_round_end()
    if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ENDROUND) then return true end
end

function start_round()
	local time_to_end = os.time() + round_start_time
	local time_start = os.time()

    timer.Start("hud_round_time_timer")
    timer.Start("drf_timer_countdown")
    DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ROUND -- gets the think hook moving into round segment
end

function on_preround_start()
	if (can_start_round() == true) then
		PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: ATTEMPTING TO START NEW ROUND...")

		if (check_death_to_runner() == true) then
			round_started = true
            timer.Stop("drf_check_game")

            if (round_started == true) then
                PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: STARTING NEW ROUND...")
                on_round_start()
                PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: STARTING ROUND " .. round_count .. "...")
                start_round()
            end

			return true
		end
	else
		DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING

		timer.Start("drf_check_game")
		return false
	end

	DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
	return false
end

function start_game()
    game.CleanUpMap()

    if (round_started == false) then
        timer.Stop("drf_check_game")
        on_preround_start()
    end
end
concommand.Add("drf_start_round", start_game)

function give_runner_point()
	runner_points = runner_points + 1
end

function give_death_point()
	death_points = death_points + 1
end

function start_new_round()
	if (round_count <= max_rounds) then
		if (round_count == max_rounds) then
			PrintMessage(HUD_PRINTCENTER, "[DRF_MESSAGE]: GET READY FOR THE FINAL ROUND")
		end

		PrintMessage(HUD_PRINTTALK, "[DRF MESSAGE]: GET READY FOR THE NEXT ROUND")

        has_checked_players_balance = false
        round_started = false
		start_game()
	end
end

function round_think_hook()
	if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_WAITING) then
        round_started = false
	end

	if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ROUND) then
        local runners = get_players_alive_team(TEAM_RUNNERS)
        local deaths = get_players_alive_team(TEAM_DEATH)

        if (round_time == round_start_time) then
        	for k, v in pairs(player.GetAll()) do
                v:Freeze(true)
                v:Respawn()

                PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: TIMES UP, ROUND IS RESTARTING")
                timer.Start("drf_check_game")
                timer.Stop("drf_timer_countdown")
                round_time = 1
                DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ENDROUND
            end
        end

        if (#player.GetAll() < 2) then
            DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
        end
	end

	if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ENDROUND) then
        if (round_count > max_rounds) then
            PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: THE MATCH HAS FINISHED. RESULTS ARE IN THE CHAT.")

            if (death_points > runner_points) then
                PrintMessage(HUD_PRINTTALK, "[DRF MESSAGE]: DEATHS HAVE WON THE GAME WITH MORE POINTS")
            elseif (runner_points > death_points) then
                PrintMessage(HUD_PRINTTALK, "[DRF MESSAGE]: RUNNERS HAVE WON THE GAME WITH 5 POINTS")
            end

            local rand_map = table.Random(drf_maps)
            PrintMessage(HUD_PRINTTALK, "[DRF MESSAGE]: MOVING ONTO " .. rand_map .. " IN 15 SECONDS...")

            round_started = false

            timer.Create("drf_end_round_timer", 15, 1, function()
                RunConsoleCommand("changemap", rand_map)
            end)

            DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_OUT_OF_THINK
        end

        round_started = false
        PrintMessage(HUD_PRINTTALK, "[DRF MESSAGE]: MOVING ONTO THE" .. round_count .. "ROUND")
        start_new_round()

    	DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING
    end
end
hook.Add("Think", "drf_round_think_hook", round_think_hook)

local runners = team.GetPlayers(TEAM_RUNNERS)
local deaths = team.GetPlayers(TEAM_DEATH)
function death_runner(victim, inflictor, attacker)
    local vic_pos = victim:GetPos()

    if ((victim:Team() == TEAM_RUNNERS) and
    (victim:Team() ~= attacker:Team())) then
        victim:Kill()
        victim:SetTeam(TEAM_SPECTATOR)
        victim:Respawn()
    elseif ((victim:Team() == TEAM_DEATH) and
        attacker:Team() == TEAM_RUNNERS) then
        victim:SetTeam(TEAM_SPECTATOR)
    elseif ((victim:Team() == TEAM_DEATH) and
        attacker:Team() ~= TEAM_RUNNERS) then
        return false
    elseif (inflictor:IsWorld() and victim:Team() == TEAM_RUNNERS) then
        victim:Kill()
        victim:SetTeam(TEAM_SPECTATOR)
        victim:Respawn()
    elseif (!inflictor:IsPlayer() and
        victim:Team() == TEAM_DEATH) then
        victim:Respawn()
        victim:SetPos(vic_pos)
        victim:SetTeam(TEAM_DEATH)
    end

    if (!table.HasValue(runners, TEAM_RUNNERS)) then
        PrintMessage(HUD_PRINTTALK, table.Random(death_win_messages))
        timer.Start("drf_check_game")
        timer.Stop("drf_timer_countdown")
    end

    if (!table.HasValue(deaths, TEAM_DEATH)) then
        PrintMessage(HUD_PRINTTALK, table.Random(runner_win_messages))
        timer.Start("drf_check_game")
        timer.Stop("drf_timer_countdown")
    end
end
hook.Add("PlayerDeath", "death_runner_hk", death_runner)

elseif CLIENT then
end
