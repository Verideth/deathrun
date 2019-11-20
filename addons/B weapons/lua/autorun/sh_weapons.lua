if SERVER then

	concommand.Add("give_applausestick", function(ply)
		ply:Give("shout_stick")
	end)

elseif CLIENT then

end