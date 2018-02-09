modifier_18_wave_debuff = class({})

function modifier_18_wave_debuff:GetTexture() 
	return "custom/orns_presence"
end

function modifier_18_wave_debuff:IsDebuff()
	return true 
end

function modifier_18_wave_debuff:IsPurgeException()
	return true 
end

function modifier_18_wave_debuff:IsHidden()
	return false
end

function modifier_18_wave_debuff:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end

function modifier_18_wave_debuff:OnCreated(kv)
	if IsServer() then 
		if self:GetParent():IsRealHero() then
			self:StartIntervalThink(1)
		end
	end
end

function modifier_18_wave_debuff:OnIntervalThink()
	if not self:GetParent():IsInvulnerable() then
		self:GetParent():ModifyHealth(self:GetParent():GetHealth()-50, nil, true, 0)
		self:GetParent():ManaBurn(nil, nil, 30, nil, nil, true)
	end
end

function modifier_18_wave_debuff:OnDeath(params)
	if IsServer() then 
		if params.attacker == self:GetParent() 
		and params.unit:GetTeamNumber() ~= params.attacker:GetTeamNumber() 
		and not self:GetParent():IsInvulnerable() then 
			params.attacker:ModifyHealth(self:GetParent():GetHealth()-100, nil, true, 0)
		end
	end
end