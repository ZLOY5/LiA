function OnUpgrade(event)
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local chance = ability:GetLevelSpecialValueFor("crit_chance",level - 1)
	local modifier = caster:FindModifierByName("modifier_skeleton_thief_concentration_attack")

	if caster.skeletonThiefCritChance == nil then
		caster.skeletonThiefCritChance = chance
		modifier:SetStackCount(caster.skeletonThiefCritChance)
	end

	print(caster.skeletonThiefCritChance)

	if not caster:HasModifier("modifier_skeleton_thief_concentration_chance") then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_skeleton_thief_concentration_chance",nil)
	end
	
end

function Recalculate(event)
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local chance = ability:GetSpecialValueFor("crit_chance")
	local chance_cap = ability:GetSpecialValueFor("crit_chance_cap")
	local modifier = caster:FindModifierByName("modifier_skeleton_thief_concentration_attack")

	if caster.skeletonThiefCritChance + chance <= chance_cap then
		caster.skeletonThiefCritChance = caster.skeletonThiefCritChance + chance
		modifier:SetStackCount(caster.skeletonThiefCritChance)
	else
		caster.skeletonThiefCritChance = chance_cap
		modifier:SetStackCount(caster.skeletonThiefCritChance)
	end

	
end

function OnTakeDamage(event)
	local caster = event.caster
	local ability = event.ability

	caster:RemoveModifierByName("modifier_skeleton_thief_concentration_chance")
	

	
end

function OnAttackStart(event)
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local chance = ability:GetSpecialValueFor("crit_chance")

	local random = RandomInt(1,100)

	if random <= caster.skeletonThiefCritChance then
		ability:ApplyDataDrivenModifier(caster,caster,"modifier_skeleton_thief_concentration_crit",nil)
	end

end

function OnAttackLanded(event)
	local caster = event.caster
	local ability = event.ability
	local level = ability:GetLevel()
	local chance = ability:GetSpecialValueFor("crit_chance")
	local modifier = caster:FindModifierByName("modifier_skeleton_thief_concentration_attack")

	caster:RemoveModifierByName("modifier_skeleton_thief_concentration_crit")
	caster.skeletonThiefCritChance = chance
	modifier:SetStackCount(caster.skeletonThiefCritChance)
	ability:ApplyDataDrivenModifier(caster,caster,"modifier_skeleton_thief_concentration_chance",nil)

end