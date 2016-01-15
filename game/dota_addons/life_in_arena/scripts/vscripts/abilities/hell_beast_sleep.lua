function hell_beast_sleep_on_spell_start(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	
	local duration = event.duration_creep
	if event.target:IsRealHero() or string.find(event.target:GetUnitName(),"megaboss") then 
		duration = event.duration_hero
	end
	event.ability:ApplyDataDrivenModifier(event.caster, event.target, "modifier_hellbeast_sleep", {duration = duration})
	event.target:AddNewModifier(event.caster, event.ability, "modifier_invulnerable", {duration = event.duration_invul})
end