modifier_tauren_champion_finish_off_counter = class({})

function modifier_tauren_champion_finish_off_counter:IsHidden()
	return false
end

function modifier_tauren_champion_finish_off_counter:IsPurgable()
	return true
end

function modifier_tauren_champion_finish_off_counter:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self:GetParent().finishOffCounter, true)
	end
end


