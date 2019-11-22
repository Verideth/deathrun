print("[DRF] loaded notifications system.")

DEATHRUN_ADDONS = DEATHRUN_ADDONS or {} -- preserve the table


-- cleanup derma objects.
if (DEATHRUN_ADDONS.Notify != nil) then
    if ( DEATHRUN_ADDONS.Notify.CleanUp != nil) then
        DEATHRUN_ADDONS.Notify.CleanUp()
    end
end

DEATHRUN_ADDONS.Notify = {}     -- reset the this table every refresh
DEATHRUN_ADDONS.Notify.Enums = {}
DEATHRUN_ADDONS.Notify.Enums["LABEL"] = 1
DEATHRUN_ADDONS.Notify.Enums["WAVEY_TITLE"] = 2
DEATHRUN_ADDONS.Notify.Enums["NORMAL_TITLE"] = 3

if SERVER then

    util.AddNetworkString("DeathrunNotify")

	 DEATHRUN_ADDONS.Notify.NotifyAll = function(pMessage, pNotifyMode)
		for k,v in pairs(player.GetAll()) do
			DEATHRUN_ADDONS.Notify.Notify(v, pMessage, pNotifyMode)
		end
	end

    DEATHRUN_ADDONS.Notify.Notify = function(ply, pMessage, pNotifyMode)
        net.Start("DeathrunNotify")
        net.WriteString(pMessage)
        net.WriteInt(pNotifyMode, 32)
        net.Send(ply)
    end


elseif CLIENT then

    net.Receive("DeathrunNotify", function()
        local message = net.ReadString()
        local mode = net.ReadInt(32)

        DEATHRUN_ADDONS.Notify.Notify(message, mode)
    end)


    DEATHRUN_ADDONS.Notify.CleanUp = function()
        if ( DEATHRUN_ADDONS.Notify.backgroundPanel != nil) then
            DEATHRUN_ADDONS.Notify.backgroundPanel:Remove()
        end
    end


    DEATHRUN_ADDONS.Notify.Notify = function(pMessage, pNotificationMode)
        -- with :InvalidateLayout( true )
        DEATHRUN_ADDONS.Notify.backgroundPanel = vgui.Create( "DNotify" )

        local panel = vgui.Create("DPanel",  DEATHRUN_ADDONS.Notify.backgroundPanel)

        if (pNotificationMode == DEATHRUN_ADDONS.Notify.Enums["LABEL"]) then

         -- Text label

            panel:SetBackgroundColor(Color(c))

            local lbl = vgui.Create( "DLabel", panel)
            lbl:SetText(pMessage)
            lbl:SetTextColor( Color(255, 255, 255, 255) )
            lbl:SetFont( "GModNotify" )
            lbl:SetWrap( false )
            lbl:SizeToContents()

            -- these next lines size the backgroundpanel to the panel and label

            panel:InvalidateLayout()
            panel:SizeToChildren(true, true)

             DEATHRUN_ADDONS.Notify.backgroundPanel:InvalidateLayout(true)
             DEATHRUN_ADDONS.Notify.backgroundPanel:SizeToChildren(true, true)

             DEATHRUN_ADDONS.Notify.backgroundPanel:AddItem( panel )

        elseif (pNotificationMode == DEATHRUN_ADDONS.Notify.Enums["WAVEY_TITLE"]) then
            -- wavey title
            panel:SetBackgroundColor(Color(0, 0, 0, 0))

            local pnl = vgui.Create( "DPanel", panel)
            pnl:SetSize(ScrW(),ScrH())
            pnl.Paint = function(self, w, h)
                surface.SetFont("fdr_futuristic_outline")

                local tw, th = surface.GetTextSize( pMessage )
                DrawSunbeams(0.5, 1, 5, 0.5, 0.0)

                local ox = ScrW()/2 - ((tw + 24)/2)
                local oy = ScrH()/2 - ((th + 19)/2)

                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(ox, oy, tw+24, th + 18)

                surface.SetDrawColor(30, 30, 30, 255)
                surface.DrawRect(ox + 6, oy + 6, tw+12, th + 6)

                surface.SetTextPos(ox + 12, oy + 8)
                surface.SetTextColor(Color(255, 255, 255, 255))
                surface.DrawText(pMessage)
            end


            -- these next lines size the backgroundpanel to the panel and label

            panel:InvalidateLayout()
            panel:SizeToChildren(true, true)

            DEATHRUN_ADDONS.Notify.backgroundPanel:InvalidateLayout(true)
            DEATHRUN_ADDONS.Notify.backgroundPanel:SizeToChildren(true, true)

            DEATHRUN_ADDONS.Notify.backgroundPanel:AddItem( panel )
         elseif (pNotificationMode == DEATHRUN_ADDONS.Notify.Enums["NORMAL_TITLE"]) then
            -- wavey title
            panel:SetBackgroundColor(Color(0, 0, 0, 0))

            local pnl = vgui.Create( "DPanel", panel)
            pnl:SetSize(ScrW(),ScrH())
            pnl.Paint = function(self, w, h)
                surface.SetFont("fdr_futuristic_outline")

                local tw, th = surface.GetTextSize( pMessage )

                local ox = ScrW()/2 - ((tw + 24)/2)
                local oy = ScrH()/2 - ((th + 19)/2)

                surface.SetDrawColor(255, 255, 255, 255)
                surface.DrawRect(ox, oy, tw+24, th + 18)

                surface.SetDrawColor(0, 0, 200, 255)
                surface.DrawRect(ox + 6, oy + 6, tw+12, th + 6)

                surface.SetTextPos(ox + 12, oy + 8)
                surface.SetTextColor(Color(255, 255, 255, 255))
                surface.DrawText(pMessage)

            end


            -- these next lines size the backgroundpanel to the panel and label

            panel:InvalidateLayout()
            panel:SizeToChildren(true, true)

            DEATHRUN_ADDONS.Notify.backgroundPanel:InvalidateLayout(true)
            DEATHRUN_ADDONS.Notify.backgroundPanel:SizeToChildren(true, true)

            DEATHRUN_ADDONS.Notify.backgroundPanel:AddItem( panel )
        end
    end

end
