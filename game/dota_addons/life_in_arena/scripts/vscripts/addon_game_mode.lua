require('LiA_GameMode')
require('LiA_Common')
require('timers')

function Precache( context )
end

function Activate()
	GameRules.LiA = LiA()
	GameRules.LiA:InitGameMode()
end

function Precache( context )
		--1 волна
		PrecacheModel("models/heroes/sand_king/sand_king.mdl", context)
		
		PrecacheModel("models/items/sand_king/deserts_deathly_embrace_head/deserts_deathly_embrace_head.mdl", context)
		PrecacheModel("models/items/sand_king/deserts_deathly_embrace_arms/deserts_deathly_embrace_arms.mdl", context)
		PrecacheModel("models/items/sand_king/deserts_deathly_embrace_tail/deserts_deathly_embrace_tail.mdl", context)
		PrecacheModel("models/items/sand_king/deserts_deathly_embrace_legs/deserts_deathly_embrace_legs.mdl", context)
		PrecacheModel("models/items/sand_king/deserts_deathly_embrace_shoulder/deserts_deathly_embrace_shoulder.mdl", context)	

		PrecacheModel("models/heroes/sand_king/sand_king_head.mdl", context)
		PrecacheModel("models/heroes/sand_king/sand_king_tail.mdl", context)
		PrecacheModel("models/heroes/sand_king/sand_king_shoulder.mdl", context)
		PrecacheModel("models/heroes/sand_king/sand_king_arms.mdl", context)
		PrecacheModel("models/heroes/sand_king/sand_king_legs.mdl", context)				
		
		PrecacheResource("particle", "particles/units/heroes/hero_sandking/sandking_portrait.vpcf", context)
		--3 волна
		PrecacheModel("models/creeps/neutral_creeps/n_creep_dragonspawn_b/n_creep_dragonspawn_b.vmdl", context)
		PrecacheModel("models/creeps/neutral_creeps/n_creep_dragonspawn_a/n_creep_dragonspawn_a.vmdl" , context)
		
		--5 волна (мегабосс)
		PrecacheModel("models/heroes/ursa/ursa.vmdl", context)

		--6 волна
		PrecacheModel("models/heroes/bounty_hunter/bounty_hunter.vmdl", context)
		
		PrecacheModel("models/items/bounty_hunter/corruption_mask/corruption_mask.mdl", context)
		PrecacheModel("models/items/bounty_hunter/corruption_armor/corruption_armor.mdl", context)
		PrecacheModel("models/items/bounty_hunter/corruption_offhand/corruption_offhand.mdl", context)
		PrecacheModel("models/items/bounty_hunter/corruption_shoulder/corruption_shoulder.mdl", context)
		PrecacheModel("models/items/bounty_hunter/corruption_weapon/corruption_weapon.mdl", context)	

		PrecacheModel("models/heroes/bounty_hunter/bounty_hunter_pads.mdl", context)
		PrecacheModel("models/heroes/bounty_hunter/bounty_hunter_bweapon.mdl", context)
		PrecacheModel("models/heroes/bounty_hunter/bounty_hunter_rweapon.mdl", context)
		PrecacheModel("models/heroes/bounty_hunter/bounty_hunter_lweapon.mdl", context)	

		--7 волна
		PrecacheModel("models/items/furion/treant_stump.vmdl" , context)	
		
		--8 волна
		PrecacheModel("models/heroes/sven/sven.vmdl", context)
		
		PrecacheModel("models/items/sven/mask_freelancer.mdl", context)
		PrecacheModel("models/items/sven/mask_freelancer.mdl"	, context)
		PrecacheModel("models/items/sven/shoulder_freelancer.mdl"	, context)
		PrecacheModel("models/items/sven/belt_freelancer.mdl", context)
		PrecacheModel("models/items/sven/sword_freelancer.mdl", context)	

		PrecacheModel("models/heroes/sven/sven_mask.vmdl", context)
		PrecacheModel("models/heroes/sven/sven_sword.vmdl", context)
		PrecacheModel("models/heroes/sven/sven_gauntlet.vmdl", context)

		
end