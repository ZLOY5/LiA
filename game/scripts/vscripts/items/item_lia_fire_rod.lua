item_lia_fire_rod = class({})

LinkLuaModifier("modifier_item_lia_fire_rod", "items/item_lia_fire_rod", LUA_MODIFIER_MOTION_NONE)

function item_lia_fire_rod:GetIntrinsicModifierName()
	return "modifier_item_lia_fire_rod"
end

function item_lia_fire_rod:OnSpellStart()
	self.wave_range = self:GetSpecialValueFor( "wave_range" )
	self.wave_width = self:GetSpecialValueFor( "wave_width" )
	self.wave_speed = self:GetSpecialValueFor( "wave_speed" )

	local vPos = nil
	if self:GetCursorTarget() then
		vPos = self:GetCursorTarget():GetOrigin()
	else
		vPos = self:GetCursorPosition()
	end

	local vDirection = vPos - self:GetCaster():GetOrigin()
	vDirection.z = 0.0
	vDirection = vDirection:Normalized()

	self.wave_speed = self.wave_speed * ( self.wave_range / ( self.wave_range - self.wave_width ) )

	local info = {
		EffectName = "particles/units/heroes/hero_dragon_knight/dragon_knight_breathe_fire.vpcf",
		Ability = self,
		vSpawnOrigin = self:GetCaster():GetOrigin(), 
		fStartRadius = self.wave_width,
		fEndRadius = self.wave_width,
		vVelocity = vDirection * self.wave_speed,
		fDistance = self.wave_range,
		Source = self:GetCaster(),
		iUnitTargetTeam = DOTA_UNIT_TARGET_TEAM_ENEMY,
		iUnitTargetType = DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,
	}

	ProjectileManager:CreateLinearProjectile( info )
	EmitSoundOn("Hero_DragonKnight.BreathFire", self:GetCaster())
end

function item_lia_fire_rod:OnProjectileHit( hTarget, vLocation )
	if hTarget ~= nil and ( not hTarget:IsMagicImmune() ) and ( not hTarget:IsInvulnerable() ) then
		self.wave_damage = self:GetSpecialValueFor( "wave_damage" )

		local damage = {
			victim = hTarget,
			attacker = self:GetCaster(),
			damage = self.wave_damage,
			damage_type = DAMAGE_TYPE_MAGICAL,
			ability = self
		}

		ApplyDamage( damage )
	end

	return false
end

---@class modifier_item_lia_fire_rod:CDOTA_Modifier_Lua
modifier_item_lia_fire_rod = class({})

function modifier_item_lia_fire_rod:IsHidden() return true end
function modifier_item_lia_fire_rod:IsPurgable() return false end
function modifier_item_lia_fire_rod:GetOrbPriority() return DOTA_ORB_PRIORITY_ITEM end

function modifier_item_lia_fire_rod:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_MANA_BONUS
	}
end

function modifier_item_lia_fire_rod:OnCreated()
	if IsServer() then RegisterOrbEffectModifier(self) end
	
	self.ability = self:GetAbility()
	self.parent = self:GetParent()

	self:OnRefresh()
end

function modifier_item_lia_fire_rod:OnRefresh()
	self.bonus_damage = self.ability:GetSpecialValueFor("bonus_damage")
	self.bonus_mana = self.ability:GetSpecialValueFor("bonus_mana")
	self.radius = self.ability:GetSpecialValueFor("radius")

	self.damage_table = {
		attacker = self.parent,
		damage = self.bonus_damage,
		damage_type = DAMAGE_TYPE_PURE,
		ability = self.ability
	}
end

function modifier_item_lia_fire_rod:GetModifierPreAttack_BonusDamage()
	return self.bonus_damage
end

function modifier_item_lia_fire_rod:GetModifierManaBonus()
	return self.bonus_mana 
end

function modifier_item_lia_fire_rod:GetOrbProjectileName()
	return "particles/units/heroes/hero_phoenix/phoenix_base_attack.vpcf"
end

function modifier_item_lia_fire_rod:OnOrbFire()
	self.parent:EmitSound("Hero_Jakiro.Attack")
end

function modifier_item_lia_fire_rod:OnOrbImpact(event)
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
