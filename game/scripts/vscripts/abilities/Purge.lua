
function PurgeStart( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local bRemovePositiveBuffs = false
	local bRemoveDebuffs = false
	
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	
	-- Note: I really need to make a filter for buildings...
	if target:IsBuilding() then
		ability:RefundManaCost()
		ability:EndCooldown()
		return
	end
	
	if target:GetTeamNumber() ~= caster:GetTeamNumber() then
		bRemovePositiveBuffs = true
	else
		bRemoveDebuffs = true
	end
	target:Purge(bRemovePositiveBuffs, bRemoveDebuffs, false, false, false)
	target:EmitSound('n_creep_SatyrTrickster.Cast')
	ParticleManager:CreateParticle('particles/generic_gameplay/generic_purge.vpcf', PATTACH_ABSORIGIN_FOLLOW, target)
	if bRemovePositiveBuffs then
		if target:IsSummoned() or target:IsDominated() then
			ApplyDamage({
				victim = target,
				attacker = caster,
				damage = ability:GetSpecialValueFor('summoned_unit_damage'),
				damage_type = DAMAGE_TYPE_PURE, --Goes through MI
				ability = ability
			})
		end
		local duration = 0
		if target:IsHero() or target:IsConsideredHero() then
			duration = ability:GetSpecialValueFor('duration_hero')
		else
			duration = ability:GetSpecialValueFor('duration')
		end
		ability:ApplyDataDrivenModifier(caster, target, 'modifier_purge', {duration = duration}) 
	end
end

function ApplyPurge( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration = 0 
	local modifier = 'modifier_purge_slow'
	ability:ApplyDataDrivenModifier(caster, target, modifier, nil) 
	local stacks = ability:GetSpecialValueFor('stack_multi')
	target:SetModifierStackCount(modifier, ability, stacks)
end

function PurgeThink( event )
	local target = event.target
	local ability = event.ability
	local modifier = 'modifier_purge_slow'
	local new_stack = target:GetModifierStackCount(modifier, nil) - 1
	if new_stack > 0 then
		target:SetModifierStackCount(modifier, ability, new_stack)
	end
end