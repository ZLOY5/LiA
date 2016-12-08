
--[[Based on Pizzalol's datadriven Berserker's Call]]

function OnSuccess( keys )
	local ability = keys.ability
	local target = keys.target
	local caster = keys.caster
	local duration = ability:GetSpecialValueFor("duration")
	local radius = ability:GetSpecialValueFor("cleave_radius")
	local cleave_percent = ability:GetSpecialValueFor("cleave_percent")*keys.attack_damage*0.01

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

	local fv = caster:GetAbsOrigin()+caster:GetForwardVector()*radius
	local targets = FindUnitsInRadius(caster:GetTeam(), 
										fv, 
										nil, radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	if caster:GetAttackCapability() == DOTA_UNIT_CAP_MELEE_ATTACK then
		DoCleaveAttack(caster,target,ability,cleave_percent, radius, "particles/custom/items/hammer_of_titans_cleave.vpcf")
		for _,v in pairs(targets) do
			ability:ApplyDataDrivenModifier(caster,v,"modifier_item_lia_hammer_of_titans_slow",nil)
		end
	end	
	
end

