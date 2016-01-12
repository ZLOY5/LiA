function DeathCoil(event)
	local target = event.target
	if target:TriggerSpellAbsorb(event.ability) then
		--target:RemoveModifierByName("modifier_item_sphere_target")  --The particle effect is played automatically when this modifier is removed (but the sound isn't).
		--target:EmitSound("DOTA_Item.LinkensSphere.Activate")
		--print("Spell Absorb")
		return 
	end
	ApplyDamage({victim = target, attacker = event.caster, damage = event.ability:GetSpecialValueFor("damage"), damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability})
end