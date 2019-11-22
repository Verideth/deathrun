if SERVER then
print("[DRF] loaded claim system")
util.AddNetworkString("claim_use_all")

local claimed_buttons = {}
local initialized = false
local use = 0

function init_claim_system()
    if (initialized == false) then
        initialized = true
        return true
    end

    return true
end

function do_claim(ply, ent)
    if (ply:Alive() and
    (ply:Team() == TEAM_DEATH)) then
        for k, v in pairs(ents.FindByClass("func_button")) do
            if (v == ply:GetViewEntity()) then
                ply.has_claimed = true
                ent.is_claimed = true
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
                ply.claimed_ent = ent
                ent.claimed_ply = ply

                print("currently true")
                if (claimed_buttons[iter] == v) then
                    if (ply:KeyPressed(IN_RELOAD)) then
                        un_claim(ply, ent)
                        ply:ChatPrint("[DRF MESSAGE]: YOU UNCLAIMED " .. ent:GetName())
                    elseif (ply:KeyPressed(IN_USE)) then
                        ply:ChatPrint("[DRF MESSAGE]: YOU USED YOUR CLAIMED BUTTON")
                        ent:Use()
                    end
                end

                if (ent.is_claimed == true and
                (ply.claimed_ent != ent) or (ent.claimed_ply != ply)) then
                    ply:ChatPrint("[DRF MESSAGE] this button is claimed by somebody else!")
                    ent:SetMaterial("gm_construct/grass-sand_13.vmt", true)
                end

                if (ent.is_claimed == true and
                (ply.claimed_ent != ent) or (ent.claimed_ply != ply)) then
                    ply:ChatPrint("[DRF MESSAGE] this button is claimed by somebody else!")
                    ent:SetMaterial("gm_construct/grass-sand_13.vmt", true)
                end
            end

            ent:SetMaterial(ent_mat)
        end
    end
end

local claim_use = function(ply, ent)
    ply = net.ReadEntity()
    ent = net.ReadEntity()

    if (ply:Team() == TEAM_DEATH) then
        local target = ply:GetEyeTraceNoCursor().Entity

        if ((ply:Alive() == true) and (target:GetClass() == "func_button")) then
            target.is_claimed = true
            print("CLAIMED " .. ent:GetClass())
            do_claim(ply, ent)
            claim_tick(ply)
        end
    end
end

net.Receive("claim_use_all", claim_use)
end

if CLIENT then
function think_button_claim(ply, ent)
    if (ply:KeyReleased(IN_ALT1)) then
        print("logging")
        net.Start("claim_use_all")
        net.WriteEntity(ply)
        net.WriteEntity(ent)
        net.SendToServer()
    end
end
end
