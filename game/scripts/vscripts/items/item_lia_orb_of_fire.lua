item_lia_orb_of_fire = class({})

LinkLuaModifier("modifier_item_lia_orb_of_fire", "items/item_lia_orb_of_fire", LUA_MODIFIER_MOTION_NONE)

function item_lia_orb_of_fire:GetIntrinsicModifierName()
	return "modifier_item_lia_orb_of_fire"
end

---@class modifier_item_lia_orb_of_fire:CDOTA_Modifier_Lua
modifier_item_lia_orb_of_fire = class({})

function modifier_item_lia_orb_of_fire:IsHidden() return true end
function modifier_item_lia_orb_of_fire:IsPurgable() return false end
function modifier_item_lia_orb_of_fire:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_orb_of_fire:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
end

function modifier_item_lia_orb_of_fire:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:OnRefresh()
end

function modifier_item_lia_orb_of_fire:OnRefresh()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.radius = self.ability:GetSpecialValueFor("radius")

	self.damage_table = {
		attacker = self.parent,
		damage = self.bonus_damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self.ability
	}
end

function modifier_item_lia_orb_of_fire:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_orb_of_fire:GetOrbProjectileName()
	return "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf"
end

function modifier_item_lia_orb_of_fire:OnOrbFire()
	self.parent:EmitSound("Hero_Jakiro.Attack")
end

function modifier_item_lia_orb_of_fire:OnOrbImpact(event)
	local targets = FindUnitsInRadius(
		self.parent:GetTeam(),
		event.target:GetAbsOrigin(),
		nil,
		self.radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false
	)

	for _, target in pairs(targets) do
		self.damage_table.victim = target
		ApplyDamage(self.damage_table)
	end
end
