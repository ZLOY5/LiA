tauren_champion_accumulated_rage = class({})
LinkLuaModifier("modifier_tauren_champion_accumulated_rage","heroes/TaurenChampion/tauren_champion_accumulated_rage.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_accumulated_rage_block","heroes/TaurenChampion/tauren_champion_accumulated_rage.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_tauren_champion_accumulated_rage_damage","heroes/TaurenChampion/tauren_champion_accumulated_rage.lua",LUA_MODIFIER_MOTION_NONE)

function tauren_champion_accumulated_rage:GetIntrinsicModifierName()
	return "modifier_tauren_champion_accumulated_rage"
end

-------------------------------------------------------------------------------

modifier_tauren_champion_accumulated_rage = class({})

function modifier_tauren_champion_accumulated_rage:IsHidden()
	return true
end

function modifier_tauren_champion_accumulated_rage:IsPurgable()
	return false
end

function modifier_tauren_champion_accumulated_rage:OnCreated(kv)

	if IsServer() then
		self:SetStackCount(self.attacks_count)
	end
end

-------------------------------------------------------------------------------

modifier_tauren_champion_accumulated_rage_block = class({})

function modifier_tauren_champion_accumulated_rage_block:IsHidden()
	return false
end

function modifier_tauren_champion_accumulated_rage_block:IsPurgable()
	return false
end

function modifier_tauren_champion_accumulated_rage_block:OnCreated(kv)
	self.max_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("max_damage_blocked_percent")*0.01
	self.min_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("min_damage_blocked_percent")*0.01
	self.absorption_count = self:GetAbility():GetSpecialValueFor("absorption_count")
	self.shield_cooldown = self:GetAbility():GetSpecialValueFor("shield_cooldown")
	if IsServer() then
		self:SetStackCount(self.absorption_count)
	end
end

function modifier_tauren_champion_accumulated_rage_block:OnRefresh(kv)
	self.max_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("max_damage_blocked_percent")*0.01
	self.min_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("min_damage_blocked_percent")*0.01
	self.absorption_count = self:GetAbility():GetSpecialValueFor("absorption_count")
	self.shield_cooldown = self:GetAbility():GetSpecialValueFor("shield_cooldown")
end

function modifier_tauren_champion_accumulated_rage_block:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
	}
 
	return funcs
end


function modifier_tauren_champion_accumulated_rage_block:OnTakeDamage()
	if IsServer() then
		local damage = params.original_damage
		local caster = self:GetParent
		if damage >= caster:GetMaxHealth() * self.min_damage_blocked_percent then
			self:DecrementStackCount()
		end
	end
end

function modifier_tauren_champion_accumulated_rage_block:GetModifierTotal_ConstantBlock()
	if IsServer() then
		local damage = params.original_damage
		local caster = self:GetParent
		if damage >= caster:GetMaxHealth() * self.min_damage_blocked_percent then
			if damage > self.max_damage_blocked_percent then
				return self.max_damage_blocked_percent
			else
				return damage
			end
		end
	end
end






