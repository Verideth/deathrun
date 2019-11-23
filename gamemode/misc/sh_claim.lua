if SERVER then
print("[DRF] loaded claim system")
util.AddNetworkString("claim_use_all")

local claimed_buttons = {}
local initialized = false
local use = 0

function do_claim(ply, ent)
    if (ply:Alive() and
    (ply:Team() == TEAM_DEATH)) then
        for k, v in pairs(ents.FindByClass("func_button")) do
            if (v == ply:GetEyeTraceNoCursor().Entity) then
                ply.has_claimed = true
                ent.is_claimed = true
                ply:ChatPrint("[DRF MESSAGE]: YOU CLAIMED THIS BUTTON")
                table.Add(claimed_buttons, v)
            end
        end
    end
end

function un_claim(ply, ent)
    local iter = 0

    if (claimed_buttons) then
        if (ent:GetOwner() == ply) then
            for k, v in pairs(ents.FindByClass("func_button class")) do
                iter = iter + 1

                if (claimed_buttons[iter] == v) then
                    table.remove(claimed_buttons, iter)
                    ply.has_claimed = false
                    ent.is_claimed = false
                    ply.claimed_ent = nil
                    ent.claimed_ply = nil
                end
            end
        end
    end
end

local claim_tick = function(ply)
    local ent = ply:GetEyeTraceNoCursor().Entity

    if ((ply:Alive() and ent:GetClass() == "func_button")) then
        local iter = 0
        local ent_mat = ent:GetMaterial()
        ply.has_claimed = true

        for k, v in pairs(ents.FindByClass("func_button")) do
            iter = iter + 1

            if (ply.has_claimed == false) then
                ply.has_claimed = true
            end

            if (ply.has_claimed == true) then
                if (claimed_buttons[iter] == v) then
                    ent = v
                    ply.claimed_ent = ent
                    ent.claimed_ply = ply

                    if (ent.is_claimed == true and
                    (ply.claimed_ent == ent) and (ent.claimed_ply == ply)) then
                        if (ply:KeyPressed(IN_RELOAD)) then
                            ply:ChatPrint("[DRF MESSAGE]: YOU UNCLAIMED THIS BUTTON")
                            un_claim(ply, ent)
                        elseif (ply:KeyPressed(IN_USE)) then
                            ply:ChatPrint("[DRF MESSAGE]: YOU USED YOUR CLAIMED BUTTON")
                            ent:Use()
                            un_claim(ply, ent)
                        end
                    end

                    if (ent.is_claimed == true and
                    (ply.claimed_ent != ent) or (ent.claimed_ply != ply) and
                    (ent == v)) then
                        ply:ChatPrint("[DRF MESSAGE]: THIS BUTTON IS CLAIMED BY SOMEBODY ELSE!")
                        v:SetMaterial("materials/gm_construct/grass-sand_13.vmt", true)
                    end
                end
            end
        end
    end
end

local claim_use = function(ply, ent)
    ply = net.ReadEntity()
    ent = net.ReadEntity()

    if (IsValid(ply) and IsValid(ent)) then
        if (ply:Team() == TEAM_DEATH) then
            local target = ply:GetEyeTraceNoCursor().Entity

            if ((ply:Alive() == true) and
            (target.is_claimed == false) and
            (target:GetClass() == "func_button")) then
                DEATHRUN_ADDONS.Notify.Notify("YOU HAVE CLAIMED THIS BUTTON", DEATHRUN_ADDONS.Notify.Enums["LABEL"])
                target.is_claimed = true
                do_claim(ply, ent)
                claim_tick(ply)
            end
        end
    end
end

net.Receive("claim_use_all", claim_use)
end

if CLIENT then
function think_button_claim(ply, ent)
    if (ply:KeyReleased(IN_ALT1)) then
        print("SAW")
        net.Start("claim_use_all")
        net.WriteEntity(ply)
        net.WriteEntity(ent)
        net.SendToServer()
    end

    ent:SetMaterial(ent_mat)
end
end
