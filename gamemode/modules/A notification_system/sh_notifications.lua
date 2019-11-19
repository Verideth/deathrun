if SERVER then

    util.AddNetworkString("DeathrunNotify")

	function DEATHRUN_NotifyAll(pMessage, pCentered)
		for k,v in pairs(player.GetAll()) do
			DEATHRUN_Notify(v, pMessage, pCentered)
		end
	end
    
    function DEATHRUN_Notify(ply, pMessage, pCentered)
        net.Start("DeathrunNotify")
        net.WriteString(pMessage)
        net.WriteBool(pCentered)
        net.Send(ply)
    end


elseif CLIENT then

    net.Receive("DeathrunNotify", function()
        local message = net.ReadString()
        local centered = net.ReadBool()

        DEATHRUN_Notify(message, centered)
    end)

    function DEATHRUN_Notify(pMessage, pCentered)
        if pCentered == nil then pCentered = false end

        -- with :InvalidateLayout( true )
        local backgroundPanel = vgui.Create( "DNotify" )
        if (pCentered) then
            --local xOffset = math.random(-100, 100)
            --local yOffset = math.random(-100, 100)
            backgroundPanel:SetPos( (ScrW() / 2.0), (ScrH() / 2.0) )
        else
            backgroundPanel:SetPos(5, 40)
        end
        backgroundPanel:SetSize(600,600)

        local panel = vgui.Create("DPanel", backgroundPanel)
        panel:SetBackgroundColor(Color(0, 0, 0, 255))

        -- Text label
        local lbl = vgui.Create( "DLabel", panel)
        lbl:SetText(pMessage)
        lbl:SetTextColor( Color(255, 255, 255, 255) )
        lbl:SetFont( "GModNotify" )
        lbl:SetWrap( false )
        lbl:SizeToContents()

        panel:InvalidateLayout()
        panel:SizeToChildren(true, true)

        backgroundPanel:InvalidateLayout(true)
        backgroundPanel:SizeToChildren(true, true)

        backgroundPanel:AddItem( panel )

    --[[
        --Notification panel
        local NotifyPanel = vgui.Create( "DNotify" )
        NotifyPanel:SetPos( 5, 64 )
        NotifyPanel:SetSize( 64, 32 )
        NotifyPanel:SizeToContents()

        -- Gray background panel
        local bg = vgui.Create( "DPanel", NotifyPanel )
        bg:Dock( FILL )
        bg:SetBackgroundColor( Color( 64, 64, 64 ) )

        -- Text label
        local lbl = vgui.Create( "DLabel", bg)
        lbl:SetText(pMessage)
        lbl:SetTextColor( Color( 255, 200, 0 ) )
        lbl:SetFont( "GModNotify" )
        lbl:SetWrap( true )


        -- Add the label to the notification and begin fading
        NotifyPanel:AddItem( bg )
        NotifyPanel:InvalidateLayout( true )
        NotifyPanel:SizeToChildren( true, true )
]]
    end

end