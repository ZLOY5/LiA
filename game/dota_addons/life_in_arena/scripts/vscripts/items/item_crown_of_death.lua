
--[[ ============================================================================================================
Based on Rook's datadriven Dagon
================================================================================================================= ]]
function item_crown_of_death_datadriven_on_spell_start(keys)

	if keys.target:TriggerSpellAbsorb(keys.ability) then
		return 
	end

	local crown_of_death_particle = ParticleManager:CreateParticle("particles/items_fx/dagon.vpcf",  PATTACH_ABSORIGIN_FOLLOW, keys.caster)
	ParticleManager:SetParticleControlEnt(crown_of_death_particle, 1, keys.target, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.target:GetAbsOrigin(), false)
	local particle_effect_intensity = 275 
	ParticleManager:SetParticleControl(crown_of_death_particle, 2, Vector(particle_effect_intensity))
	
	keys.caster:EmitSound("DOTA_Item.Dagon.Activate")
	keys.target:EmitSound("DOTA_Item.Dagon5.Target")
		
	ApplyDamage({victim = keys.target, attacker = keys.caster, damage = keys.Damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = keys.ability })
end