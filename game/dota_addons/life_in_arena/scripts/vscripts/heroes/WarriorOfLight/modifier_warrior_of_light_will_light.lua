modifier_warrior_of_light_will_light = class({})

function modifier_warrior_of_light_will_light:IsHidden()
	return true
end

function modifier_warrior_of_light_will_light:IsPurgable()
	return false
end

function modifier_warrior_of_light_will_light:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end

function modifier_warrior_of_light_will_light:OnTakeDamage(params)
	if params.unit == self:GetParent() and not params.unit:IsIllusion() and not (params.damage_flags % (2*DOTA_DAMAGE_FLAG_REFLECTION) >= DOTA_DAMAGE_FLAG_REFLECTION) then
		if params.unit:PassivesDisabled() then
			return 0
		end

		local radius = self:GetAbility():GetSpecialValueFor("AuraRadius")
		local damage_return = self:GetAbility():GetSpecialValueFor("absord_proc")*params.damage
		--print(damage_return)
		local targets_enemy = FindUnitsInRadius(params.unit:GetTeam(), params.unit:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL-DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, FIND_ANY_ORDER, false)
		for _,target in pairs(targets_enemy) do
			ApplyDamage(
			{
				victim = target, 
				attacker = params.unit, 
				damage = damage_return, 
				damage_type = DAMAGE_TYPE_PHYSICAL,
				damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
				ability = params.ability
			})
		end

		local targets_friendly = FindUnitsInRadius(params.unit:GetTeam(), params.unit:GetAbsOrigin(), params.unit, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_ALL-DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
		for _,target in pairs(targets_friendly) do
			if target ~= params.unit then 
				target:Heal(damage_return,params.unit)
				SendOverheadEventMessage(target:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, target, damage_return, nil)
			end
		end

	end
end