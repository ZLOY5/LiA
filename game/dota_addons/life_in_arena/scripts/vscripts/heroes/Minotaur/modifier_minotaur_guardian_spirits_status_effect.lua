modifier_minotaur_guardian_spirits_status_effect = class({})

--------------------------------------------------------------------------------

function modifier_minotaur_guardian_spirits_status_effect:IsHidden()
	return false
end

--------------------------------------------------------------------------------

function modifier_minotaur_guardian_spirits_status_effect:IsPurgable()
	return false
end

function modifier_minotaur_guardian_spirits_status_effect:AllowIllusionDuplicate()
	return true
end

function modifier_minotaur_guardian_spirits_status_effect:OnCreated(kv)
	self.caster = self:GetCaster()
	self.unit = self:GetParent()
	self.outgoing_damage = kv.outgoing_damage
	self.incoming_damage = kv.incoming_damage
end

if IsServer() then
	function modifier_minotaur_guardian_spirits_status_effect:OnDeath()
		-- if #self:GetCaster().guardian_spirits > 0 then
			for i = 1, #self:GetCaster().guardian_spirits do
				if self:GetCaster().guardian_spirits[i] == self:GetParent() then
					table.remove(self:GetCaster().guardian_spirits, i)
				end
			end
		-- end
		local particleName = "particles/units/heroes/hero_elder_titan/elder_titan_ancestral_spirit_cast.vpcf"

		self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_ABSORIGIN_FOLLOW, self.caster)
		ParticleManager:SetParticleControl( self.FXIndex, 0, self.unit:GetAbsOrigin() )
		ParticleManager:SetParticleControl( self.FXIndex, 2, self.unit:GetAbsOrigin() )
	end
		
end

function modifier_minotaur_guardian_spirits_status_effect:GetStatusEffectName()
	if GetLocalPlayerTeam() == self:GetParent():GetTeamNumber() then
	    return "particles/custom/tauren_chieftain/tauren_chieftain_guardian_spirit_status_effect.vpcf"
	end
end

function modifier_minotaur_guardian_spirits_status_effect:StatusEffectPriority()
	return 10000
end

function modifier_minotaur_guardian_spirits_status_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_DAMAGEOUTGOING_PERCENTAGE_ILLUSION,
		MODIFIER_PROPERTY_ILLUSION_LABEL,
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
		MODIFIER_PROPERTY_IS_ILLUSION
	}
 
	return funcs
end

function modifier_minotaur_guardian_spirits_status_effect:GetModifierDamageOutgoing_Percentage_Illusion()
	return self.outgoing_damage
end

function modifier_minotaur_guardian_spirits_status_effect:GetModifierIllusionLabel()
	return 1
end

function modifier_minotaur_guardian_spirits_status_effect:GetModifierIncomingDamage_Percentage()
	return self.incoming_damage
end

function modifier_minotaur_guardian_spirits_status_effect:GetIsIllusion()
	return true
end