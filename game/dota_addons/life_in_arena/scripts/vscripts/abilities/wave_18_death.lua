function NoCorpse(keys)
	local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_dragon_knight/dragon_knight_transform_green.vpcf", PATTACH_POINT, keys.ability:GetCaster() )
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, keys.ability:GetCaster(), PATTACH_POINT, "attach_point", keys.ability:GetCaster():GetAbsOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )
	keys.caster:SetModel("models/development/invisiblebox.vmdl")
end