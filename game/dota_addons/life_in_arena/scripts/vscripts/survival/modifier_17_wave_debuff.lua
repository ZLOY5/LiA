modifier_17_wave_debuff = class({})

function modifier_17_wave_debuff:GetTexture() 
	return "orns_presence"
end

function modifier_17_wave_debuff:IsDebuff()
	return true 
end

function modifier_17_wave_debuff:IsPurgeException()
	return true 
end

function modifier_17_wave_debuff:IsHidden()
	return false
end

function modifier_17_wave_debuff:OnCreated(kv)
	if IsServer() then 
		if self:GetParent():IsRealHero() then
			self:StartIntervalThink(1)
		end
	end
end

function modifier_17_wave_debuff:OnIntervalThink()
	self:GetParent():ModifyHealth(self:GetParent():GetHealth()-50, nil, true, 0)
	self:GetParent():ReduceMana(30)
end
