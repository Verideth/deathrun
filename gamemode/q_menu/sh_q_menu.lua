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
            if DEATHRUN_ADDONS.Menu.IsOpen = false then -- only show the derma if its not open.
                DEATHRUN_ADDONS.Menu.ShowQMenu()
            end

            DEATHRUN_ADDONS.Menu.IsOpen = true
        end
    end )

    DEATHRUN_ADDONS.Menu.ShowQMenu = function()
        local frame = vgui.Create( "DFrame" )
        frame:SetSize( 500, 300 )
        frame:Center()
        frame:SetTitle("Q Menu")
        frame:MakePopup()

        local sheetsContainer = vgui.Create( "DColumnSheet", frame )
        sheetsContainer:Dock("FILL")

        -- now we get every sheet defined in the entire program.
        local teamSwitchDerma = DEATHRUN_ADDONS.TeamSwitch.GetQMenuSheet()
        local teamSwitchSheetsButtonInfo = DEATHRUN_ADDONS.TeamSwitch.GetQMenuSheetButtonInfo()
        sheet:AddSheet
    end

end