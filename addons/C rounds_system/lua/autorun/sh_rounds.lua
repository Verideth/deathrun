print("Loaded rounds system.")

DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table


-- cleanup derma objects.
if (DEATHRUN_ADDONS.Rounds != nil) then
    if ( DEATHRUN_ADDONS.Rounds.CleanUp != nil) then
        DEATHRUN_ADDONS.Rounds.CleanUp()
    end
end

DEATHRUN_ADDONS.Rounds = {}

if SERVER then
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

	hook.Add("PlayerDeath", "roundsSystemPlayerDeath", function(victim, inflictor, attacker)

		if victim:Team() == TEAM_RUNNERS then -- switch the player to the other team
			victim:SetTeam(TEAM_SPECTATOR)
			victim:Spawn()
		elseif victim:Team() == TEAM_DEATH then
			victim:Spawn()
		end

		-- how many runners are still alive?
		local runners = team.GetPlayers(TEAM_RUNNERS)
		local runnersLeftAlive = table.Count(runners) -- how many players are left in the runners team?

		if (runnersLeftAlive <= 1) then -- no more runners left alive, new round.
			--print("Winner is:", runners[1]:Nick())
			DEATHRUN_ADDONS.Notify.NotifyAll(victim:Nick() .. " wins!", 2)

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

					votedMapName = string.Left(votedMapName, string.len(votedMapName) - 4)

					DEATHRUN_ADDONS.Notify.NotifyAll("Next map is " .. votedMapName, DEATHRUN_ADDONS.Notify.Enums["NORMAL_TITLE"])
					timer.Simple(6, function()
						RunConsoleCommand("changelevel", votedMapName)
					end)
				end)
			end)
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
