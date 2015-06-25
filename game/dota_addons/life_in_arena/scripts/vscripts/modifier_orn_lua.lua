modifier_orn_lua = class({})

function modifier_orn_lua:IsHidden()
	return true
end

function modifier_orn_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_DEATH,
	}
	return funcs
end

function modifier_orn_lua:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			LiA:OnOrnDamaged(params)
		end
	end
end

function modifier_orn_lua:OnDeath(params)
	if IsServer() then
		if params.unit == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			LiA:OnOrnDeath(params)
		end
	end
end
