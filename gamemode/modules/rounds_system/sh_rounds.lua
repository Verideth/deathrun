global_timer = 0
round_started = false
max_rounds = 9
next_map = ""
round_count = 0
round_time = 0
round_start_time = 540 -- 9 minutes
death_points = 0
runner_points = 0
has_checked_players_balance = false

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
timer.Create("drf_timer_countdown", 1, 0, function()
	round_time = round_time + 1
end)

timer.Create("drf_check_game", 5, 0, function()
	if (can_start_round() == true) then
		start_game()
	end
end)

function death_runner(victim, inflictor, attacker)
	if victim:Team() == TEAM_RUNNERS then -- switch the player to the other team
		victim:SetTeam(TEAM_SPECTATOR)
		victim:Kill()
	elseif (victim:Team() == TEAM_DEATH and attacker:Team() == TEAM_RUNNERS) then
		victim:Kill()
        victim:SetTeam(TEAM_SPECTATOR)
	end
end
hook.Add("PlayerDeath", "death_runner_hk", death_runner)

function can_start_round()
	if (#player.GetAll() > 1) then return true end

	return false
end

function check_death_to_runner()
	local it = 0

	if (#player.GetAll() >= 2 and #player.GetAll() <= 5) then
		local selected_one_death = math.random(1, 5)

		for _, v in pairs(player.GetAll()) do
			it = it + 1

			if (selected_one_death == _) then -- checks if the selected player is equivalent to the iteration (if the player is next up in the for loop)
				v:SetTeam(TEAM_DEATH)
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

			if (selected_three_death_one == it) or
			(selected_three_death_two == it) or
			(selected_three_death_three == it) then
				v:SetTeam(TEAM_DEATH)
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

			if (selected_four_death_one == it) or
			(selected_four_death_two == it) or
			(selected_four_death_three == it) or
			(selected_four_death_four == it) then
				v:SetTeam(TEAM_DEATH)
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

			if (selected_five_death_one == it) or
			(selected_five_death_two == it) or
			(selected_five_death_three == it) or
			(selected_five_death_four == it) or
			(selected_five_death_five == it) then
				v:SetTeam(TEAM_DEATH)
				v:Respawn()
			end
		end

        has_checked_players_balance = true
		return true
	end

	return false
end

function get_players_alive_team(id)
	local list = {}

	for _, v in pairs(team.GetPlayers(id)) do
		if (v:Alive()) then
			list[#list + 1] = v
		end
	end

	return list
end

function on_round_start()
	round_count = round_count + 1

	for _, v in pairs(player.GetAll()) do
		v:Kill()
		v:Respawn()
	end

    check_death_to_runner()
end

function on_round_end()

end

function start_round()
	local time_to_end = os.time() + round_start_time
	local time_start = os.time()
	timer.Start("drf_timer_countdown")

	round_think_hook()

	timer.Create("drf_timer", 540, 1, function()
			round_time = round_time + 1
			for _, v in pairs(player.GetAll()) do
			v:Freeze(true)
			v:Kill()
			PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: TIMES UP, ROUND IS RESTARTING")

			DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ENDROUND
			timer.Start("drf_check_game")
		end
 	end)
end

function on_preround_start()
	if (can_start_round() == true) then
		for _, v in pairs(player.GetAll()) do
			PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: ATTEMPTING TO START NEW ROUND...")

			if ((has_checked_players_balance == false) and
            (check_death_to_runner() == true)) then
				DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ROUND
				round_started = true
				PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: STARTING NEW ROUND...")
				on_round_start()
    			start_round()

				return true
			end
		end
	else
		DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING

		timer.Start("drf_check_game")
		PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: NOT ENOUGH PLAYERS... CHECKING IN 5 SECONDS")
		return false
	end
	DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_WAITING

	return false
end

function start_game()
	timer.Stop("drf_check_game")
	on_preround_start()
end
concommand.Add("drf_start_round", start_game)

function push_round_number()
	round_count = round_count + 1
end

function give_runner_point()
	runner_points = runner_points + 1
end

function give_death_point()
	death_points = death_points + 1
end

function start_new_round()
	if (round_count <= 9) then
		if (round_count == 9) then
			PrintMessage(HUD_PRINTCENTER, "[DRF_MESSAGE]: GET READY FOR THE FINAL ROUND")
		end

		PrintMessage(HUD_PRINTTALK, "[DRF MESSAGE]: GET READY FOR THE NEXT ROUND")

        has_checked_players_balance = false
		game.CleanUpMap()
		start_game()
	end
end


function round_think_hook()
	if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_WAITING) then
		if ((check_death_to_runner() == true) and (can_start_round() == true)) then
			start_game()
		end
	end

	if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ROUND) then
		for k, v in pairs(player.GetAll()) do
            if (#team.GetPlayers(TEAM_RUNNERS) < 1) then
                PrintMessage(HUD_PRINTCENTER, table.Random(death_win_messages))
                give_death_point()
                DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ENDROUND
            elseif (#team.GetPlayers(TEAM_DEATH) < 1) then
                PrintMessage(HUD_PRINTCENTER, table.Random(runner_win_messages))
                give_runner_point()
                DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ENDROUND
            end
		end
	end

	if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ENDROUND) then
        push_round_number()
        start_game()
	end
end
hook.Add("Think", "drf_round_think_hook", round_think_hook)

elseif CLIENT then

function draw_round_time_left()
    surface.SetDrawColor(255, 255, 255, 255)
    surface.DrawRect(ScrW() / 2 - 103, 15, 220, 20)

    surface.SetDrawColor(30, 30, 30, 255)
    surface.DrawRect(ScrW() / 2 - 100, 17, 214, 16)

    surface.SetTextPos(ScrW() / 2 - 68, 18)
    surface.SetFont("HudHintTextLarge")
    surface.SetTextColor(Color(255, 255, 255, 255))
    surface.DrawText("TIME REMAINING: " .. round_time)
end
end
