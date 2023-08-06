walking_dead_decay = class({})
LinkLuaModifier("modifier_walking_dead_decay_self","heroes/WalkingDead/modifier_walking_dead_decay_self.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_walking_dead_decay_regen","heroes/WalkingDead/modifier_walking_dead_decay_regen.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_walking_dead_decay_debuff","heroes/WalkingDead/modifier_walking_dead_decay_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function walking_dead_decay:OnToggle()
	self.caster = self:GetCaster()
	self.decay_duration = self:GetSpecialValueFor( "decay_duration" )

	if self:GetToggleState() then 

		self.decay_duration = self:GetSpecialValueFor( "decay_duration" )
		self.caster:AddNewModifier(self:GetCaster(), self, "modifier_walking_dead_decay_self", {duration = self.decay_duration})

		self.caster:EmitSound("Hero_Pudge.Rot")
	else 
		self.regeneration_duration = self:GetSpecialValueFor( "regeneration_duration" )
		self.caster:RemoveModifierByName("modifier_walking_dead_decay_self")
		self.caster:AddNewModifier(self:GetCaster(), self, "modifier_walking_dead_decay_regen", {duration = self.regeneration_duration})
		if self.caster:FindAbilityByName("walking_dead_vitality"):GetLevel() > 0 then
			self.caster:FindModifierByName("modifier_walking_dead_vitality"):ReleaseDelayedCharges()
		end
		self.caster:StopSound("Hero_Pudge.Rot")
	end

end
