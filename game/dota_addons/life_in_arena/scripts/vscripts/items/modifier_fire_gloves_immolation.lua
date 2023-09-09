modifier_fire_gloves_immolation = class({})

function modifier_fire_gloves_immolation:IsPurgable()
	return false
end

function modifier_fire_gloves_immolation:IsHidden()
	return true 
end

function modifier_fire_gloves_immolation:GetEffectName()
	return "particles/units/heroes/hero_ember_spirit/ember_spirit_flameguard.vpcf"
end

function modifier_fire_gloves_immolation:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

if IsServer() then

	function modifier_fire_gloves_immolation:OnCreated(kv)
		self.tick = 0.25
		self.manaCost = self:GetAbility():GetSpecialValueFor("mana_cost_per_second")*self.tick
		self.damage = self:GetAbility():GetSpecialValueFor("damage_per_second")*self.tick
		self.radius = self:GetAbility():GetSpecialValueFor("radius")

		self:StartIntervalThink(self.tick)
	end

	function modifier_fire_gloves_immolation:OnIntervalThink()
		local ability = self:GetAbility()
		local caster = self:GetCaster()
		
		if not ability or not caster:HasItemInInventory(ability:GetName()) then 
			self:Destroy()
			return
		end

		if caster:GetMana() >= self.manaCost then
			caster:SpendMana( self.manaCost, ability)

			local targets =  FindUnitsInRadius(caster:GetTeamNumber(),
					caster:GetAbsOrigin(),
					nil,
					self.radius,
					DOTA_UNIT_TARGET_TEAM_ENEMY,
					DOTA_UNIT_TARGET_HERO+DOTA_UNIT_TARGET_BASIC,
					DOTA_UNIT_TARGET_FLAG_NONE,
					FIND_ANY_ORDER,
					false)
			
			local damageTable = {attacker = caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability }
			-- Deal damage to all targets passed
			for _,unit in pairs(targets) do
				damageTable.victim = unit
				ApplyDamage(damageTable)
			end
		else
			ability:ToggleAbility()
		end
	end

end