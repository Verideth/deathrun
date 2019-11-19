AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("drf_draw.lua")
AddCSLuaFile("cl_hud.lua")
include("shared.lua")

-- Load all the files in the modules file.
local fol = GM.FolderName .. "/gamemode/modules/"
local files, folders = file.Find(fol .. "*", "LUA")
for _, folder in SortedPairs(folders, true) do
    for _, File in SortedPairs(file.Find(fol .. folder .. "/sh_*.lua", "LUA"), true) do
        AddCSLuaFile(fol .. folder .. "/" .. File)
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/sv_*.lua", "LUA"), true) do
        include(fol .. folder .. "/" .. File)
    end

    for _, File in SortedPairs(file.Find(fol .. folder .. "/cl_*.lua", "LUA"), true) do
        AddCSLuaFile(fol .. folder .. "/" .. File)
    end
end

function GM:PlayerInitialSpawn(ply)

end

function GM:PlayerSpawn(ply)
    if (ply:Team() == TEAM_SPECTATOR) then
        ply:Spectate(OBS_MODE_ROAMING)
        ply:StripWeapons()
        ply:SetWalkSpeed(300)
        ply:SetRunSpeed(1000)
        return nil
    end

    ply:Give("weapon_crowbar")

    local team = math.random(1, 3)
    if (team == 1) then
        ply:SetTeam(TEAM_RUNNERS)
    end

    if (team == 2) then
        ply:SetTeam(TEAM_DEATH)
    end

    local model = math.random(0, 20)
    if (ply:Team() == TEAM_RUNNERS) then
        if (model == 0) then
            ply:SetModel("models/player/barney.mdl")
        end

        if (model == 1) then
            ply:SetModel("models/player/alyx.mdl")
        end

        if (model == 2) then
            ply:SetModel("models/player/breen.mdl")
        end

        if (model == 3) then
            ply:SetModel("models/player/p2_chell.mdl")
        end

        if (model == 4) then
            ply:SetModel("models/player/eli.mdl")
        end

        if (model == 5) then
            ply:SetModel("models/player/gman_high.mdl")
        end

        if (model == 6) then
            ply:SetModel("models/player/kleiner.mdl")
        end

        if (model == 7) then
            ply:SetModel("models/player/monk.mdl")
        end

        if (model == 8) then
            ply:SetModel("models/player/police.mdl")
        end

        if (model == 9) then
            ply:SetModel("models/player/police_fem.mdl")
        end

        if (model == 10) then
            ply:SetModel("models/player/combine_super_soldier.mdl")
        end

        if (model == 11) then
            ply:SetModel("models/player/Group01/male_07.mdl")
        end

        if (model == 12) then
            ply:SetModel("models/player/Group01/male_09.mdl")
        end

        if (model == 13) then
            ply:SetModel("models/player/Group03m/female_05.mdl")
        end

        if (model == 14) then
            ply:SetModel("models/player/Group03m/female_06.mdl")
        end

        if (model == 15) then
            ply:SetModel("models/player/Group03m/female_03.mdl")
        end

        if (model == 16) then
            ply:SetModel("models/player/Group03m/female_02.mdl")
        end

        if (model == 17) then
            ply:SetModel("models/player/leet.mdl")
        end

        if (model == 18) then
            ply:SetModel("models/player/hostage/hostage_04.mdl")
        end

        if (model == 19) then
            ply:SetModel("models/player/Group03m/male_05.mdl")
        end

        if (model == 20) then
            ply:SetModel("models/player/Group03m/male_02.mdl")
        end

        ply:SetWalkSpeed(250)
        ply:SetRunSpeed(300)
        ply:SetJumpPower(220)
    end

    if (ply:Team() == TEAM_DEATH) then
        ply:SetModel("models/player/skeleton.mdl")
        ply:SetWalkSpeed(500)
        ply:SetRunSpeed(750)
        ply:SetJumpPower(300)
    end

    ply:SetHealth(100)
end

function GM:PlayerLoadout(ply)
    ply:Give("weapon_crowbar")

    return true
end
