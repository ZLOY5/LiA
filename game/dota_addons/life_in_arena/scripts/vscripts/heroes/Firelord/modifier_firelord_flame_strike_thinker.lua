modifier_firelord_flame_strike_thinker = class({})

if IsServer() then

	function modifier_firelord_flame_strike_thinker:OnCreated(kv)
		local parent = self:GetParent()

		self:StartIntervalThink(1)
		self:OnIntervalThink()

		EmitSoundOn("Ability.LightStrikeArray", self:GetParent())

		local radius = self:GetAbility():GetSpecialValueFor("radius")

		local pFX = ParticleManager:CreateParticle("particles/units/heroes/hero_lina/lina_spell_light_strike_array.vpcf", PATTACH_ABSORIGIN_FOLLOW, parent)
		ParticleManager:SetParticleControl(pFX, 1, Vector(radius,0,0))
		ParticleManager:ReleaseParticleIndex(pFX)

	end

	function modifier_firelord_flame_strike_thinker:OnIntervalThink()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local damage = ability:GetSpecialValueFor(caster:HasScepter() and "first_strike_dps_scepter" or "first_strike_dps")
		local burning_duration = ability:GetSpecialValueFor("burn_duration")
		local firstStrikeDuration = ability:GetSpecialValueFor("first_strike_duration")
		local radius = ability:GetSpecialValueFor("radius")
		
		local targets = FindUnitsInRadius(caster:GetTeam(),
			self:GetParent():GetAbsOrigin(),
			nil,
			radius,
			DOTA_UNIT_TARGET_TEAM_ENEMY,
			DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
			DOTA_DAMAGE_FLAG_NONE,
			FIND_ANY_ORDER,
			false)

		local damageTable = {attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability}

		for _, unit in pairs(targets) do
			if self:GetElapsedTime() <= firstStrikeDuration then
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end

			unit:AddNewModifier(caster, ability, "modifier_firelord_flame_strike_burn", {duration = burning_duration})
		end

		local pFX = ParticleManager:CreateParticle("particles/units/heroes/hero_phoenix/phoenix_fire_spirit_ground.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControl(pFX, 1, Vector(radius,0,0))
		ParticleManager:ReleaseParticleIndex(pFX)

	end

end