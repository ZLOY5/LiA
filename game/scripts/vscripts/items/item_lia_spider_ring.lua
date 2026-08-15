---@class item_lia_spider_ring:CDOTA_Ability_Lua
item_lia_spider_ring = class({})

LinkLuaModifier("modifier_item_lia_spider_ring", "items/item_lia_spider_ring", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_spider_ring_debuff", "items/item_lia_spider_ring", LUA_MODIFIER_MOTION_NONE)

function item_lia_spider_ring:GetIntrinsicModifierName()
	return "modifier_item_lia_spider_ring"
end

---@class modifier_item_lia_spider_ring:CDOTA_Modifier_Lua
modifier_item_lia_spider_ring = class({})

function modifier_item_lia_spider_ring:IsHidden() return true end
function modifier_item_lia_spider_ring:IsPurgable() return false end
function modifier_item_lia_spider_ring:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_spider_ring:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	self.duration = self.ability:GetSpecialValueFor("duration")
end

function modifier_item_lia_spider_ring:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_spider_ring:GetOrbProjectileName()
	return "particles/custom/items/spider_ring_projectile.vpcf"
end

function modifier_item_lia_spider_ring:OnOrbImpact(event)
	event.target:AddNewModifier(event.attacker, self.ability, "modifier_item_lia_spider_ring_debuff", {duration = self.duration})
end

---@class modifier_item_lia_spider_ring_debuff:CDOTA_Modifier_Lua
modifier_item_lia_spider_ring_debuff = class({})

function modifier_item_lia_spider_ring_debuff:IsHidden()    return false end
function modifier_item_lia_spider_ring_debuff:IsDebuff()    return true  end
function modifier_item_lia_spider_ring_debuff:IsPurgable()  return true  end

function modifier_item_lia_spider_ring_debuff:OnCreated(kv)
    self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
end

function modifier_item_lia_spider_ring_debuff:DeclareFunctions()
    return {
        MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
    }
end

function modifier_item_lia_spider_ring_debuff:GetModifierPhysicalArmorBonus()
    return -self.armor_reduction
end

function modifier_item_lia_spider_ring_debuff:GetEffectName()
	return "particles/custom/items/spider_ring_debuff.vpcf"
end

function modifier_item_lia_spider_ring_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end