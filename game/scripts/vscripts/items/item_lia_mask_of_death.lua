---@class item_lia_mask_of_death:CDOTA_Item_Lua
item_lia_mask_of_death = class({})

LinkLuaModifier("modifier_item_lia_mask_of_death", "items/item_lia_mask_of_death", LUA_MODIFIER_MOTION_NONE)

function item_lia_mask_of_death:GetIntrinsicModifierName()
	return "modifier_item_lia_mask_of_death"
end


---@class modifier_item_lia_mask_of_death:CDOTA_Modifier_Lua
modifier_item_lia_mask_of_death = class({})

function modifier_item_lia_mask_of_death:IsHidden() return true end
function modifier_item_lia_mask_of_death:IsPurgable() return false end
function modifier_item_lia_mask_of_death:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_mask_of_death:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_lia_mask_of_death:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self:OnRefresh()
end

function modifier_item_lia_mask_of_death:OnRefresh()
	self.lifesteal = self.ability:GetSpecialValueFor("lifesteal_percent") * 0.01
end

function modifier_item_lia_mask_of_death:OnOrbImpact(event)
	if event.target:GetTeamNumber() ~= event.attacker:GetTeamNumber() and not event.attacker:HasAbility("vampire_lifesteal") then
		self.frame = GetFrameCount()
	end
end

function modifier_item_lia_mask_of_death:OnTakeDamage(event)
	if self.parent ~= event.attacker or self.frame ~= GetFrameCount() or event.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end
	if event.damage == 0 or event.damage ~= event.damage then return end

	local lifesteal = event.damage * self.lifesteal
	self.parent:HealWithParams(lifesteal, self.ability, true, false, self.parent, false)

	local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
end
