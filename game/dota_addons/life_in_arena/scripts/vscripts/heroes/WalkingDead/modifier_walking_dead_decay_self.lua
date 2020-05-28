modifier_walking_dead_decay_self = class ({})

function modifier_walking_dead_decay_self:IsHidden()
	return false
end

function modifier_walking_dead_decay_self:IsPurgable()
	return false
end

function modifier_walking_dead_decay_self:OnCreated(kv)
	self.caster = self:GetCaster()	
	self.health_regeneration = self:GetAbility():GetSpecialValueFor("health_regeneration")
	self.tick = 1
	if IsServer() then
		self:StartIntervalThink(self.tick)
	end
end

function modifier_walking_dead_decay_self:OnRefresh(kv)	
	self.health_regeneration = self:GetAbility():GetSpecialValueFor("health_regeneration")
end
 
function modifier_walking_dead_decay_self:GetEffectName()
	return "particles/custom/treant/treant_take_root_self.vpcf"	
end

function modifier_walking_dead_decay_self:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_walking_dead_decay_self:OnIntervalThink()
	if IsServer() then
		if self.caster:GetMana() >= self.manaCost then
			self.caster:SpendMana( self.manaCost, self:GetAbility())
		else
			self:GetAbility():ToggleAbility()
		end	
	end
end

function modifier_walking_dead_decay_self:CheckState()
	local state = {
		[MODIFIER_STATE_ROOTED] = true,
	}

	return state
end

function modifier_walking_dead_decay_self:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs

end

function modifier_walking_dead_decay_self:GetModifierConstantHealthRegen()
	return self.health_regeneration
end