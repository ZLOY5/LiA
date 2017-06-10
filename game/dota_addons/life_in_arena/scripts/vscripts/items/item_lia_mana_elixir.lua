item_lia_mana_elixir = class({})

function item_lia_mana_elixir:CastFilterResult()
	if self:GetCaster():GetMana() == self:GetCaster():GetMaxMana() then
		return UF_FAIL_CUSTOM
	end
	return UF_SUCCESS
end

function item_lia_mana_elixir:GetCustomCastError()
	return "lia_hud_error_mana_potion_full_mana"
end

function item_lia_mana_elixir:OnSpellStart()
	self:GetCaster():GiveMana( self:GetSpecialValueFor("mana_amount") )

	local particle = ParticleManager:CreateParticle("particles/items_fx/healing_clarity.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetCaster())
	Timers:CreateTimer(1, function()
		ParticleManager:DestroyParticle(particle,false)
		ParticleManager:ReleaseParticleIndex(particle)
	end)
	
	self:SetCurrentCharges(self:GetCurrentCharges()-1)
	if self:GetCurrentCharges() == 0 then
		self:RemoveSelf()
	end
end
