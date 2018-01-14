wave_16_mana_burn_extreme = class({})

function wave_16_mana_burn_extreme:OnAbilityPhaseStart()
	if IsServer() then
		self.hTarget = self:GetCursorTarget()

		if self.hTarget:GetMana() == 0 then
			SendErrorMessage(self:GetCaster():GetPlayerOwnerID(), "#error_must_target_mana_unit")
			self:GetCaster():Interrupt()
			return false
		end
		return true
	end
end

function wave_16_mana_burn_extreme:OnSpellStart()
	if IsServer() then
		if self.hTarget:TriggerSpellAbsorb(self) then
			return 
		end

		local mana_burn = self:GetSpecialValueFor( "mana_burn" ) 
		local damage_per_mana = self:GetSpecialValueFor(  "damage_per_mana" )

		self.hTarget:ManaBurn(self:GetCaster(), self, mana_burn, damage_per_mana, DAMAGE_TYPE_MAGICAL, true)
		local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_nyx_assassin/nyx_assassin_mana_burn.vpcf", PATTACH_CUSTOMORIGIN, nil )
		ParticleManager:SetParticleControl( nFXIndex, 0, self.hTarget:GetOrigin() )
		self.hTarget:EmitSound("Hero_NyxAssassin.ManaBurn.Target")
	end
end

