GM.Name = "Deathrun"
GM.Author = "Verideth and Bambo"
GM.Email = "N/A"
GM.Website = "N/A"

TEAM_RUNNERS = 2
TEAM_DEATH = 3
TEAM_WAITING = -1
drf_maps = {}

include("misc/sh_rounds.lua")

function GM:CreateTeams()
    team.SetUp(TEAM_SPECTATOR, "Spectator", Color(25, 100, 100, 255), false)
    team.SetUp(TEAM_RUNNERS, "Runners", Color(100, 100, 220, 255), false)
    team.SetUp(TEAM_DEATH, "Death", Color(220, 100, 100, 255), false)

    team.SetSpawnPoint(TEAM_RUNNERS, "info_player_counterterrorist")
    team.SetSpawnPoint(TEAM_DEATH, "info_player_terrorist")
    team.SetSpawnPoint(TEAM_SPECTATOR, "info_player_counterterrorist")
end

function GM:PhysgunPickup(ply, entity)
    if (not ply:IsSuperAdmin()) then
        return false
    end

    if (not IsValid(entity)) then
        return false
    end

    if (not entity:IsWeapon()) then
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

-- somebody else made this. took from old deathrun gamemode.
-- mimics CSS movement inside of GMod
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
