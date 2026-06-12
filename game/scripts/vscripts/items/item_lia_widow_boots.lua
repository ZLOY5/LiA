---@class item_lia_widow_boots:CDOTA_Item_Lua
item_lia_widow_boots = class({})

LinkLuaModifier("modifier_item_lia_widow_boots",           "items/item_lia_widow_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_widow_boots_debuff",    "items/item_lia_widow_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_widow_boots_active",    "items/item_lia_widow_boots", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_widow_boots_pass_mark", "items/item_lia_widow_boots", LUA_MODIFIER_MOTION_NONE)

function item_lia_widow_boots:GetIntrinsicModifierName()
	return "modifier_item_lia_widow_boots"
end

function item_lia_widow_boots:OnSpellStart()
	local caster = self:GetCaster()
	caster:AddNewModifier(caster, self, "modifier_item_lia_widow_boots_active", {
		duration = self:GetSpecialValueFor("invis_duration")
	})
	local cd = self:GetCooldown(self:GetLevel())
	for slot = 0, 5 do
		local item = caster:GetItemInSlot(slot)
		if item and item:GetName() == "item_lia_boots_of_invisibility" then
			item:StartCooldown(cd)
			break
		end
	end
end

-- ─────────────────────────────────────────────────────────────────────────────
-- PASSIVE — stats + orb (Запутывание)
-- ─────────────────────────────────────────────────────────────────────────────
---@class modifier_item_lia_widow_boots:CDOTA_Modifier_Lua
modifier_item_lia_widow_boots = class({})

function modifier_item_lia_widow_boots:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_item_lia_widow_boots:IsHidden()      return true  end
function modifier_item_lia_widow_boots:IsPurgable()    return false end
function modifier_item_lia_widow_boots:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_widow_boots:OnCreated()
	if IsServer() then
		RegisterOrbEffectModifier(self)
	end
	self.ability  = self:GetAbility()
	self.duration = self.ability:GetSpecialValueFor("debuff_duration")
end

function modifier_item_lia_widow_boots:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MOVESPEED_BONUS_UNIQUE,
	}
end

function modifier_item_lia_widow_boots:GetModifierPreAttack_BonusDamage()
	return self:GetAbility():GetSpecialValueFor("bonus_attack_damage")
end

function modifier_item_lia_widow_boots:GetModifierMoveSpeedBonus_Special_Boots()
	return self:GetAbility():GetSpecialValueFor("bonus_movement_speed")
end

function modifier_item_lia_widow_boots:GetOrbProjectileName()
	return "particles/custom/items/spider_ring_projectile.vpcf"
end

function modifier_item_lia_widow_boots:OnOrbImpact(event)
	event.target:AddNewModifier(event.attacker, self.ability, "modifier_item_lia_widow_boots_debuff", {
		duration = self.duration
	})
end

-- ─────────────────────────────────────────────────────────────────────────────
-- DEBUFF — stacking armor reduction (max 5 stacks)
-- ─────────────────────────────────────────────────────────────────────────────
---@class modifier_item_lia_widow_boots_debuff:CDOTA_Modifier_Lua
modifier_item_lia_widow_boots_debuff = class({})

function modifier_item_lia_widow_boots_debuff:IsHidden()   return false end
function modifier_item_lia_widow_boots_debuff:IsDebuff()   return true  end
function modifier_item_lia_widow_boots_debuff:IsPurgable() return true  end
function modifier_item_lia_widow_boots_debuff:GetTexture()  return "custom/lia_widow_boots" end

function modifier_item_lia_widow_boots_debuff:OnCreated()
	self.armor_reduction = self:GetAbility():GetSpecialValueFor("armor_reduction")
	if IsServer() then
		self:SetStackCount(1)
	end
end

function modifier_item_lia_widow_boots_debuff:OnRefresh()
	local max = self:GetAbility():GetSpecialValueFor("max_stacks")
	if IsServer() then
		self:SetStackCount(math.min(self:GetStackCount() + 1, max))
	end
end

function modifier_item_lia_widow_boots_debuff:DeclareFunctions()
	return {MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS}
end

function modifier_item_lia_widow_boots_debuff:GetModifierPhysicalArmorBonus()
	return -(self.armor_reduction * self:GetStackCount())
