modifier_pure_light_protection = class({})

function modifier_pure_light_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
 
	return funcs
end

function modifier_pure_light_protection:IsPurgable()
	return false
end

function modifier_pure_light_protection:IsHidden()
	return false
end

function modifier_pure_light_protection:OnCreated(kv)
	if IsServer() then
		local thinker = EntIndexToHScript(kv.thinker)
		self.pureLightParticleTeher = ParticleManager:CreateParticle("particles/puck_dreamcoil_tether_pure_light.vpcf",PATTACH_POINT_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(self.pureLightParticleTeher, 0, thinker, PATTACH_POINT_FOLLOW, "follow_origin", thinker:GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(self.pureLightParticleTeher, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	end
	self.damagePerc = -self:GetAbility():GetSpecialValueFor("totem_damage_reduction")
end



function modifier_pure_light_protection:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.pureLightParticleTeher,false)
	end
end

function modifier_pure_light_protection:GetModifierIncomingDamage_Percentage()
	return self.damagePerc
end