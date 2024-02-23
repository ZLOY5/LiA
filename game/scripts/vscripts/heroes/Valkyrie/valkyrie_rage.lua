valkyrie_rage = class({})
LinkLuaModifier("modifier_valkyrie_rage","heroes/Valkyrie/modifier_valkyrie_rage.lua",LUA_MODIFIER_MOTION_NONE)

function valkyrie_rage:OnSpellStart() 
	if IsServer() then
		self.duration = self:GetSpecialValueFor("duration")
		self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_valkyrie_rage", {duration = self.duration})
		EmitSoundOn("Hero_PhantomAssassin.Dagger.Cast", self:GetCaster())

		local fx = ParticleManager:CreateParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
		ParticleManager:SetParticleControl(fx, 2, Vector(radius,radius,0))
		ParticleManager:ReleaseParticleIndex(fx)
	end
end
