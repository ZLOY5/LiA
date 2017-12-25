paladin_grace = class ({})

function paladin_grace:OnSpellStart()
	if IsServer() then
		self.primary_target_heal = self:GetSpecialValueFor( "primary_target_heal" )
		self.zombie_butcher_bonus_damage_max = self:GetCaster():GetBaseDamageMax() * self:GetSpecialValueFor( "zombie_butcher_damage_percent" ) * 0.01
		self.circle_radius = self:GetSpecialValueFor( "circle_radius" )

		local target = self:GetCursorTarget()
		

		EmitSoundOn("Hero_Undying.Tombstone", self:GetCaster())
	end
end
