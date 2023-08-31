modifier_highlander_improved_armor = class({})

function modifier_highlander_improved_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_highlander_improved_armor:IsHidden()
	--print(self:GetStackCount())
	if self:GetStackCount() == 0 then
		return true
	end
	return false
end

function modifier_highlander_improved_armor:IsPurgable()
	return false
end

function modifier_highlander_improved_armor:GetModifierPhysicalArmorBonus( params )
	return self:GetStackCount() + self.bonus_armor
end

function modifier_highlander_improved_armor:OnCreated( params )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.armor_per_attack = self:GetAbility():GetSpecialValueFor("armor_per_attack")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
	self.max_armor = self:GetAbility():GetSpecialValueFor("max_armor")

	self.armorStack = 0
end

function modifier_highlander_improved_armor:OnRefresh( params )
	self.bonus_armor = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.duration = self:GetAbility():GetSpecialValueFor("duration")
end

function modifier_highlander_improved_armor:OnAttackLanded( params )
	if IsServer() then
		if params.target == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			if self:GetParent():PassivesDisabled() then
				return 0
			end
 			
			local armor_per_attack = self.armor_per_attack
				
			self.armorStack = self.armorStack + armor_per_attack
			
			if self.armorStack < self.max_armor then --для того чтобы удары, которые герой получил после превышения лимита учитывались, но лимит не превышался
				self:SetStackCount(self.armorStack)
			else 
				self:SetStackCount(self.max_armor)
			end
				
			Timers:CreateTimer(self.duration,
				function()
					self.armorStack = self.armorStack - armor_per_attack
					
					if self.armorStack < self.max_armor then
						self:SetStackCount(self.armorStack)
					else 
						self:SetStackCount(self.max_armor)
					end
				end
			)
		end
	end
 
	return 0
end