---@class hermit_frost_arrows:CDOTA_Ability_Lua
hermit_frost_arrows = class ({})
LinkLuaModifier("modifier_hermit_frost_arrows","heroes/Hermit/hermit_frost_arrows.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_hermit_frost_arrows_debuff","heroes/Hermit/hermit_frost_arrows.lua",LUA_MODIFIER_MOTION_NONE)

function hermit_frost_arrows:GetIntrinsicModifierName()
	return "modifier_hermit_frost_arrows"
end

function hermit_frost_arrows:GetManaCost( hTarget )
	if 	self:GetCaster():HasItemInInventory("item_lia_spherical_staff") then
		return self:GetSpecialValueFor( "manacost_scepter" )
	end

	return self.BaseClass.GetManaCost( self, hTarget )
end

---@class modifier_hermit_frost_arrows:CDOTA_Modifier_Lua
modifier_hermit_frost_arrows = class({})

function modifier_hermit_frost_arrows:IsHidden() return true end
function modifier_hermit_frost_arrows:IsPurgable() return false end
function modifier_hermit_frost_arrows:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_hermit_frost_arrows:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()
end

function modifier_hermit_frost_arrows:GetOrbProjectileName()
	return "particles/units/heroes/hero_drow/drow_frost_arrow.vpcf"
end

function modifier_hermit_frost_arrows:IsOrbActive(event)
	if self.parent:GetCurrentActiveAbility() ~= self.ability and not self.ability:GetAutoCastState() then return false end
	if event.target:IsMagicImmune() then return false end

	if self.ability:IsFullyCastable() and self.ability:IsOwnersManaEnough() and self.ability:IsCooldownReady() then return true end
end

function modifier_hermit_frost_arrows:OnOrbFire(event)
	self.ability:UseResources(true, true, true, true)
end

function modifier_hermit_frost_arrows:OnOrbImpact(event)
	local target = event.target

	if self:GetCaster():HasScepter() then
		self.damage = self.ability:GetSpecialValueFor( "damage_scepter" )
		self.duration = self.ability:GetSpecialValueFor("duration_scepter")
	else
		self.damage = self.ability:GetSpecialValueFor( "damage" )
		self.duration = self.ability:GetSpecialValueFor("duration")
	end

	target:EmitSound("Hero_DrowRanger.FrostArrows")

	target:AddNewModifier(self.parent, self.ability, "modifier_hermit_frost_arrows_debuff", {duration = self.duration})

	ApplyDamage({
		victim = target,
		attacker = self.parent,
		damage = self.damage,
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self.ability,
	})
end

---@class modifier_hermit_frost_arrows_debuff:CDOTA_Modifier_Lua
modifier_hermit_frost_arrows_debuff = class({})

function modifier_hermit_frost_arrows_debuff:IsHidden() return false end
function modifier_hermit_frost_arrows_debuff:IsPurgable() return true end
function modifier_hermit_frost_arrows_debuff:IsDebuff() return true end

function modifier_hermit_frost_arrows_debuff:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT
	}
end

function modifier_hermit_frost_arrows_debuff:OnCreated()
	self.ability = self:GetAbility()
	if self:GetCaster():HasScepter() then
		self.movespeed_slow_pct = self.ability:GetSpecialValueFor( "movespeed_slow_pct_scepter" )
		self.attack_slow = self.ability:GetSpecialValueFor("attack_slow_scepter")
	else
		self.movespeed_slow_pct = self.ability:GetSpecialValueFor( "movespeed_slow_pct" )
		self.attack_slow = self.ability:GetSpecialValueFor("attack_slow")
	end
end

function modifier_hermit_frost_arrows_debuff:GetModifierMoveSpeedBonus_Percentage()
	return self.movespeed_slow_pct
end

function modifier_hermit_frost_arrows_debuff:GetModifierAttackSpeedBonus_Constant()
	return self.movespeed_slow_pct
end

function modifier_hermit_frost_arrows_debuff:GetStatusEffectName()
	return "particles/status_fx/status_effect_frost_lich.vpcf"
end

function modifier_hermit_frost_arrows_debuff:StatusEffectPriority()
	return 10
end