function NoCorpse(keys)
	keys.caster:AddNoDraw()
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf", PATTACH_CUSTOMORIGIN, nil )
	ParticleManager:SetParticleControl(nFXIndex,0,keys.caster:GetOrigin())
	
end