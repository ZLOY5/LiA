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

	self.fMoveDuration = self.fDistanceToTravel / self.iSpeed

	local vDirection = self.vPos - self.vCasterPosition
	vDirection.z = 0.0
	if vDirection:Length2D() < 1 then
		local vForward = self:GetCaster():GetForwardVector()
		vDirection = Vector(vForward.x, vForward.y, 0)
	end
	vDirection = vDirection:Normalized()

	self.vTargetPosition = self.vCasterPosition + vDirection * self.fDistanceToTravel
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

