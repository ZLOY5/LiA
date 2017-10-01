
wave_9_incorporeity_extreme = class({})
LinkLuaModifier( "modifier_wave_9_incorporeity_extreme", "abilities/wave_9_incorporeity_extreme.lua", LUA_MODIFIER_MOTION_NONE )

--------------------------------------------------------------------------------

function wave_9_incorporeity_extreme:GetIntrinsicModifierName()
	return "modifier_wave_9_incorporeity_extreme"
end

--------------------------------------------------------------------------------


modifier_wave_9_incorporeity_extreme = class({})

--------------------------------------------------------------------------------

function modifier_wave_9_incorporeity_extreme:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_wave_9_incorporeity_extreme:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_wave_9_incorporeity_extreme:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_PHYSICAL_DAMAGE_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

--------------------------------------------------------------------------------

function modifier_wave_9_incorporeity_extreme:OnCreated( kv )
	self.melee_damage_reduction = self:GetAbility():GetSpecialValueFor( "melee_damage_reduction" )
	self.ranged_damage_reduction = self:GetAbility():GetSpecialValueFor( "ranged_damage_reduction" )
end

--------------------------------------------------------------------------------

function modifier_wave_9_incorporeity_extreme:OnAttackLanded(params) 
	if params.target == self:GetParent() and not self:GetParent():IsIllusion() then 
		self.attack_record = params.record 
	end 
end

--------------------------------------------------------------------------------

function modifier_wave_9_incorporeity_extreme:GetModifierIncomingPhysicalDamage_Percentage(params) 
	if IsServer() then
		if not self:GetParent():IsIllusion() and self.attack_record == params.record then 
			if params.attacker:GetAttackCapability() == 1 then
				return self.melee_damage_reduction
			elseif params.attacker:GetAttackCapability() == 2 then
				return self.ranged_damage_reduction
			end
		end 
	end
end

--------------------------------------------------------------------------------
