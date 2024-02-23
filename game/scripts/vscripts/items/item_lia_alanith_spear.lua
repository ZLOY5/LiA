---@class item_lia_alanith_spear:CDOTA_Item_Lua
item_lia_alanith_spear = class({})

LinkLuaModifier("modifier_item_lia_alanith_spear", "items/item_lia_alanith_spear", LUA_MODIFIER_MOTION_NONE)

function item_lia_alanith_spear:GetIntrinsicModifierName()
	return "modifier_item_lia_alanith_spear"
end


---@class modifier_item_lia_alanith_spear:CDOTA_Modifier_Lua
modifier_item_lia_alanith_spear = class({})

function modifier_item_lia_alanith_spear:IsHidden() return true end
function modifier_item_lia_alanith_spear:IsPurgable() return false end
function modifier_item_lia_alanith_spear:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_alanith_spear:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_lia_alanith_spear:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self:OnRefresh()
end

function modifier_item_lia_alanith_spear:OnRefresh()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.lifesteal = self.ability:GetSpecialValueFor("lifesteal_percent") * 0.01
end

function modifier_item_lia_alanith_spear:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_alanith_spear:OnOrbImpact(event)
	if event.target:GetTeamNumber() ~= event.attacker:GetTeamNumber() and not event.attacker:HasAbility("vampire_lifesteal") then
		self.frame = GetFrameCount()
	end
end

function modifier_item_lia_alanith_spear:OnTakeDamage(event)
	if self.parent ~= event.attacker or self.frame ~= GetFrameCount() or event.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end
	if event.damage == 0 or event.damage ~= event.damage then return end

	local lifesteal = event.damage * self.lifesteal
	self.parent:HealWithParams(lifesteal, self.ability, true, false, self.parent, false)

	local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
end
