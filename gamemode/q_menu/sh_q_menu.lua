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

    DEATHRUN_ADDONS.Menu.IsOpen = false
    DEATHRUN_ADDONS.Menu.Sheets = {}

    hook.Add( "PlayerButtonDown", "openQMenu", function( ply, button )
        if (button == KEY_Q) then
            if DEATHRUN_ADDONS.Menu.IsOpen == false then -- only show the derma if its not open.
                DEATHRUN_ADDONS.Menu.ShowQMenu()
            end

            DEATHRUN_ADDONS.Menu.IsOpen = true
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

        local sheetsContainer = vgui.Create( "DColumnSheet", frame )
        sheetsContainer:Dock("FILL")

        -- these functions are defined in /team_switch/sh_team_switch.lua
        -- now we get every sheet defined in the entire program.
        local teamSwitchDermaPanel = DEATHRUN_ADDONS.TeamSwitch.GetQMenuDermaPanel(sheetsContainer)
        local teamSwitchButtonInfo = DEATHRUN_ADDONS.TeamSwitch.GetQMenuButtonInfo()
        DEATHRUN_ADDONS.Menu.MainFrame.TeamSwitchSheet = sheetsContainer:AddSheet(teamSwitchButtonInfo.ButtonName, teamSwitchDermaPanel, teamSwitchButtonInfo.IconName)
    end

end
