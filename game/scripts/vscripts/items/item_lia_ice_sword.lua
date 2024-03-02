item_lia_ice_sword = class({})

LinkLuaModifier("modifier_item_lia_ice_sword", "items/item_lia_ice_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_ice_sword_aura_effect", "items/item_lia_ice_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_ice_sword_slow", "items/item_lia_ice_sword", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_item_lia_ice_sword_freeze", "items/item_lia_ice_sword", LUA_MODIFIER_MOTION_NONE)


function item_lia_ice_sword:GetIntrinsicModifierName()
	return "modifier_item_lia_ice_sword"
end

function item_lia_ice_sword:OnSpellStart()
	self.caster = self:GetCaster()
	self.freeze_duration = self:GetSpecialValueFor( "freeze_duration" )
	self.freeze_damage = self:GetSpecialValueFor( "freeze_damage" )
	self.freeze_radius = self:GetSpecialValueFor( "freeze_radius" )

	local targets = FindUnitsInRadius(self.caster:GetTeamNumber(),
										self.caster:GetAbsOrigin(),
										nil,
										self.freeze_radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	for _,v in pairs(targets) do
		ApplyDamage({ victim = v, attacker = self.caster, damage = self.freeze_damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
		v:AddNewModifier(self.caster, self, "modifier_item_lia_ice_sword_freeze", {duration = self.freeze_duration})
	end

	EmitSoundOn( "Hero_Ancient_Apparition.ColdFeetTick", self.caster )
end

---@class modifier_item_lia_ice_sword:CDOTA_Modifier_Lua
modifier_item_lia_ice_sword = class({})

function modifier_item_lia_ice_sword:IsHidden() return true end
function modifier_item_lia_ice_sword:IsPurgable() return false end
function modifier_item_lia_ice_sword:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_ice_sword:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_BONUS
	}
end

function modifier_item_lia_ice_sword:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:OnRefresh()
end

function modifier_item_lia_ice_sword:OnRefresh()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.aura_radius = self.ability:GetSpecialValueFor("aura_radius")
	self.orb_duration = self.ability:GetSpecialValueFor("orb_duration")
end

function modifier_item_lia_ice_sword:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_ice_sword:GetModifierManaBonus()
	return self.bonus_mana
end

function modifier_item_lia_ice_sword:GetOrbProjectileName()
	return "particles/items2_fx/skadi_projectile.vpcf"
end

-- function modifier_item_lia_ice_sword:OnOrbFire()
-- 	self.parent:EmitSound("Hero_Jakiro.Attack")
-- end

function modifier_item_lia_ice_sword:OnOrbImpact(event)
	event.target:AddNewModifier(self.parent, self.ability, "modifier_item_lia_ice_sword_slow", {duration = self.orb_duration})
end

function modifier_item_lia_ice_sword:IsAura()
	return true
end

function modifier_item_lia_ice_sword:GetAuraRadius()
	return self.aura_radius
end

function modifier_item_lia_ice_sword:GetAuraSearchType()
	return DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO
end

function modifier_item_lia_ice_sword:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_FRIENDLY
end

function modifier_item_lia_ice_sword:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_INVULNERABLE
end

function modifier_item_lia_ice_sword:GetAuraDuration()
	return 1
end

function modifier_item_lia_ice_sword:GetModifierAura()
	return "modifier_item_lia_ice_sword_aura_effect"
end

---@class modifier_item_lia_ice_sword_aura_effect:CDOTA_Modifier_Lua
modifier_item_lia_ice_sword_aura_effect = class({})

function modifier_item_lia_ice_sword_aura_effect:IsHidden() return false end
function modifier_item_lia_ice_sword_aura_effect:IsPurgable() return false end

function modifier_item_lia_ice_sword_aura_effect:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_lia_ice_sword_aura_effect:OnCreated()
	self.ability = self:GetAbility()
	self.aura_attack_speed = self.ability:GetSpecialValueFor("aura_attack_speed")
	self.aura_movement_speed = self.ability:GetSpecialValueFor("aura_movement_speed")
end

function modifier_item_lia_ice_sword_aura_effect:GetModifierMoveSpeedBonus_Percentage()
	return self.aura_movement_speed
end

function modifier_item_lia_ice_sword_aura_effect:GetModifierAttackSpeedBonus_Constant()
	return self.aura_attack_speed
end

---@class modifier_item_lia_ice_sword_slow:CDOTA_Modifier_Lua
modifier_item_lia_ice_sword_slow = class({})

function modifier_item_lia_ice_sword_slow:IsHidden() return false end
function modifier_item_lia_ice_sword_slow:IsPurgable() return true end

function modifier_item_lia_ice_sword_slow:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_item_lia_ice_sword_slow:OnCreated()
	self.ability = self:GetAbility()
	self.orb_movespeed_slow = self.ability:GetSpecialValueFor("orb_movespeed_slow")
	self.orb_attack_slow = self.ability:GetSpecialValueFor("orb_attack_slow")
end

function modifier_item_lia_ice_sword_slow:GetModifierMoveSpeedBonus_Percentage()
	return self.orb_movespeed_slow
end

function modifier_item_lia_ice_sword_slow:GetModifierAttackSpeedBonus_Constant()
	return self.orb_attack_slow
end

function modifier_item_lia_ice_sword_slow:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_item_lia_ice_sword_slow:StatusEffectPriority()
	return 10
end

---@class modifier_item_lia_ice_sword_freeze:CDOTA_Modifier_Lua
modifier_item_lia_ice_sword_freeze = class({})

function modifier_item_lia_ice_sword_freeze:IsHidden() return false end
function modifier_item_lia_ice_sword_freeze:IsPurgable() return true end

function modifier_item_lia_ice_sword_freeze:CheckState()
	local state = {
		[MODIFIER_STATE_STUNNED] = true,
		[MODIFIER_STATE_FROZEN] = true,
	}

	return state
end

function modifier_item_lia_ice_sword_freeze:GetEffectName()
	return "particles/units/heroes/hero_crystalmaiden/maiden_frostbite_buff.vpcf"
end

function modifier_item_lia_ice_sword_freeze:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end