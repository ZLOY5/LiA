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
	LiA:OnOrnDamaged(params)
end

function modifier_orn_lua:OnDeath(params)
	LiA:OnOrnDeath(params)
end
