function OnIntervalThink(event)
	local damage = event.damage
	if damage >= event.target:GetHealth() then
		damage = event.target:GetHealth()-1
	end 
	ApplyDamage({ victim = event.target, attacker = event.caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = event.ability}) 
end

function modifier_plague_aura_datadriven_on_created(event)
	if event.target:HasModifier(event.modifier_name_damage) then
		event.ability:ApplyDataDrivenModifier(event.caster, event.target, event.modifier_name_damage,{duration = -1}) 
	end
	Timers:CreateTimer(event.immunity_time,function()
		if event.target:HasModifier(event.modifier_name) then
			event.ability:ApplyDataDrivenModifier(event.caster, event.target, event.modifier_name_damage,{duration = -1}) 
		end
	end)
end

function modifier_plague_aura_datadriven_on_destroy(event)
	if event.target:HasModifier(event.modifier_name_damage) then
		event.ability:ApplyDataDrivenModifier(event.caster, event.target, event.modifier_name_damage,{duration = event.plague_time}) 
	end
end