require('LiA_GameMode')
require('utils')
require('LiA_ForceRound')
require('survival/AIcreeps')
require('timers')
require('timerPopup')
require('physics')


function Activate()
	GameRules.LiA = LiA()
	GameRules.LiA:InitGameMode()
end

function Precache( context )
		--
		PrecacheUnitByNameAsync("npc_water_elemental_1", function(...) end)
		PrecacheUnitByNameAsync("npc_water_elemental_2", function(...) end)
		PrecacheUnitByNameAsync("npc_water_elemental_3", function(...) end)
		PrecacheUnitByNameAsync("npc_water_elemental_4", function(...) end)

		PrecacheUnitByNameAsync("spirit_of_the_plains1", function(...) end)
		PrecacheUnitByNameAsync("spirit_of_the_plains2", function(...) end)
		PrecacheUnitByNameAsync("spirit_of_the_plains3", function(...) end)

		PrecacheUnitByNameAsync("ghost_1", function(...) end)
		PrecacheUnitByNameAsync("ghost_2", function(...) end)
		PrecacheUnitByNameAsync("ghost_3", function(...) end)
		PrecacheUnitByNameAsync("ghost_4", function(...) end)

		PrecacheUnitByNameAsync("necromancer_skeleton1", function(...) end)
		PrecacheUnitByNameAsync("necromancer_skeleton2", function(...) end)
		PrecacheUnitByNameAsync("necromancer_skeleton3", function(...) end)
		PrecacheUnitByNameAsync("necromancer_skeleton4", function(...) end)

		PrecacheUnitByNameAsync("pure_light_totem", function(...) end)
		
		PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_cyclone.vpcf" , context)
		--Берсеркер
		PrecacheResource("particle", "particles/units/heroes/hero_huskar/huskar_base_attack.vpcf" , context)
		PrecacheResource("particle", "particles/units/heroes/hero_huskar/huskar_burning_spear.vpcf" , context)
		PrecacheResource("particle", "particles/units/heroes/hero_mirana/mirana_spell_arrow.vpcf" , context)
		PrecacheResource("particle", "particles/units/heroes/hero_huskar/huskar_burning_spear_debuff.vpcf" , context)
		PrecacheResource("particle", "particles/units/heroes/hero_ursa/ursa_enrage_buff.vpcf" , context)
		--Нага-Гвардеец
		PrecacheResource("particle", "particles/generic_gameplay/generic_stunned.vpcf", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_slardar.vsndevts", context)	
		PrecacheResource("particle", "particles/units/heroes/hero_morphling/morphling_waveform.vpcf", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_morphling.vsndevts", context)
		PrecacheResource("particle", "particles/units/heroes/hero_slardar/slardar_crush.vpcf", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_naga_siren.vsndevts", context)
		--Генерал
		PrecacheResource("particle", "particles/units/heroes/hero_chaos_knight/chaos_knight_chaos_bolt.vpcf", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_chaos_knight.vsndevts", context)	
		PrecacheResource("particle", "particles/units/heroes/hero_chaos_knight/chaos_knight_bolt_msg.vpcf", context)
		--Валькирия
		PrecacheResource("particle", "particles/units/heroes/hero_phantom_assassin/phantom_assassin_crit_impact_drops_b_lv.vpcf", context)	
		PrecacheResource("particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_battletrance_buff.vpcf", context)			
		--Дайс
		PrecacheResource("particle", "particles/status_fx/status_effect_beserkers_call.vpcf", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_axe.vsndevts", context)	

		--Пивовар
		PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_drunken_haze_debuff.vpcf", context)
		PrecacheResource("particle", "particles/units/heroes/hero_kunkka/kunkka_spell_tidebringer.vpcf", context)	
		--Голем
		PrecacheResource("particle", "particles/units/heroes/hero_brewmaster/brewmaster_fire_immolation_child.vpcf", context)			
		PrecacheResource("particle", "particles/units/heroes/hero_techies/techies_land_mine_explode.vpcf", context)		

		PrecacheUnitByNameAsync("npc_dota_hero_terrorblade", function(...) end)
		PrecacheUnitByNameAsync("npc_dota_hero_mirana", function(...) end)
		
		PrecacheUnitByNameAsync("5_wave_megaboss", function(...) end)
		PrecacheUnitByNameAsync("10_wave_megaboss", function(...) end)
		PrecacheUnitByNameAsync("15_wave_megaboss", function(...) end)
		PrecacheUnitByNameAsync("orn_megaboss", function(...) end)
		PrecacheUnitByNameAsync("orn_mutant_boss", function(...) end)
		PrecacheUnitByNameAsync("npc_lia_boar", function(...) end)
		PrecacheUnitByNameAsync("item_lia_healing_ward_unit", function(...) end)

		PrecacheUnitByNameAsync("white_wolf_bm", function(...) end)
		PrecacheUnitByNameAsync("jungle_stalker_bm", function(...) end)
		PrecacheUnitByNameAsync("phoenix_bm", function(...) end)
		PrecacheUnitByNameAsync("bear_bm", function(...) end)
		PrecacheUnitByNameAsync("phoenix_egg_bm", function(...) end)

		
		PrecacheItemByNameAsync("item_lia_lightning_bow", function(...) end)	
		PrecacheItemByNameAsync("item_lia_staff_of_help", function(...) end)
		PrecacheItemByNameAsync("item_lia_staff_of_help_2", function(...) end)
		PrecacheItemByNameAsync("item_lia_ice_sword", function(...) end)
		PrecacheItemByNameAsync("item_lia_rune_of_lifesteal", function(...) end)
		
		PrecacheItemByNameAsync("item_lia_spherical_staff", function(...) end)
		PrecacheUnitByNameAsync("spherical_staff_fire_golem", function(...) end)	

		
		PrecacheResource("particle", "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf", context)			
		--Щит Смерти
		PrecacheResource("particle", "particles/units/heroes/hero_queenofpain/queen_scream_of_pain_owner.vpcf", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_invoker.vsndevts", context)		
		--Мифриловый Доспех
		PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_spell_warcry.vpcf", context)
		PrecacheResource("particle", "particles/units/heroes/hero_sven/sven_warcry_buff.vpcf", context)		
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_sven.vsndevts", context)		
		--Лунное Колье
		PrecacheResource("particle", "particles/units/heroes/hero_luna/luna_eclipse.vpcf", context)		
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_luna.vsndevts", context)		
		--Перчатки Огня
		PrecacheResource("particle", "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf", context)		
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ember_spirit.vsndevts", context)		
		--Посох Помощи
		PrecacheResource("particle", "particles/custom/dazzle_shadow_wave_copy.vpcf", context)
		PrecacheResource("particle", "particles/custom/dazzle_shadow_wave.vpcf", context)		
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dazzle.vsndevts", context)	
		--Сапоги-Неведимки
		PrecacheResource("particle", "particles/units/heroes/hero_bounty_hunter/bounty_hunter_windwalk.vpcf", context)		
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_bounty_hunter.vsndevts", context)		
		--Перчатка Боли
		PrecacheResource("particle", "particles/units/heroes/hero_zuus/zuus_arc_lightning.vpcf", context)		
		PrecacheResource("soundfile", "sounds/items/item_mjoll_on.vsnd", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_zuus.vsndevts", context)	
		--Жезл Огня
		PrecacheResource("particle", "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf", context)		
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_dragon_knight.vsndevts", context)	
		--Посох Света
		PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification_light_b.vpcf", context)
		PrecacheResource("particle", "particles/units/heroes/hero_omniknight/omniknight_purification_h.vpcf", context)	
		--Книга Мертвых
		PrecacheModel("models/items/clinkz/demonspinerecurve_lod1/demonspinerecurve_lod1.mdl", context)
		PrecacheModel("models/items/clinkz/clinkz_hands_goc/clinkz_hands_goc.mdl", context)
		PrecacheModel("models/items/clinkz/clinkz_shoulders_goc/clinkz_shoulders_goc.mdl", context)
		PrecacheModel("models/items/clinkz/clinkz_helmet01_goc/clinkz_helmet01_goc.mdl", context)
		PrecacheModel("models/heroes/clinkz/clinkz_head.mdl", context)	
		PrecacheModel("models/heroes/clinkz/clinkz.vmdl", context)	
		PrecacheModel("models/heroes/clinkz/clinkz_back.mdl", context)			
		PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_base_attack.vpcf", context)
		PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_body_fire.vpcf", context)
		PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_bow.vpcf", context)
		PrecacheResource("particle", "particles/units/heroes/hero_clinkz/clinkz_body_arm_fire.vpcf", context)
		--Тролль-защитник
		PrecacheModel("models/heroes/troll_warlord/troll_warlord.vmdl", context)
		PrecacheModel("models/heroes/troll_warlord/troll_warlord_axe_ranged_l.mdl", context)	
		PrecacheModel("models/heroes/troll_warlord/troll_warlord_axe_ranged_r.mdl", context)			
		PrecacheResource("particle", "particles/units/heroes/hero_troll_warlord/troll_warlord_base_attack.vpcf", context)		
		--Статуэтка Демона
		PrecacheModel("models/heroes/doom/doom.vmdl", context)
		PrecacheModel("models/items/doom/impending_transgressions_back/impending_transgressions_back.mdl", context)
		PrecacheModel("models/items/doom/crown_of_omoz/crown_of_omoz.mdl", context)
		PrecacheModel("models/items/doom/weapon_eyeoffetitzu/weapon_eyeoffetitzu.mdl", context)
		PrecacheModel("models/items/doom/impending_transgressions_arms/impending_transgressions_arms.mdl", context)	
		PrecacheModel("models/items/doom/impending_transgressions_tail/impending_transgressions_tail.mdl", context)	
		PrecacheModel("models/items/doom/impending_transgressions_shoulders/impending_transgressions_shoulders.mdl", context)
		PrecacheModel("models/items/doom/impending_transgressions_belt/impending_transgressions_belt.mdl", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_doombringer.vsndevts", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_centaur.vsndevts", context)	
		PrecacheResource("particle", "particles/units/heroes/hero_doom_bringer/doom_loadout.vpcf", context)		
		PrecacheResource("particle_folder", "particles/units/heroes/hero_doom_bringer", context)	
		--Адская тварь
		PrecacheResource("particle", "particles/units/heroes/hero_ogre_magi/ogre_magi_bloodlust_buff.vpcf", context)	
		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_ogre_magi.vsndevts", context)
		PrecacheResource("particle_folder", "particles/units/heroes/hero_faceless_void", context)		

		PrecacheResource("soundfile", "soundevents/game_sounds_heroes/game_sounds_magnataur.vsndevts", context)
		PrecacheResource("particle_folder", "particles/units/heroes/hero_weaver/weaver_timelapse.vpcf", context)	
		PrecacheResource("particle","particles/econ/events/nexon_hero_compendium_2014/blink_dagger_end_nexon_hero_cp_2014.vpcf", context) --партикл для спавна крипов на волнах
		PrecacheResource("particle","particles/units/heroes/hero_treant/treant_livingarmor.vpcf", context)

		PrecacheResource("particle","particles/black_screen.vpcf", context)

		PrecacheModel("models/creeps/lane_creeps/creep_dire_hulk/creep_dire_diretide_ancient_hulk.vmdl", context)
		PrecacheModel("models/creeps/lane_creeps/creep_radiant_hulk/creep_radiant_diretide_ancient_hulk.vmdl", context)
		
end