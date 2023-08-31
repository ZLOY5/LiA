item_lia_health_elixir = class({})

function item_lia_health_elixir:CastFilterResult()
	if self:GetCaster():GetHealthPercent() == 100 then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function item_lia_health_elixir:GetCustomCastError()
	return "lia_hud_error_heal_potion_full_hp"
end

function item_lia_health_elixir:OnSpellStart()
	self:GetCaster():Heal(self:GetSpecialValueFor("heal_amount"), self)

	local particle = ParticleManager:CreateParticle("particles/items_fx/healing_flask.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle,false)
		ParticleManager:ReleaseParticleIndex(particle)
	end)
	
	self:SetCurrentCharges(self:GetCurrentCharges()-1)
	if self:GetCurrentCharges() == 0 then
		self:RemoveSelf()
	end
end

