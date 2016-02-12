modifier_orn_lua = class({})

function modifier_orn_lua:IsHidden()
	return true
end

function modifier_orn_lua:IsPurgable()
	return false 
end

function modifier_orn_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
	return funcs
end

function modifier_orn_lua:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			Survival:OnOrnDamaged(params)
		end
	end
end
