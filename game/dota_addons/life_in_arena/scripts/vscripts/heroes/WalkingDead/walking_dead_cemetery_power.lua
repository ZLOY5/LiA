walking_dead_cemetery_power = class({})
LinkLuaModifier("modifier_walking_dead_cemetery_power","heroes/WalkingDead/modifier_walking_dead_cemetery_power.lua",LUA_MODIFIER_MOTION_NONE)

function walking_dead_cemetery_power:OnSpellStart()
	self.caster = self:GetCaster()
	self.duration = self:GetSpecialValueFor( "duration" )

	self.caster:AddNewModifier(self.caster, self, "modifier_walking_dead_cemetery_power", {duration = self.duration})
	self.caster:EmitSound("Hero_Undying.FleshGolem.Cast")

end