walking_dead_rot_curse = class({})
LinkLuaModifier("modifier_walking_dead_rot_curse_enemy","heroes/WalkingDead/modifier_walking_dead_rot_curse_enemy.lua",LUA_MODIFIER_MOTION_NONE)

function walking_dead_rot_curse:OnSpellStart()
	self.caster = self:GetCaster()
	self.target = self:GetCursorTarget()
	self.duration = self:GetSpecialValueFor( "duration" )

	if self.target:TriggerSpellAbsorb(self) then
		return 
	end

	self.target:AddNewModifier(self.caster, self, "modifier_walking_dead_rot_curse_enemy", {duration = self.duration})

	-- EmitSoundOn( "Hero_Treant.Overgrowth.Cast", self:GetCaster() )
end
