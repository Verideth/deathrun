if SERVER then
print("loaded claim system")
util.AddNetworkString("claim_data")

local claimed_buttons = {}
local initialized = false

function init_claim_system()
    if (initialized == false) then
        net.Receive("claim_data", claim_think)
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

local claim_think = function(ply)
    local ent = ply:GetEyeTraceNoCursor().Entity

    if ((ply:Alive() and ent:GetClass() == "func_button")) then
        local iter = 0
        local ent_mat = ent:GetMaterial()

        for k, v in pairs(ents.FindByClass("func_button")) do
            iter = iter + 1
            if (ply.has_claimed == true) then
                if (claimed_buttons[iter] == v) then
                    if (ply:KeyPressed(IN_RELOAD)) then
                        un_claim(ply, ent)
                        ply:ChatPrint("[DRF MESSAGE]: YOU UNCLAIMED " .. ent:GetName())
                    elseif (ply:KeyPressed(IN_USE)) then
                        ply:ChatPrint("[DRF MESSAGE]: YOU USED YOUR CLAIMED BUTTON")
                        ent:Use()
                    end
                end

                if (ent.is_claimed == true) then
                    ply:ChatPrint("[DRF MESSAGE] this button is claimed by somebody else!")
                    entx:SetMaterial("gm_construct/grass-sand_13.vmt", true)
                end
            end

            ent:SetMaterial(ent_mat.GetMaterial())
        end
    end
end

function use(ply, ent, mode) -- goes inside the PlayerUse hook
    if (ply:Team() == TEAM_DEATH) then
        local target = ply:GetEyeTraceNoCursor().Entity

        if ((ply:Alive() == true) and (ent:GetClass() == "func_button")) then
            target.is_claimed = true

            do_claim(ply, ent)
        end
    end
end
end
