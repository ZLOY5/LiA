---@class item_lia_blood_blade:CDOTA_Item_Lua
item_lia_blood_blade = class({})

LinkLuaModifier("modifier_item_lia_blood_blade", "items/item_lia_blood_blade", LUA_MODIFIER_MOTION_NONE)

function item_lia_blood_blade:GetIntrinsicModifierName()
	return "modifier_item_lia_blood_blade"
end

function item_lia_blood_blade:OnSpellStart()
	local caster = self:GetCaster()
	local healtsteal_percent = self:GetSpecialValueFor("healtsteal_percent") * 0.01
	local healtsteal_radius = self:GetSpecialValueFor("healtsteal_radius")
	local healtsteal_limit = self:GetSpecialValueFor("healtsteal_limit")
	local healtsteal_max_damage = self:GetSpecialValueFor("healtsteal_max_damage")

	local damage_table = {
		victim = nil,
		attacker = caster,
		damage = 0,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self
	}
	local heal_amount = 0
    local units = FindUnitsInRadius(caster:GetTeam(),
									caster:GetAbsOrigin(),
									nil,
									healtsteal_radius,
									DOTA_UNIT_TARGET_TEAM_ENEMY,
									DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO,
									DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
									FIND_ANY_ORDER,
									false)
    for _, unit in pairs(units) do
    	damage_table.damage = unit:GetHealth() * healtsteal_percent
    	damage_table.damage = damage_table.damage <= healtsteal_max_damage and damage_table.damage or healtsteal_max_damage
    	damage_table.victim = unit
    	heal_amount = heal_amount + ApplyDamage(damage_table)
    end
    if heal_amount > healtsteal_limit then
    	heal_amount = healtsteal_limit
    end
    caster:Heal(heal_amount, caster)

	EmitSoundOn("hero_bloodseeker.bloodRage",caster)

	local fx = ParticleManager:CreateParticle("particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodbath_eztzhok.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
	ParticleManager:SetParticleControl(fx, 2, Vector(radius,radius,0))
	ParticleManager:ReleaseParticleIndex(fx)
end 

---@class modifier_item_lia_blood_blade:CDOTA_Modifier_Lua
modifier_item_lia_blood_blade = class({})

function modifier_item_lia_blood_blade:IsHidden() return true end
function modifier_item_lia_blood_blade:IsPurgable() return false end
function modifier_item_lia_blood_blade:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_blood_blade:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
end

function modifier_item_lia_blood_blade:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
	
	self:OnRefresh()
end

function modifier_item_lia_blood_blade:OnRefresh()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.lifesteal = self.ability:GetSpecialValueFor("lifesteal_percent") * 0.01
end

function modifier_item_lia_blood_blade:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_blood_blade:OnOrbImpact(event)
	if event.target:GetTeamNumber() ~= event.attacker:GetTeamNumber() and not event.attacker:HasAbility("vampire_lifesteal") then
		self.frame = GetFrameCount()
	end
end

function modifier_item_lia_blood_blade:OnTakeDamage(event)
	if self.parent ~= event.attacker or self.frame ~= GetFrameCount() or event.damage_type ~= DAMAGE_TYPE_PHYSICAL then return end
	if event.damage == 0 or event.damage ~= event.damage then return end

	local lifesteal = event.damage * self.lifesteal
	self.parent:HealWithParams(lifesteal, self.ability, true, false, self.parent, false)

	local lifesteal_pfx = ParticleManager:CreateParticle("particles/generic_gameplay/generic_lifesteal.vpcf", PATTACH_ABSORIGIN_FOLLOW, self.parent)
	ParticleManager:ReleaseParticleIndex(lifesteal_pfx)
end

