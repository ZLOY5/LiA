alchemist_swiftness_potion = class({})
LinkLuaModifier("modifier_alchemist_swiftness_potion_caster","heroes/Alchemist/modifier_alchemist_swiftness_potion_caster.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alchemist_swiftness_potion_enemy","heroes/Alchemist/modifier_alchemist_swiftness_potion_enemy.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alchemist_swiftness_potion_buff","heroes/Alchemist/modifier_alchemist_swiftness_potion_buff.lua",LUA_MODIFIER_MOTION_NONE)


function alchemist_swiftness_potion:OnSpellStart()
	self.iSpeed = self:GetSpecialValueFor( "speed" )
	self.fDistanceToTravel = self:GetSpecialValueFor( "distance" )
	self.fHitWidth = self:GetSpecialValueFor( "hit_width" )
	self.iDamage = self:GetSpecialValueFor( "damage" )

	self.vCasterPosition = self:GetCaster():GetAbsOrigin()
	self.vPos = self:GetCursorPosition()

	self.fDistance = (self.vPos - self.vCasterPosition):Length2D()
	self.fDistanceLeft = self.fDistanceToTravel - self.fDistance
	self.fMoveDuration = self.fDistanceToTravel / self.iSpeed


	self.relation = self.fDistanceLeft / self.fDistance
	self.fTargetPositionX = self.vPos.x + (self.vPos.x - self.vCasterPosition.x) * self.relation
	self.fTargetPositionY = self.vPos.y + (self.vPos.y - self.vCasterPosition.y) * self.relation
	self.vTargetPosition = Vector(self.fTargetPositionX, self.fTargetPositionY, self.vCasterPosition.z)
	self.fDistancePerTick = self.iSpeed * 0.03


	local kv =
	{
		caster_position = self.vCasterPosition,
		target_position = self.vTargetPosition, 
		duration = self.fMoveDuration,
		distance_per_tick = self.fDistancePerTick,
	}
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_alchemist_swiftness_potion_caster", kv )

	EmitSoundOn( "Hero_Alchemist.UnstableConcoction.Throw", self:GetCaster() )

end

