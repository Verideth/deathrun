print("[DRF] loaded scoreboard")

-- these are globals.
-- every other script loaded AFTER this one will be able to use these.
--                          -------

-- i just did AddCSLuaFile in my init.lua,         -> made this file be sent to the client
-- then did all the includes inside shared.lua             -> made the code in this file be added to the shared.lua
-- then i just include shared.lua inside init and cl_init   -> made the code in the shared.lua file loaded by the system
-- is that right?

-- thats interesting how you break it down like a processor / interpreter / compiler, i'll
-- have to start doing that

DEATHRUN_ADDONS = DEATHRUN_ADDONS or {}

DEATHRUN_ADDONS.Scoreboard = {}

DEATHRUN_ADDONS.Scoreboard.scoreboardFrame = nil
DEATHRUN_ADDONS.Scoreboard.scoreboardFrameLeftPanel = nil
DEATHRUN_ADDONS.Scoreboard.scoreboardFrameRightPanel = nil
DEATHRUN_ADDONS.Scoreboard.runner_vgui = nil
DEATHRUN_ADDONS.Scoreboard.death_vgui = nil
DEATHRUN_ADDONS.Scoreboard.scoreboard_isopen = false


if CLIENT then
function GM:ScoreboardShow()
    if (DEATHRUN_ADDONS.Scoreboard.scoreboardFrame != nil) then
        DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:Remove()
    end

    -- create a frame that will hold both sides of the GUI.
    local frameWidth = ScrW() / (2*1.6)
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame = vgui.Create("DFrame")
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:SetSize(frameWidth, ScrH() / 1.6)
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:SetCursor("none")
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:Center()
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:SetTitle("")
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:MakePopup();
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:ShowCloseButton(true)
	DEATHRUN_ADDONS.Scoreboard.scoreboardFrame.Paint = function(self, w, h) end

    -- these are the left and right side of the frame.
    DEATHRUN_ADDONS.Scoreboard.scoreboardFrameLeftPanel = vgui.Create("DPanel", DEATHRUN_ADDONS.Scoreboard.scoreboardFrame) -- Can be any panel, it will be stretched
    DEATHRUN_ADDONS.Scoreboard.scoreboardFrameRightPanel = vgui.Create("DPanel", DEATHRUN_ADDONS.Scoreboard.scoreboardFrame)

    -- add a divier to the frame, left side is allocated the left panel and right.etc
    local div = vgui.Create("DHorizontalDivider", DEATHRUN_ADDONS.Scoreboard.scoreboardFrame)
    div:Dock(FILL) -- Make the divider fill the space of the DFrame
    div:SetLeft(DEATHRUN_ADDONS.Scoreboard.scoreboardFrameLeftPanel) -- Set what panel is in left side of the divider
    div:SetRight(DEATHRUN_ADDONS.Scoreboard.scoreboardFrameRightPanel)
    div:SetDividerWidth(4) -- Set the divider width. Default is 8
    div:SetLeftMin(20) -- Set the Minimum width of left side
    div:SetRightMin(20)
    div:SetLeftWidth(frameWidth / 2) -- Set the default left side width

    -- left side scrolling panel
    local leftPanelScroll = vgui.Create("DScrollPanel", DEATHRUN_ADDONS.Scoreboard.scoreboardFrameLeftPanel) -- Create the Scroll panel
    leftPanelScroll:Dock(FILL)

    -- left side list of icons
    local leftPanelScrollList = vgui.Create("DIconLayout", leftPanelScroll)
    leftPanelScrollList:Dock(FILL)
    leftPanelScrollList:SetSpaceY(5) -- Sets the space in between the panels on the Y Axis by 5
    leftPanelScrollList:SetSpaceX(5) -- Sets the space in between the panels on the X Axis by 5

    -- right side scrolling panel
    local rightPanelScroll = vgui.Create("DScrollPanel", DEATHRUN_ADDONS.Scoreboard.scoreboardFrameRightPanel) -- Create the Scroll panel
    rightPanelScroll:Dock(FILL)

    -- right side list of icons
    local rightPanelScrollList = vgui.Create("DIconLayout", rightPanelScroll)
    rightPanelScrollList:Dock(FILL)
    rightPanelScrollList:SetSpaceY(5) -- Sets the space in between the panels on the Y Axis by 5
    rightPanelScrollList:SetSpaceX(5) -- Sets the space in between the panels on the X Axis by 5

    local deathPlayers = team.GetPlayers(TEAM_DEATH)
    local runnerPlayers = team.GetPlayers(TEAM_RUNNERS)

    if (#deathPlayers >= 1) then
        for k, deathPly in pairs(deathPlayers) do
            -- why is player panel nil?
            local playerPanel = rightPanelScrollList:Add("AvatarImage")
            playerPanel:SetSize(64,64) -- saying "attempt to index local "playerPanel" (a nil value)"
            -- im gonna cross it out, to see what happens
            playerPanel:SetPlayer(deathPly, 64) -- wow thats simple lol, didn't even know

            if (deathPly:SteamID() == "STEAM_0:1:26244933") then
                local mat = rightPanelScrollList:Add("Material")
                mat:SetPos(playerPanel:GetPos())
                mat:SetSize(64, 64)
                mat:SetMaterial("models/props_combine/tprings_globe")
            end
        end
    end

    -- for each runner player, add their avatar to the icon list.
    if (#runnerPlayers >= 1) then
        for k, runnerPly in pairs(runnerPlayers) do
            local playerPanel = leftPanelScrollList:Add("AvatarImage")
            playerPanel:SetSize(64,64)
            playerPanel:SetPlayer(runnerPly, 64)

            if (runnerPly:SteamID() == "STEAM_0:1:26244933") then
                local mat = leftPanelScrollList:Add("Material")
                mat:SetSize(64, 64)
                mat:SetMaterial("models/props_combine/tprings_globe")
            end
        end
    end

    if (GetGlobalInt("drf_current_gamestate") == DRF_GAMESTATE_WAITING) then
        for k, ply in pairs(player.GetAll()) do
            local playerPanel = leftPanelScrollList:Add("AvatarImage")
            playerPanel:SetSize(64,64)
            playerPanel:SetPlayer(ply, 64)

            if (ply:SteamID() == "STEAM_0:1:26244933") then
                local mat = leftPanelScrollList:Add("Material")
                mat:SetSize(64, 64)
                mat:SetMaterial("models/props_combine/tprings_globe")
            end
        end
    end
end

function GM:ScoreboardHide()
    if (DEATHRUN_ADDONS.Scoreboard.scoreboardFrame != nil) then
        DEATHRUN_ADDONS.Scoreboard.scoreboardFrame:Remove()
    end
end
end
