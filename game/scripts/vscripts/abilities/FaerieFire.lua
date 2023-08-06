
function ApplyFaerieFire(event)
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = ability:GetSpecialValueFor("duration")

	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	
	if target:IsHero() or target:IsConsideredHero() then
		duration = ability:GetSpecialValueFor("hero_duration")
	end

	ability:ApplyDataDrivenModifier(caster, target, "modifier_faerie_fire", {duration=duration})
	target.faerie_fire_team = caster:GetTeamNumber() --If the druid dies, keep giving the vision

	--print("Apply faerie fire for "..duration)
end

-- Make vision every second (this is to prevent the vision staying if the modifier is purged)
function FaerieFireVision( event )
	local caster = event.caster
	local target = event.target

	AddFOWViewer( target.faerie_fire_team, target:GetAbsOrigin(), 500, 0.75, true)
end