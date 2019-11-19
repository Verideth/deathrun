-- sounds have to be in the 16 bit 44100hz sample rate.
if SERVER then
	resource.AddFile("sound/applausee3.wav")
elseif CLIENT then
	sound.Add({
		name = "applause",
		channel = CHAN_STATIC,
		volume = 1.0,
		level = 80,
		pitch = { 95, 110 },
		sound = "applausee3.wav"
	})
end