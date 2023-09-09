modifier_spellbreaker = class({})

function modifier_spellbreaker:GetAttributes() 
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_spellbreaker:IsHidden()
	return true 
end

function modifier_spellbreaker:IsPurgable()
	return false
end

function modifier_spellbreaker:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
		MODIFIER_PROPERTY_PHYSICAL_CONSTANT_BLOCK,
		MODIFIER_PROPERTY_MANA_REGEN_CONSTANT,
	}
 
	return funcs
end

function modifier_spellbreaker:OnCreated(kv)
	local ability = self:GetAbility()

	self.healthBonus = ability:GetSpecialValueFor("bonus_health")
	self.armorBonus = ability:GetSpecialValueFor("bonus_armor")
	self.blockDamage = ability:GetSpecialValueFor("damage_block")
	self.bonusManaRegen = ability:GetSpecialValueFor("bonus_mana_regen")

	if IsServer() then
		self.pseudo = PseudoRandom:New(ability:GetSpecialValueFor("block_chance")*0.01)
		
		if self:GetAbility():IsCooldownReady() then
			local caster = self:GetCaster()
			caster:RemoveModifierByName("modifier_item_sphere_target") --Remove any potentially temporary version of the modifier and replace it with an indefinite one.
			caster:AddNewModifier(caster, ability, "modifier_item_sphere_target", {duration = -1})
			caster.current_spellblock_is_passive = true
		end

		self:StartIntervalThink(0.03)
	end
end

function modifier_spellbreaker:OnIntervalThink()
	local caster = self:GetCaster()
	local ability = self:GetAbility()
	if not caster:HasModifier("modifier_item_sphere_target") then
		if caster.current_spellblock_is_passive then
			
			for i=0, 5 do 
				local current_item = caster:GetItemInSlot(i)
				if current_item ~= nil then
					if current_item:GetName() == "item_lia_spellbreaker" or current_item:GetName() == "item_lia_staff_of_power" or current_item:GetName() == "item_lia_amulet_of_spell_shield" then
						current_item:StartCooldown(current_item:GetCooldown(current_item:GetLevel()))
					end
				end
			end
			
			caster.current_spellblock_is_passive = nil
		elseif ability:IsCooldownReady() then
			caster:AddNewModifier(caster,ability,"modifier_item_sphere_target",{duration = -1})
			caster.current_spellblock_is_passive = true
		end
	end

	return 0.03
end

if IsServer() then
	function modifier_spellbreaker:OnDestroy()
		local caster = self:GetCaster()
		local ability = self:GetAbility()

		local sphereModifier = caster:FindModifierByName("modifier_item_sphere_target")
		if sphereModifier and sphereModifier:GetAbility() == ability then
			sphereModifier:Destroy()

			for i=0, 5, 1 do 
			local current_item = caster:GetItemInSlot(i)
				if current_item and current_item ~= ability then
					if (current_item:GetName() == "item_lia_spellbreaker" 
					or current_item:GetName() == "item_lia_staff_of_power" 
					or current_item:GetName() == "item_lia_amulet_of_spell_shield") 
					and current_item:IsCooldownReady() then
						keys.caster:AddNewModifier(caster, current_item, "modifier_item_sphere_target", {duration = -1})
					    return
					end
				end
			end
		end
	end
end



function modifier_spellbreaker:GetModifierHealthBonus(params)
	return self.healthBonus
end

function modifier_spellbreaker:GetModifierPhysicalArmorBonus(params)
	return self.armorBonus
end

function modifier_spellbreaker:GetModifierPhysical_ConstantBlock(params)
	--print(params.record,params.damage)
	if not params.inflictor and params.record ~= 11200 and self.pseudo:Trigger() then 
		return self.blockDamage 
	end
end

function modifier_spellbreaker:GetModifierConstantManaRegen()
	return self.bonusManaRegen
end