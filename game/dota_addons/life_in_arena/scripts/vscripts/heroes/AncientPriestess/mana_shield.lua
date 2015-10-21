--[[
	Author: Noya
	Date: 24.01.2015.
	After taking damage, checks the mana of the caster and prevents as many damage as possible.
	Note: This is post-reduction, because there's currently no easy way to get pre-mitigation damage.
	
	
	This modification: CeZaRRR
	Date: 15.10.2015.
]]
function ManaShield( event )
	local caster = event.caster
	local ability = event.ability
	local damage_per_mana = ability:GetLevelSpecialValueFor("damage_per_mana", ability:GetLevel() - 1 )
	local absorption_percent = ability:GetLevelSpecialValueFor("absorption_percent", ability:GetLevel() - 1 ) * 0.01
	local main_damage = event.Damage
	local damage_abs = main_damage * absorption_percent

	local caster_mana = caster:GetMana()
	local mana_needed = damage_abs / damage_per_mana

	local oldHealth = caster.OldHealth

	--print("main_damage="..main_damage.." | damage_abs="..damage_abs.." | Mana needed: "..mana_needed.." | Current Mana: "..caster_mana)

	-- если есть защита от ульты, то не поглощать урон магическим щитом
	if not caster.Adsorb or caster.Adsorb == 0 then
		if mana_needed <= caster_mana then
			caster:SpendMana(mana_needed, ability)
			caster:SetHealth(oldHealth-(main_damage-damage_abs))
			
			-- Impact particle based on damage absorbed
			local particleName = "particles/medusa_mana_shield_impact.vpcf"
			local particle = ParticleManager:CreateParticle(particleName, PATTACH_ABSORIGIN_FOLLOW, caster)
			ParticleManager:SetParticleControl(particle, 0, caster:GetAbsOrigin())
			ParticleManager:SetParticleControl(particle, 1, Vector(mana_needed,0,0))
		--[[else
			local newHealth = oldHealth - damage_abs
			mana_needed =
			caster:SpendMana(mana_needed, ability)
			caster:SetHealth(newHealth)
			--]]
		end
	end
	
end

-- Keeps track of the targets health
function ManaShieldHealth( event )
	local caster = event.caster

	caster.OldHealth = caster:GetHealth()
end