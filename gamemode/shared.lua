GM.Name = "Deathrun"
GM.Author = "Verideth and Bambo"
GM.Email = "N/A"
GM.Website = "N/A"

GM.AllowSpectating = true

TEAM_RUNNERS = 2
TEAM_DEATH = 3

include("notifications/sh_notifications.lua")
include("cl_hud.lua")
include("misc/sv_rounds.lua")
include("misc/sh_claim.lua")
include("q_menu/sh_q_menu.lua")
include("scoreboard/cl_scoreboard.lua")

function GM:CreateTeams()
    team.SetUp(TEAM_SPECTATOR, "Spectator", Color(255, 210, 210, 155), true)
    team.SetUp(TEAM_RUNNERS, "Runners", Color(100, 100, 220, 255), false)
    team.SetUp(TEAM_DEATH, "Death", Color(220, 100, 100, 255), false)

    team.SetSpawnPoint(TEAM_RUNNERS, "info_player_counterterrorist")
    team.SetSpawnPoint(TEAM_DEATH, "info_player_terrorist")
end

function GM:PhysgunPickup(ply, entity)
    if (ply:IsSuperAdmin() == false) then
        return false
    end

    if (IsValid(entity) == false) then
        return false
    end

    if (entity:IsWeapon() == false) then
        return false
    end

    return true
end

function GM:PlayerNoClip(ply, state)
    if not ply:IsAdmin() then
        return false
    else
        return true
    end
end

function GM:PlayerUse(ply, ent)
    if (ply:Alive() == false) then
        return false
    end

    if (ent:IsValid() == nil) then
        return false
    end

    return true
end

-- somebody else made this. took from old deathrun gamemode. thank you Mr-Gash
-- mimics CSS movement inside of GMod
-- azuisleet i think is the guys name who did.
function GM:Move(pl, movedata)
	if pl:IsOnGround() or !pl:Alive() or pl:WaterLevel() > 0 then return end

	local aim = movedata:GetMoveAngles()
	local forward, right = aim:Forward(), aim:Right()
	local fmove = movedata:GetForwardSpeed()
	local smove = movedata:GetSideSpeed()

	forward.z, right.z = 0,0
	forward:Normalize()
	right:Normalize()

	local wishvel = forward * fmove + right * smove
	wishvel.z = 0

	local wishspeed = wishvel:Length()

	if(wishspeed > movedata:GetMaxSpeed()) then
		wishvel = wishvel * (movedata:GetMaxSpeed()/wishspeed)
		wishspeed = movedata:GetMaxSpeed()
	end

	local wishspd = wishspeed
	wishspd = math.Clamp(wishspd, 0, 30)

	local wishdir = wishvel:GetNormal()
	local current = movedata:GetVelocity():Dot(wishdir)

	local addspeed = wishspd - current

	if(addspeed <= 0) then return end

	local accelspeed = (120) * wishspeed * FrameTime()

	if(accelspeed > addspeed) then
		accelspeed = addspeed
	end

	local vel = movedata:GetVelocity()
	vel = vel + (wishdir * accelspeed)
	movedata:SetVelocity(vel)

	return false
end