end

function modifier_item_lia_widow_boots_debuff:GetEffectName()
	return "particles/custom/items/spider_ring_debuff.vpcf"
end

function modifier_item_lia_widow_boots_debuff:GetEffectAttachType()
	return PATTACH_OVERHEAD_FOLLOW
end

-- ─────────────────────────────────────────────────────────────────────────────
-- PASS MARK — invisible marker placed on enemies passed through during invis.
-- Duration = remaining invis time, so it naturally expires with the active.
-- While it exists, the think won't apply another pass-through stack.
-- ─────────────────────────────────────────────────────────────────────────────
---@class modifier_item_lia_widow_boots_pass_mark:CDOTA_Modifier_Lua
modifier_item_lia_widow_boots_pass_mark = class({})

function modifier_item_lia_widow_boots_pass_mark:IsHidden()   return true  end
function modifier_item_lia_widow_boots_pass_mark:IsDebuff()   return false end
function modifier_item_lia_widow_boots_pass_mark:IsPurgable() return false end

-- ─────────────────────────────────────────────────────────────────────────────
-- ACTIVE — invisibility + pass-through snare (Невидимость)
-- ─────────────────────────────────────────────────────────────────────────────
---@class modifier_item_lia_widow_boots_active:CDOTA_Modifier_Lua
modifier_item_lia_widow_boots_active = class({})

function modifier_item_lia_widow_boots_active:IsHidden()   return false end
function modifier_item_lia_widow_boots_active:IsPurgable() return true  end
function modifier_item_lia_widow_boots_active:GetTexture()  return "custom/lia_widow_boots" end

function modifier_item_lia_widow_boots_active:GetEffectName()
	return "particles/generic_hero_status/status_invisibility_start.vpcf"
end

function modifier_item_lia_widow_boots_active:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_item_lia_widow_boots_active:OnCreated()
	if IsServer() then
		self:StartIntervalThink(0.1)
	end
end

function modifier_item_lia_widow_boots_active:OnDestroy()
	if IsServer() then
		self:StartIntervalThink(-1)
	end
end

function modifier_item_lia_widow_boots_active:OnIntervalThink()
	local parent  = self:GetParent()
	local ability = self:GetAbility()
	if not parent or not ability then return end

	local units = FindUnitsInRadius(
		parent:GetTeamNumber(), parent:GetOrigin(), nil, 100,
		DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL,
		DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false
	)
	for _, unit in ipairs(units) do
		if not unit:HasModifier("modifier_item_lia_widow_boots_pass_mark") then
			unit:AddNewModifier(parent, ability, "modifier_item_lia_widow_boots_pass_mark", {
				duration = self:GetRemainingTime()
			})
			unit:AddNewModifier(parent, ability, "modifier_item_lia_widow_boots_debuff", {
				duration = ability:GetSpecialValueFor("debuff_duration")
			})
		end
	end
end

function modifier_item_lia_widow_boots_active:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_INVISIBILITY_LEVEL,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
	}
end

function modifier_item_lia_widow_boots_active:GetModifierMoveSpeedBonus_Percentage()
	return self:GetAbility():GetSpecialValueFor("invis_movespeed_percent")
end

function modifier_item_lia_widow_boots_active:GetModifierInvisibilityLevel()
	return 1
end

function modifier_item_lia_widow_boots_active:CheckState()
	return {
		[MODIFIER_STATE_INVISIBLE]         = true,
		[MODIFIER_STATE_NO_UNIT_COLLISION] = true,
	}
end

function modifier_item_lia_widow_boots_active:OnAttackLanded(params)
	if params.attacker ~= self:GetParent() then return end
	if params.target and IsValidEntity(params.target) then
		ApplyDamage({
			victim      = params.target,
			attacker    = params.attacker,
			damage      = self:GetAbility():GetSpecialValueFor("invis_bonus_damage"),
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability     = self:GetAbility(),
		})
	end
	self:Destroy()
end

function modifier_item_lia_widow_boots_active:OnAbilityExecuted(params)
	if params.unit == self:GetParent() and params.ability ~= self:GetAbility() then
		self:Destroy()
	end
end
