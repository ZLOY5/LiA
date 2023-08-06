item_lia_battle_javelin = class({})
LinkLuaModifier("modifier_battle_javelin","items/item_lia_battle_javelin.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_battle_javelin_true_strike","items/item_lia_battle_javelin.lua",LUA_MODIFIER_MOTION_NONE)

function item_lia_battle_javelin:GetIntrinsicModifierName()
	return "modifier_battle_javelin"
end

-------------------------------------------------------------------------------

modifier_battle_javelin = class({})

function modifier_battle_javelin:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_battle_javelin:IsHidden()
	return true 
end

function modifier_battle_javelin:IsPurgable()
	return false 
end

function modifier_battle_javelin:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_ATTACK_START,
	}
 
	return funcs
end

function modifier_battle_javelin:GetModifierAttackSpeedBonus_Constant()
	return self.bonus_attack_speed
end

function modifier_battle_javelin:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_battle_javelin:OnCreated(kv)
	self.pierce_chance = self:GetAbility():GetSpecialValueFor("pierce_chance")
	self.bonus_damage = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.bonus_attack_speed = self:GetAbility():GetSpecialValueFor("bonus_attack_speed")
	if IsServer() then
		self.pseudo = PseudoRandom:New(self.pierce_chance*0.01)
	end
end

function modifier_battle_javelin:OnAttackStart( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if self.pseudo:Trigger() then
				params.attacker:AddNewModifier(params.attacker,self:GetAbility(),"modifier_battle_javelin_true_strike", nil)
			end	
		end
	end
end


-------------------------------------------------------------------------------

modifier_battle_javelin_true_strike = class({})

function modifier_battle_javelin_true_strike:IsHidden()
	return true 
end

function modifier_battle_javelin_true_strike:IsPurgable()
	return false 
end

function modifier_battle_javelin_true_strike:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_battle_javelin_true_strike:CheckState()
	local state = {
		[MODIFIER_STATE_CANNOT_MISS] = true,
	}
 
	return state
end

function modifier_battle_javelin_true_strike:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			self:GetParent():RemoveModifierByName("modifier_battle_javelin_true_strike")
		end
	end
end