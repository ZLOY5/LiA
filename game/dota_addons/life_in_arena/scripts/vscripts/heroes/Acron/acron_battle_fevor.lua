acron_battle_fevor = class({})
LinkLuaModifier("modifier_acron_battle_fevor","heroes/Acron/acron_battle_fevor.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_acron_battle_fevor_buff","heroes/Acron/acron_battle_fevor.lua",LUA_MODIFIER_MOTION_NONE)

function acron_battle_fevor:GetIntrinsicModifierName()
	return "modifier_acron_battle_fevor"
end

function acron_battle_fevor:OnExplosion()
	if self:GetCaster():PassivesDisabled() then
		return 0
	end

	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")

	local target_teams = self:GetAbilityTargetTeam()
	local target_types = self:GetAbilityTargetType() 
	local target_flags = self:GetAbilityTargetFlags()

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),caster:GetAbsOrigin(),nil,radius,target_teams,target_types,target_flags,FIND_ANY_ORDER,false)
	for _,unit in pairs(targets) do
		unit:AddNewModifier(caster,self,"modifier_acron_battle_fevor_buff",nil)
	end
end

--------------------------------------------------------------------------------------

modifier_acron_battle_fevor = class({})

function modifier_acron_battle_fevor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MAGICAL_RESISTANCE_BONUS,
	}
 
	return funcs
end

function modifier_acron_battle_fevor:IsHidden()
	return true
end

function modifier_acron_battle_fevor:IsPurgable()
	return false
end

function modifier_acron_battle_fevor:GetAttributes()
	return MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE + MODIFIER_ATTRIBUTE_PERMANENT
end

function modifier_acron_battle_fevor:GetModifierMagicalResistanceBonus(params)
	return self.magicalResistance
end


function modifier_acron_battle_fevor:OnCreated(kv)
	self.magicalResistance = self:GetAbility():GetSpecialValueFor("magical_resistance_passive")
end

function modifier_acron_battle_fevor:OnRefresh(kv)
	self.magicalResistance = self:GetAbility():GetSpecialValueFor("magical_resistance_passive")
end

--------------------------------------------------------------------------------------

modifier_acron_battle_fevor_buff = class({})

function modifier_acron_battle_fevor_buff:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_acron_battle_fevor_buff:IsBuff()
	return true
end

function modifier_acron_battle_fevor_buff:GetModifierConstantHealthRegen(params)
	return self.stackHealthRegen * self:GetStackCount()
end

function modifier_acron_battle_fevor_buff:GetModifierPhysicalArmorBonus(params)
	return self.stackArmor * self:GetStackCount()
end

function modifier_acron_battle_fevor_buff:OnCreated(kv)
	self.stackArmor = self:GetAbility():GetSpecialValueFor("stack_armor")
	self.stackHealthRegen = self:GetAbility():GetSpecialValueFor("stack_health_regen")
	self.stackDuration = self:GetAbility():GetSpecialValueFor("stack_duration")

	if IsServer() then
		self:SetStackCount(1)
	
		Timers:CreateTimer(self.stackDuration, 
			function()
				if not self:IsNull() then 
					self:SetStackCount(self:GetStackCount()-1)
					if self:GetStackCount() == 0 then
						self:Destroy()
					end
				end
			end
		)
	end
end

function modifier_acron_battle_fevor_buff:OnRefresh(kv)
	self.stackArmor = self:GetAbility():GetSpecialValueFor("stack_armor")
	self.stackHealthRegen = self:GetAbility():GetSpecialValueFor("stack_health_regen")
	self.stackDuration = self:GetAbility():GetSpecialValueFor("stack_duration")
	
	if IsServer() then
		self:SetStackCount(self:GetStackCount()+1)

		Timers:CreateTimer(self.stackDuration, 
			function()	
				if not self:IsNull() then 
					self:SetStackCount(self:GetStackCount()-1)
					if self:GetStackCount() == 0 then
						self:Destroy()
					end
				end
			end
		)
	end
end




