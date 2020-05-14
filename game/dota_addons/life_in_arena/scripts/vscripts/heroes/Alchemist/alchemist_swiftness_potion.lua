alchemist_swiftness_potion = class({})
LinkLuaModifier("modifier_alchemist_swiftness_potion_caster","heroes/Alchemist/modifier_alchemist_swiftness_potion_caster.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_alchemist_swiftness_potion_enemy","heroes/Alchemist/modifier_alchemist_swiftness_potion_enemy.lua",LUA_MODIFIER_MOTION_NONE)

function alchemist_swiftness_potion:OnSpellStart()
	self.iSpeed = self:GetSpecialValueFor( "speed" )
	self.fDistanceToTravel = self:GetSpecialValueFor( "distance" )
	self.fHitWidth = self:GetSpecialValueFor( "hit_width" )
	self.iDamage = self:GetSpecialValueFor( "damage" )

	self.vCasterPosition = self:GetCaster():GetAbsOrigin()
	self.vPos = self:GetCursorPosition()

	local fDistance = (self.vPos - self.vCasterPosition):Length2D()
	local fDistanceLeft = self.fDistanceToTravel - fDistance
	local fMoveDuration = self.fDistanceToTravel / self.iSpeed


	self.relation = fDistanceLeft / fDistance
	self.fTargetPositionX = self.vPos.x + (self.vPos.x - self.vCasterPosition.x) * self.relation
	self.fTargetPositionY = self.vPos.y + (self.vPos.y - self.vCasterPosition.y) * self.relation
	self.vTargetPosition = Vector(self.fTargetPositionX, self.fTargetPositionY, self.vCasterPosition.z)
	--self.old_position = self.unit_origin
	self.fDistancePerTick = self.iSpeed * 0.03


	local kv =
	{
		caster_position = self.vCasterPosition,
		target_position = self.vTargetPosition, 
		duration = fMoveDuration,
		distance_per_tick = self.fDistancePerTick,
	}
	self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_alchemist_swiftness_potion_caster", kv )

	if self:GetCaster():HasScepter() then
		
	end

end

