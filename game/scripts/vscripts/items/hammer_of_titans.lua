
function OnSuccess( keys )
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("cleave_radius")
	local cleave_damage

	if caster:IsIllusion() then
		return 
	end

	local damageTable = {
						 	victim = target, 
						 	attacker = caster, 
						 	damage = ability:GetSpecialValueFor("bash_damage"), 
						 	damage_type = DAMAGE_TYPE_MAGICAL,
						 	ability = ability
						}

	ApplyDamage(damageTable)
	target:AddNewModifier(caster,ability,"modifier_stunned",{duration = ability:GetSpecialValueFor("bash_stun")})
	target:EmitSound("DOTA_Item.MKB.Minibash")

	local targets

	if caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		local fv = caster:GetAbsOrigin()+caster:GetForwardVector()*radius
		targets = FindUnitsInRadius(caster:GetTeam(), 
										fv, 
										nil, radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)
		cleave_damage = ability:GetSpecialValueFor("cleave_percent")*keys.attack_damage*0.01
		DoCleaveAttack(caster,target,ability,cleave_damage, radius, radius, radius, "particles/custom/items/hammer_of_titans_cleave.vpcf")		
	elseif caster:GetAttackCapability() == DOTA_UNIT_CAP_RANGED_ATTACK then
		targets = FindUnitsInRadius(caster:GetTeam(), 
										target:GetAbsOrigin(), 
										nil, radius/2, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)
		cleave_damage = ability:GetSpecialValueFor("splash_percent_ranged")*keys.attack_damage*0.01
		for _,v in pairs(targets) do
			ApplyDamage({
				victim = v, 
				attacker = caster, 
				damage = cleave_damage, 
				damage_type = DAMAGE_TYPE_PHYSICAL,
				ability = ability
		   })
		end
	end	
	
	for _,v in pairs(targets) do
		ability:ApplyDataDrivenModifier(caster,v,"modifier_item_lia_hammer_of_titans_slow",nil)
	end
	
end

