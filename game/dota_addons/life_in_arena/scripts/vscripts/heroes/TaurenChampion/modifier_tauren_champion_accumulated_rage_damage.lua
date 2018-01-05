
modifier_tauren_champion_accumulated_rage_damage = class({})

function modifier_tauren_champion_accumulated_rage_damage:IsHidden()
	return false
end

function modifier_tauren_champion_accumulated_rage_damage:IsPurgable()
	return false
end

function modifier_tauren_champion_accumulated_rage_damage:OnCreated(kv)
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	self.health_lost_threshold_percent = self:GetAbility():GetSpecialValueFor("health_lost_threshold_percent")
	if IsServer() then
		self:SetStackCount(0)
--		CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { accumulated_rage_damage = 0 } )
	end
end

function modifier_tauren_champion_accumulated_rage_damage:OnRefresh(kv)
	self.damage_per_stack = self:GetAbility():GetSpecialValueFor("damage_per_stack")
	self.health_lost_threshold_percent = self:GetAbility():GetSpecialValueFor("health_lost_threshold_percent")
end

function modifier_tauren_champion_accumulated_rage_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
 
	return funcs
end


function modifier_tauren_champion_accumulated_rage_damage:GetModifierPreAttack_BonusDamage()
	if IsServer() then
		if self:GetParent():PassivesDisabled() then
			return 0
		end

		local bonusDamage = math.floor((100 - self:GetParent():GetHealthPercent()) / self.health_lost_threshold_percent) * self.damage_per_stack
		self:SetStackCount(bonusDamage)
--[[		CustomNetTables:SetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ), { accumulated_rage_damage = bonusDamage } )
		local netTable = CustomNetTables:GetTableValue( "custom_modifier_state", string.format( "%d", self:GetParent():GetEntityIndex() ) )
		print(netTable.accumulated_rage_damage)]]
		return bonusDamage
	end
end

function modifier_tauren_champion_accumulated_rage_damage:OnDestroy()
	if IsServer() then
	--	ParticleManager:DestroyParticle(self.accumulatedRageArmor, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tauren_champion_accumulated_rage_block", nil)
	end
end


