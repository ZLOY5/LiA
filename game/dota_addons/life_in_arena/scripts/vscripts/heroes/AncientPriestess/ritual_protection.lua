function Adsorb( event )
	local caster = event.caster
	local target = event.unit
	local ability = event.ability
	local damage_abso = ability:GetLevelSpecialValueFor("damage_abso", ability:GetLevel() - 1 )
	local main_damage = event.Damage
	--
	if not target.Adsorb or target.Adsorb == 0 then
		target.Adsorb = damage_abso
	end
	--
	local dmgAds = target.Adsorb - main_damage
	if dmgAds > 0 then
		-- случай когда весь урон поглощается
		target.Adsorb = dmgAds
		target:Heal(main_damage, caster)
	else
		-- случай когда щит заканчивается
		target:Heal(main_damage-target.Adsorb, caster)
		--
		target.Adsorb = 0
		-- необходимо уничтожить модификатор
		local modif = target:FindModifierByName("modifier_ancient_priestess_ritual_protection")
		modif:Destroy()
	end
	--print("		target.Adsorb = ", target.Adsorb)
	--
	--[[ Impact particle based on damage absorbed
	local particleName = "particles/units/heroes/hero_medusa/medusa_mana_shield_impact.vpcf"
	local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
	ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
	ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))
	]]

end
