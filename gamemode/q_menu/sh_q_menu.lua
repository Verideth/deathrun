DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table

-- cleanup derma objects.
if (DEATHRUN_ADDONS.Menu != nil) then
    if ( DEATHRUN_ADDONS.Menu.CleanUp != nil) then
        DEATHRUN_ADDONS.Menu.CleanUp()
    end
end

DEATHRUN_ADDONS.Menu = {}

if SERVER then


elseif CLIENT then

    DEATHRUN_ADDONS.Menu.Sheets = {}

    hook.Add( "PlayerButtonDown", "openQMenu", function( ply, button )
        if (button == KEY_Q) then
            
        end
    end )

    DEATHRUN_ADDONS.Menu.CleanUp = function()
        DEATHRUN_ADDONS.Menu.MainFrame:Remove()
    end

    DEATHRUN_ADDONS.Menu.ShowQMenu = function()
        -- make sure its a fresh set of derma panels whenever we open it.
        if (DEATHRUN_ADDONS.Menu.MainFrame != nil) then
            DEATHRUN_ADDONS.Menu.MainFrame:Remove()
        end

        DEATHRUN_ADDONS.Menu.MainFrame = vgui.Create( "DFrame" )
        DEATHRUN_ADDONS.Menu.MainFrame:SetSize( 500, 300 )
        DEATHRUN_ADDONS.Menu.MainFrame:Center()
        DEATHRUN_ADDONS.Menu.MainFrame:SetTitle("Q Menu")
        DEATHRUN_ADDONS.Menu.MainFrame:MakePopup()

        local sheetsContainer = vgui.Create( "DColumnSheet", DEATHRUN_ADDONS.Menu.MainFrame )
        sheetsContainer:Dock(FILL)

        -- these functions are defined in /team_switch/sh_team_switch.lua
        -- now we get every sheet defined in the entire program.
        local teamManagerDermaPanel = DEATHRUN_ADDONS.TeamManager.GetQMenuDermaPanel(sheetsContainer)
        local teamManagerButtonInfo = DEATHRUN_ADDONS.TeamManager.GetQMenuButtonInfo()
        DEATHRUN_ADDONS.Menu.MainFrame.TeamSwitchSheet = sheetsContainer:AddSheet(teamManagerButtonInfo.ButtonName, teamManagerDermaPanel, teamManagerButtonInfo.IconName)
    end

end
