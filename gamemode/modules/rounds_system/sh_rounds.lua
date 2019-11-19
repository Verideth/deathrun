if SERVER then

	function GM:PlayerDeath(victim, inflictor, attacker)
		-- if the player is a runner.
		-- keep him dead until the the entire team is dead.

		if victim:Team() == TEAM_RUNNERS then -- switch the player to the other team
			victim:SetTeam(TEAM_SPECTATOR)
			victim:Spawn()
		elseif victim:Team() == TEAM_DEATH
			victim:Spawn()
		end

		-- how many runners are still alive?
		local runners = team.GetPlayers(TEAM_RUNNERS)
		local runnersLeftAlive = table.Count(runners) -- how many players are left in the runners team?

		if (runnersLeftAlive <= 1) then -- no more runners left alive, new round.
			print("Winner is:", runners[1]:Nick())
			
			timer.Simple(5, function()
				RunConsoleCommand("changelevel", game.GetMap())
			end)
		end
	end

elseif CLIENT then


end