function item_hand_of_midas_datadriven_on_spell_start(keys)
	print("I RUN!@#")



	keys.caster:ModifyGold(keys.target:GetGoldBounty(), true, 0)  --Give the player a flat amount of reliable gold.
	keys.caster:AddExperience(keys.target:GetDeathXP(), false, false)  --Give the player some XP.
	
	--Start the particle and sound.
	keys.target:EmitSound("DOTA_Item.Hand_Of_Midas")
	local midas_particle = ParticleManager:CreateParticle("particles/items2_fx/hand_of_midas.vpcf", PATTACH_ABSORIGIN_FOLLOW, keys.target)	
	ParticleManager:SetParticleControlEnt(midas_particle, 1, keys.caster, PATTACH_POINT_FOLLOW, "attach_hitloc", keys.caster:GetAbsOrigin(), false)

	--Remove default gold/XP on the creep before killing it so the caster does not receive anything more.
	keys.target:SetDeathXP(0)
	keys.target:SetMinimumGoldBounty(0)
	keys.target:SetMaximumGoldBounty(0)
	keys.target:Kill(keys.ability, keys.caster) --Kill the creep.  This increments the caster's last hit counter.
end
