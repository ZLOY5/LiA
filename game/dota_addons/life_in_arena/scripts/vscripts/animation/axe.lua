model:CreateSequence(
	{
		name = "counter_helix_loop",

		--sequences = {
        --    { "counter_helix_anim" }
        --},

        fps = 30,

		activities = {
			{ name = "ACT_DOTA_CAST_ABILITY_5", weight = 1 }
		},

		looping = true,

		cmds = {
			{ cmd = "fetchframerange", sequence = "counter_helix_anim", startframe = 2, endframe = 11, dst = 0 }
		}
	}
)