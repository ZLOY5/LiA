function OnIntervalThink(event)
	local damage = event.damage
	if damage >= event.targer:GetHealth() then
		damage = event.targer:GetHealth()-1
	end 
	ApplyDamage({victim = event.target, attacker = event.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGIC}) 
end