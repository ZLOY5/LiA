modifier_archmage_anomaly_thinker = class({})

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:IsAura()
	return true
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:GetModifierAura()
	return "modifier_archmage_anomaly_effect"
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_CREEP + DOTA_UNIT_TARGET_HERO
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:GetAuraDuration()
	return 0.1
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:GetAuraRadius()
	return self.radius
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:OnCreated( kv )
	self.radius = self:GetAbility():GetSpecialValueFor( "radius" )
	if IsServer() then
		self.AnomalyParticle = ParticleManager:CreateParticle("particles/econ/items/faceless_void/faceless_void_mace_of_aeons/fv_chronosphere_aeons.vpcf",PATTACH_ABSORIGIN,self:GetParent())
		ParticleManager:SetParticleControl(self.AnomalyParticle,1,Vector(self.radius,self.radius,self.radius))
		--self:GetParent():EmitSound("Hero_FacelessVoid.Chronosphere")
	end
end

--------------------------------------------------------------------------------

function modifier_archmage_anomaly_thinker:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.AnomalyParticle,true)
		--self:GetParent():StopSound("Hero_FacelessVoid.Chronosphere")
	end
end

--------------------------------------------------------------------------------