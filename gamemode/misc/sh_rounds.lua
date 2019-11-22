print("Loaded rounds system.")

DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table

round_count = 1
max_rounds = 9

has_checked_players_balance = false

death_points = 0
runner_points = 0
round_start_time = 540 -- 9 minutes

-- cleanup derma objects.
if (DEATHRUN_ADDONS.Rounds != nil) then
    if ( DEATHRUN_ADDONS.Rounds.CleanUp != nil) then
        DEATHRUN_ADDONS.Rounds.CleanUp()
    end
end

DEATHRUN_ADDONS.Rounds = {}

if SERVER then
    local ran_timer_already = false
    timer.Create("check_game", 5, 0, function()
        if (ran_timer_already == false
        and #player.GetAll() >= 2) then
            print("TIMER HIT (check_game)")
            check_death_to_runner()
            ran_timer_already = true
        end
    end)

	util.AddNetworkString("roundSystemShowMapSelect")
	util.AddNetworkString("roundSystemMapSelected")
	util.AddNetworkString("roundSystemMapVotedTable")

	net.Receive("roundSystemMapSelected", function(len, ply)
		if (DEATHRUN_ADDONS.Rounds.MapVotes == nil) then return end
		if (DEATHRUN_ADDONS.Rounds.PlayersVoted == nil) then return end
		if (DEATHRUN_ADDONS.Rounds.PlayersVoted[ply]) then return end  -- if we have already voted, disallow it.

		local mapForVote = net.ReadString()

		DEATHRUN_ADDONS.Rounds.PlayersVoted[ply] = true

		table.insert(DEATHRUN_ADDONS.Rounds.MapVotes[mapForVote], ply)

		net.Start("roundSystemMapVotedTable")
		net.WriteTable(DEATHRUN_ADDONS.Rounds.MapVotes)
		net.Broadcast()
	end)

	DEATHRUN_ADDONS.Rounds.GetMapList = function()
		local files, _ = file.Find("maps/*.bsp", "GAME")
		return files
	end

    function check_death_to_runner()
        if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_WAITING) then
            if (#player.GetAll() <= 1) then
                PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: NOT ENOUGH PLAYERS FOR ROUND " .. round_count)
                return false
            end

        	if (#player.GetAll() >= 2 and #player.GetAll() <= 5) then
                timer.Stop("check_game")
                PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: STARTING ROUND " .. round_count)
        		local selected_one_death = math.random(1, #player.GetAll())

        		for _, v in pairs(player.GetAll()) do
        			if (player.GetAll()[selected_one_death] == v) then -- checks if the selected player is equivalent to the iteration (if the player is next up in the for loop)
        				v:SetTeam(TEAM_DEATH)
                        v:Spawn()
                    end

                    if (player.GetAll()[selected_one_death] != v) then
                        v:SetTeam(TEAM_RUNNERS)
                        v:Spawn()
                    end
        		end

                has_checked_players_balance = true
                print("Finished checking death to runners!")
                timer.Stop("hud_round_time_timer")
                timer.Start("hud_round_time_timer")
                DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ROUND
        		return true
        	end

        	if (#player.GetAll() >= 6 and #player.GetAll() <= 9) then
                timer.Stop("check_game")
        		local selected_two_death_one = math.random(1, 4)
        		local selected_two_death_two = math.random(4, #player.GetAll())

        		for _, v in pairs(player.GetAll()) do
        			if (player.GetAll()[selected_two_death_one] == v or
                    player.GetAll()[selected_two_death_two] == v) then -- checks if the selected player is equivalent to the iteration (if the player is next up in the for loop)
        				v:SetTeam(TEAM_DEATH)
                        v:Respawn()
                    end

                    if (player.GetAll()[selected_two_death_one] != v or
                    player.GetAll()[selected_two_death_two] != v) then
                        v:SetTeam(TEAM_RUNNERS)
                        v:Respawn()
                    end
        		end

                has_checked_players_balance = true
                print("Finished checking death to runners!")
                timer.Stop("hud_round_time_timer")
                timer.Start("hud_round_time_timer")
                DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ROUND
        		return true
        	end

        	if (#player.GetAll() >= 10 and #player.GetAll() <= 14) then
                timer.Stop("check_game")
        		local selected_three_death_one = math.random(1, 4)
        		local selected_three_death_two = math.random(4, 9)
        		local selected_three_death_three = math.random(9, #player.GetAll())

                for _, v in pairs(player.GetAll()) do
        			if (player.GetAll()[selected_three_death_one] == v or
                    player.GetAll()[selected_three_death_two] == v or
                    player.GetAll()[selected_three_death_three] == v) then -- checks if the selected player is equivalent to the iteration (if the player is next up in the for loop)
        				v:SetTeam(TEAM_DEATH)
                        v:Respawn()
                    end

                    if (player.GetAll()[selected_three_death_one] != v or
                    player.GetAll()[selected_three_death_two] != v or
                    player.GetAll()[selected_three_death_three] != v) then
                        v:SetTeam(TEAM_RUNNERS)
                        v:Respawn()
                    end
        		end

                has_checked_players_balance = true
                print("Finished checking death to runners!")
                timer.Stop("hud_round_time_timer")
                timer.Start("hud_round_time_timer")
        		return true
        	end

        	if (#player.GetAll() >= 15 and #player.GetAll() <= 19) then
                timer.Stop("check_game")
        		local selected_four_death_one = math.random(1, 4)
        		local selected_four_death_two = math.random(4, 9)
        		local selected_four_death_three = math.random(9, 14)
        		local selected_four_death_four = math.random(14, #player.GetAll())

        		for _, v in pairs(player.GetAll()) do
        			it = it + 1

        			if (player.GetAll()[selected_four_death_one] == v or
                    player.GetAll()[selected_four_death_two] == v or
                    player.GetAll()[selected_four_death_three] == v or
                    player.GetAll()[selected_four_death_four] == v) then
        				v:SetTeam(TEAM_DEATH)
        				v:Respawn()
        			end

                    if (player.GetAll()[selected_four_death_one] != v or
                    player.GetAll()[selected_four_death_two] != v or
                    player.GetAll()[selected_four_death_three] != v or
                    player.GetAll()[selected_four_death_four] != v) then
                        v:SetTeam(TEAM_RUNNERS)
                        v:Kill()
                        v:Respawn()
                    end
        		end

                has_checked_players_balance = true
                print("Finished checking death to runners!")
                timer.Stop("hud_round_time_timer")
                timer.Start("hud_round_time_timer")
                DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ROUND
        		return true
        	end

        	if (#player.GetAll() >= 20 and #player.GetAll() <= 24) then
                timer.Stop("check_game")
        		local selected_five_death_one = math.random(1, 4)
        		local selected_five_death_two = math.random(4, 9)
        		local selected_five_death_three = math.random(9, 14)
        		local selected_five_death_four = math.random(14, 19)
        		local selected_five_death_five = math.random(19, #player.GetAll())

        		for _, v in pairs(player.GetAll()) do
        			it = it + 1

        			if (player.GetAll()[selected_five_death_one] == v or
                    player.GetAll()[selected_five_death_two] == v or
                    player.GetAll()[selected_five_death_three] == v or
                    player.GetAll()[selected_five_death_four] == v or
                    player.GetAll()[selected_five_death_five] == v) then
        				v:SetTeam(TEAM_DEATH)
        				v:Respawn()
        			end

                    if (player.GetAll()[selected_five_death_one] != v or
                    player.GetAll()[selected_five_death_two] != v or
                    player.GetAll()[selected_five_death_three] != v or
                    player.GetAll()[selected_five_death_four] != v or
                    player.GetAll()[selected_five_death_five] != v) then
                        v:SetTeam(TEAM_RUNNERS)
                        v:Kill()
                        v:Respawn()
                    end
        		end

                DRF_CURRENT_GAMESTATE = DRF_GAMESTATE_ROUND
                print("Finished checking death to runners!")
                timer.Stop("hud_round_time_timer")
                timer.Start("hud_round_time_timer")
                has_checked_players_balance = true
        		return true
        	end
        end

    	return false
    end

    function cleanup_round()
        has_checked_players_balance = false

        if (has_checked_players_balance == false) then
            check_death_to_runner()
        end
    end

    function call_mapvote_timer()
        if (round_count > max_rounds) then
            timer.Simple(5, function()
                DEATHRUN_ADDONS.Rounds.PlayersVoted = {}
                DEATHRUN_ADDONS.Rounds.MapVotes = {}
                local maps = DEATHRUN_ADDONS.Rounds.GetMapList()
                for k,v in pairs(maps) do
                    DEATHRUN_ADDONS.Rounds.MapVotes[v] = {
                        -- player one,
                        -- player two
                    }
                end

                net.Start("roundSystemShowMapSelect")
                net.WriteTable(maps)
                net.WriteTable(DEATHRUN_ADDONS.Rounds.MapVotes)
                net.Broadcast()

                timer.Simple(10, function()
                    local votedMapName, maxMapNamePlyVoteCount
                    votedMapName = "deathrun_marioworld_finalob"
                    maxMapNamePlyVoteCount = 0

                    for mapName,plyList in pairs(DEATHRUN_ADDONS.Rounds.MapVotes or {}) do
                        if (table.Count(plyList) > maxMapNamePlyVoteCount) then
                            votedMapName = mapName
                        end
                    end

                    votedMapName = string.Left(votedMapName, string.len(votedMapName))

                    PrintMessage(HUD_PRINTTALK, "Next map is " .. votedMapName, DEATHRUN_ADDONS.Notify.Enums["NORMAL_TITLE"])
                    timer.Simple(6, function()
                        RunConsoleCommand("changelevel", votedMapName)
                    end)
                end)
            end)
        end
    end

	hook.Add("PlayerDeath", "roundsSystemPlayerDeath", function(victim, inflictor, attacker)
        if (DRF_CURRENT_GAMESTATE == DRF_GAMESTATE_ROUND) then
        	if victim:Team() == TEAM_RUNNERS then -- switch the player to the other team
    			victim:SetTeam(TEAM_SPECTATOR)
                victim:Spectate(OBS_MODE_ROAMING)
    		elseif victim:Team() == TEAM_DEATH then
    			victim:SetTeam(TEAM_SPECTATOR)
                victim:Spectate(OBS_MODE_ROAMING)
    		end

    		-- how many runners are still alive?
    		local runners = team.GetPlayers(TEAM_RUNNERS)
            local deaths = team.GetPlayers(TEAM_DEATH)
    		local runnersLeftAlive = #runners -- how many players are left in the runners team?
            local deathLeftAlive = #deaths

    		if (runnersLeftAlive < 1) then -- no more runners left alive, new round.
    			--DEATHRUN_ADDONS.Notify.NotifyAll("Death(s) win!", 2)
                round_count = round_count + 1

                if (round_count > max_rounds) then
                    if (runner_points > death_points) then
            			PrintMessage(HUD_PRINTCENTER, "Runner(s) win the game! Starting next map...")
                        timer.Start("check_game")
                    end

                    if (death_points > runner_points) then
                        PrintMessage(HUD_PRINTCENTER, "Death(s) win this game! Starting next map...")
                        timer.Start("check_game")
                    end

        			call_mapvote_timer()
                end

                death_points = death_points + 1
                print("round_count = " .. round_count)

                for k, v in pairs(player.GetAll()) do
                    v:Respawn()
                end

                cleanup_round()
    		end

            if (deathLeftAlive < 1) then -- no more deaths
                round_count = round_count + 1

                if (round_count > max_rounds) then
                    if (runner_points > death_points) then
            			PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: Runner(s) win the game! Starting next map...")
                    end

                    if (death_points > runner_points) then
                        PrintMessage(HUD_PRINTTALK, "[DRF MESSAGE]: Death(s) win this game! Starting next map...")
                    end

                    runner_points = runner_points + 1
                    print("round_count = " .. round_count)

                    for k, v in pairs(player.GetAll()) do
                        v:Spectate(OBS_MODE_ROAMING)
                    end

                    PrintMessage(HUD_PRINTCENTER, "[DRF MESSAGE]: CHANGING MAP....")

                    call_mapvote_timer()
                end

                runner_points = runner_points + 1
                print("round_count = " .. round_count)

                for k, v in pairs(player.GetAll()) do
                    v:Respawn()
                end

                cleanup_round()
            end
        end
	end)
elseif CLIENT then

	net.Receive("roundSystemMapVotedTable", function(len)
		DEATHRUN_ADDONS.Rounds.MapVotes = net.ReadTable()

		for mapName,plyList in pairs(DEATHRUN_ADDONS.Rounds.MapVotes) do
			local associatedMapEntry = DEATHRUN_ADDONS.Rounds.PlayerAvatarPanels[mapName]

			associatedMapEntry:Clear()

			for i,ply in pairs(plyList) do
				local Avatar = vgui.Create("AvatarImage", DEATHRUN_ADDONS.Rounds.PlayerAvatarPanels[mapName])
				Avatar:SetSize( 64, 64 )
				Avatar:SetPlayer( ply, 64 )
				Avatar:MoveTo((i-1) * 64, 0)
			end
		end
	end)

	 DEATHRUN_ADDONS.Rounds.CleanUp = function()
        if ( DEATHRUN_ADDONS.Rounds.backgroundPanel != nil) then
        	DEATHRUN_ADDONS.Rounds.MapVotes = {}
        	DEATHRUN_ADDONS.Rounds.PlayerAvatarPanels = {}
        	DEATHRUN_ADDONS.Rounds.VoteSectionPanel = {}
            DEATHRUN_ADDONS.Rounds.backgroundPanel:Remove()
        end
    end

	net.Receive("roundSystemShowMapSelect", function()
		local mapsList = net.ReadTable()
		DEATHRUN_ADDONS.Rounds.MapVotes = net.ReadTable()
        DEATHRUN_ADDONS.Rounds.PlayerAvatarPanels = {}
        DEATHRUN_ADDONS.Rounds.VoteSectionPanel = {}

		DEATHRUN_ADDONS.Rounds.backgroundPanel = vgui.Create( "DFrame" )
		DEATHRUN_ADDONS.Rounds.backgroundPanel:SetSize(ScrW() / (2*1.6), ScrH() / 1.6)
		DEATHRUN_ADDONS.Rounds.backgroundPanel:Center()
		DEATHRUN_ADDONS.Rounds.backgroundPanel:SetTitle("")
		DEATHRUN_ADDONS.Rounds.backgroundPanel:MakePopup();
		DEATHRUN_ADDONS.Rounds.backgroundPanel:ShowCloseButton(false)
		DEATHRUN_ADDONS.Rounds.backgroundPanel.Paint = function(self, w,h) end

		local Scroll = vgui.Create( "DScrollPanel", DEATHRUN_ADDONS.Rounds.backgroundPanel ) -- Create the Scroll panel
		Scroll:Dock( FILL )

		local List = vgui.Create( "DIconLayout", Scroll )
		List:Dock( FILL )
		List:SetSpaceY( 5 ) -- Sets the space in between the panels on the Y Axis by 5
		List:SetSpaceX( 5 ) -- Sets the space in between the panels on the X Axis by 5

		local width, height = DEATHRUN_ADDONS.Rounds.backgroundPanel:GetSize()
		for k,v in SortedPairsByValue(mapsList) do
			local mapSection = List:Add("DButton")
			mapSection:SetText("")
			mapSection.DoClick = function()
				net.Start("roundSystemMapSelected")
				net.WriteString(v)
				net.SendToServer()
			end
			mapSection:SetSize( width - 40, 32 )
			mapSection.Paint = function (self, w, h)
				surface.SetFont("ScoreboardDefault")

                local tw, th = surface.GetTextSize( v )


				local cw, ch = DEATHRUN_ADDONS.Rounds.backgroundPanel:GetSize()
				if (tw + 12) > cw then
                	DEATHRUN_ADDONS.Rounds.backgroundPanel:SetSize(tw+12, ScrH() / 1.6)
                end

                local ox = (w/2) - (tw/2)
                local oy = 4
                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(ox, 0, tw+12, th + 9)

                surface.SetDrawColor(200, 0, 200, 255)
                surface.DrawRect(ox + 3, 3, tw+6, th + 3)

                surface.SetTextPos(ox + 6, 4)
                surface.SetTextColor(Color(255, 255, 255, 255))
                surface.DrawText(v)
			end


			local voteSectionScroll = List:Add( "DPanel" ) -- Create the Scroll panel
			voteSectionScroll:SetSize(ScrW(), 64)
			voteSectionScroll.Paint = function() end
			DEATHRUN_ADDONS.Rounds.PlayerAvatarPanels[v] = voteSectionScroll
		end
	end)

end
