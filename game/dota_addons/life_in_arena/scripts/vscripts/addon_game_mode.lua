require('LiA_GameMode')
require('LiA_Common')
require('timers')
require('consolecommands')

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
		
		--4 волна
		PrecacheResource("particle", "particles/base_attacks/ranged_badguy.vpcf" , context)
		
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
		
		--9 волна
		PrecacheModel("models/heroes/morphling/morphling.vmdl", context)
		
		PrecacheModel("models/items/morphling/ancient_armor_arms/ancient_armor_arms.mdl", context)
		PrecacheModel("models/items/morphling/ancient_armor_back/ancient_armor_back.mdl"	, context)
		PrecacheModel("models/items/morphling/ancient_armor_breastplates/ancient_armor_breastplates.mdl", context)
		PrecacheModel("models/items/morphling/ancient_armor_head/ancient_armor_head.mdl", context)
		PrecacheModel("models/items/morphling/ancient_armor_shoulders/ancient_armor_shoulders.mdl", context)	
		
		PrecacheResource("particle", "particles/units/heroes/hero_morphling/morphling_base_attack.vpcf", context)

		--10 волна
		PrecacheModel("models/heroes/faceless_void/faceless_void.vmdl", context)
		
		PrecacheModel("models/items/faceless_void/timelord_bracers/timelord_bracers.mdl", context)
		PrecacheModel("models/items/faceless_void/timelord_head/timelord_head.mdl"	, context)
		PrecacheModel("models/items/faceless_void/timelord_shoulders/timelord_shoulders.mdl", context)
		PrecacheModel("models/items/faceless_void/timelord_skirt/timelord_skirt.mdl", context)
		PrecacheModel("models/items/faceless_void/timelord_weapon/timelord_weapon.mdl", context)	
		
		--11 волна
		PrecacheModel("models/items/beastmaster/boar/beast_deming/beast_deming.vmdl", context)

		--15 волна
		PrecacheModel("models/heroes/life_stealer/life_stealer.vmdl", context)	
			
		--16 волна
		PrecacheResource("particle", "particles/neutral_fx/ghost_base_attack.vpcf" , context)			
		
		--17 волна
		PrecacheModel("models/heroes/nerubian_assassin/nerubian_assassin.vmdl", context)
		
		PrecacheModel("models/heroes/nerubian_assassin/nerubian_assassin_helmet.mdl", context)
		PrecacheModel("models/heroes/nerubian_assassin/nerubian_assassin_weapon.mdl", context)
		PrecacheModel("models/heroes/nerubian_assassin/nerubian_assassin_armor.mdl", context)
		

		--18 волна
		PrecacheModel("models/heroes/viper/viper.vmdl", context)
		PrecacheResource("particle", "particles/units/heroes/hero_viper/viper_base_attack.vpcf" , context)
		
		
		--20 волна
		PrecacheModel("models/heroes/juggernaut/juggernaut.vmdl", context)
		
		PrecacheModel("models/items/juggernaut/thousand_faces_hakama/thousand_faces_hakama.mdl", context)
		PrecacheModel("models/items/juggernaut/thousand_faces_vest/thousand_faces_vest.mdl"	, context)
		PrecacheModel("models/items/juggernaut/thousand_faces_mask/thousand_faces_mask.mdl", context)
		PrecacheModel("models/items/juggernaut/thousand_faces_katana/thousand_faces_katana.mdl", context)
		PrecacheModel("models/items/juggernaut/thousand_faces_wraps/thousand_faces_wraps.mdl", context)	

		PrecacheModel("models/heroes/undying/undying_minion.vmdl", context)				
end