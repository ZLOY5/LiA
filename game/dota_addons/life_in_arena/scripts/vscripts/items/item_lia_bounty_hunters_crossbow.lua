item_lia_bounty_hunters_crossbow = class({})
LinkLuaModifier("modifier_bounty_hunters_crossbow","items/item_lia_bounty_hunters_crossbow.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bounty_hunters_crossbow_true_strike","items/item_lia_bounty_hunters_crossbow.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_bounty_hunters_crossbow_true_strike_active","items/item_lia_bounty_hunters_crossbow.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_bounty_hunters_crossbow:GetIntrinsicModifierName()
	return "modifier_bounty_hunters_crossbow"
end

function item_lia_bounty_hunters_crossbow:OnSpellStart() 
	if IsServer() then
		self.active_duration = self:GetSpecialValueFor("active_duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_bounty_hunters_crossbow_true_strike_active", {duration = self.active_duration})
		self:GetCaster():EmitSound("Hero_Spirit_Breaker.EmpoweringHaste.Cast")
	end
end
-------------------------------------------------------------------------------

modifier_bounty_hunters_crossbow = class({})

function modifier_bounty_hunters_crossbow:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_bounty_hunters_crossbow:IsHidden()
	return true 
end

function modifier_bounty_hunters_crossbow:IsPurgable()
	return false 
end

function modifier_bounty_hunters_crossbow:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
 
	return funcs
end

function modifier_bounty_hunters_crossbow:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_bounty_hunters_crossbow:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_bounty_hunters_crossbow:OnCreated(kv)
	self.pierce_chance = self:GetAbility():GetSpecialValueFor("pierce_chance")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	self.bonus_agility = self:GetAbility():GetSpecialValueFor("bonus_agility")
	if IsServer() then
		self.pseudo = PseudoRandom:New(self.pierce_chance*0.01)
	end
end

function modifier_bounty_hunters_crossbow:OnAttackStart( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if self.pseudo:Trigger() and not self:GetParent():HasModifier("modifier_bounty_hunters_crossbow_true_strike_active") then
				params.attacker:AddNewModifier(params.attacker,self:GetAbility(),"modifier_bounty_hunters_crossbow_true_strike", nil)
				print(self:GetName())
			end
		end
	end
end

-------------------------------------------------------------------------------

modifier_bounty_hunters_crossbow_true_strike = class({})

function modifier_bounty_hunters_crossbow_true_strike:IsHidden()
	return true 
end

function modifier_bounty_hunters_crossbow_true_strike:IsPurgable()
	return false 
end

function modifier_bounty_hunters_crossbow_true_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_bounty_hunters_crossbow_true_strike:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
 
	return state
end

function modifier_bounty_hunters_crossbow_true_strike:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			self:GetParent():RemoveModifierByName("modifier_bounty_hunters_crossbow_true_strike")
		end
	end
end

-------------------------------------------------------------------------------

modifier_bounty_hunters_crossbow_true_strike_active = class({})

function modifier_bounty_hunters_crossbow_true_strike_active:IsHidden()
	return false 
end

function modifier_bounty_hunters_crossbow_true_strike_active:IsPurgable()
	return true 
end

function modifier_bounty_hunters_crossbow_true_strike_active:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_ATTACK_START,
	}

	return funcs
end

function modifier_bounty_hunters_crossbow_true_strike_active:OnTooltip( params )
	return self.active_pierce_chance
end

function modifier_bounty_hunters_crossbow_true_strike_active:GetEffectName()
	return "particles/custom/items/item_lia_bounty_hunters_crossbow.vpcf"
end

function modifier_bounty_hunters_crossbow_true_strike_active:GetEffectAttachType()
	return ATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_bounty_hunters_crossbow_true_strike_active:OnCreated(kv)
	self.active_pierce_chance = self:GetAbility():GetSpecialValueFor("active_pierce_chance")
	if IsServer() then
		self.pseudo_active = PseudoRandom:New(self.active_pierce_chance*0.01)
	end
end

function modifier_bounty_hunters_crossbow_true_strike_active:OnAttackStart( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if self.pseudo_active:Trigger() then
				params.attacker:AddNewModifier(params.attacker,self:GetAbility(),"modifier_bounty_hunters_crossbow_true_strike", nil)
				print(self:GetName())
			end
		end
	end
end