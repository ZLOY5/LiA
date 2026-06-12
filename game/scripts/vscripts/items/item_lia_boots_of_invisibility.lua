---@class item_lia_boots_of_invisibility:CDOTA_Item_Lua
item_lia_boots_of_invisibility = class({})

LinkLuaModifier("modifier_item_lia_boots_of_invisibility", "items/item_lia_boots_of_invisibility", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_boots_of_invisibility_active", "items/item_lia_boots_of_invisibility", LUA_MODIFIER_MOTION_NONE)

function item_lia_boots_of_invisibility:GetIntrinsicModifierName()
	return "modifier_item_lia_boots_of_invisibility"
end

function item_lia_boots_of_invisibility:OnSpellStart()
	local caster = self:GetCaster()
	local duration = self:GetSpecialValueFor("duration")
	caster:AddNewModifier(caster, self, "modifier_item_lia_boots_of_invisibility_active", { duration = duration })
	local cd = self:GetCooldown(self:GetLevel())
	for slot = 0, 5 do
		local item = caster:GetItemInSlot(slot)
		if item and item:GetName() == "item_lia_widow_boots" then
			item:StartCooldown(cd)
			break
		end
	end
end

---@class modifier_item_lia_boots_of_invisibility: CDOTA_Modifier_Lua
modifier_item_lia_boots_of_invisibility = class({})

function modifier_item_lia_boots_of_invisibility:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_boots_of_invisibility:IsHidden() return true end
function modifier_item_lia_boots_of_invisibility:IsPurgable() return false  end

function modifier_item_lia_boots_of_invisibility:OnCreated(kv)
	self.bonus_movement_speed = self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_lia_boots_of_invisibility:DeclareFunctions()
    local funcs = {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
	}
 
	return funcs
end

function modifier_item_lia_boots_of_invisibility:GetModifierMoveSpeedBonus_Special_Boots()
    return self.bonus_movement_speed
end

---@class modifier_item_lia_boots_of_invisibility_active: CDOTA_Modifier_Lua
modifier_item_lia_boots_of_invisibility_active = class({})

function modifier_item_lia_boots_of_invisibility_active:IsHidden() return false end
function modifier_item_lia_boots_of_invisibility_active:IsPurgable() return true end
function modifier_item_lia_boots_of_invisibility_active:GetEffectName() return "particles/generic_hero_status/status_invisibility_start.vpcf" end
function modifier_item_lia_boots_of_invisibility_active:GetEffectAttachType() return PATTACH_ABSORIGIN_FOLLOW end

function modifier_item_lia_boots_of_invisibility_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
	}
end

function modifier_item_lia_boots_of_invisibility_active:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("invis_movespeed_percent")
end

function modifier_item_lia_boots_of_invisibility_active:GetModifierInvisibilityLevel()
	return 1
end

function modifier_item_lia_boots_of_invisibility_active:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE] = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

function modifier_item_lia_boots_of_invisibility_active:OnAttackLanded(params)
	if params.attacker == self:GetParent() then
		local bonus_dmg = self:GetAbility():GetSpecialValueFor("invis_damage")
		ApplyDamage({
			victim = params.target,
			attacker = params.attacker,
			damage = bonus_dmg,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self:GetAbility()
		})
		self:Destroy()
	end
end

function modifier_item_lia_boots_of_invisibility_active:OnAbilityExecuted(params)
	if params.unit == self:GetParent() and params.ability ~= self:GetAbility() then
		self:Destroy()
	end
end