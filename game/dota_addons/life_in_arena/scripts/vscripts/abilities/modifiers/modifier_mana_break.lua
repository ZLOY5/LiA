modifier_mana_break = class({})

--------------------------------------------------------------------------------

function modifier_mana_break:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_mana_break:IsPurgable()
	return false
end

--------------------------------------------------------------------------------

function modifier_mana_break:OnCreated( kv )
	self.mana_per_hit = self:GetAbility():GetSpecialValueFor( "mana_per_hit" )
	self.damage_per_mana = self:GetAbility():GetSpecialValueFor( "damage_per_mana" )
end

--------------------------------------------------------------------------------

function modifier_mana_break:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

--------------------------------------------------------------------------------

function modifier_mana_break:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			if params.attacker:PassivesDisabled() then
				return 
			end

			params.target:ManaBurn(params.attacker, self:GetAbility(), self.mana_per_hit, self.damage_per_mana, DAMAGE_TYPE_PHYSICAL, true)
			local nFXIndex = ParticleManager:CreateParticle( "particles/generic_gameplay/generic_manaburn.vpcf", PATTACH_CUSTOMORIGIN, nil )
			ParticleManager:SetParticleControl( nFXIndex, 0, params.target:GetOrigin() )
			params.target:EmitSound("Hero_Antimage.ManaBreak")
		end
	end

end

--------------------------------------------------------------------------------
