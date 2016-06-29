modifier_knight_cuirass_damage_return_lua = class ({})

--чтобы способность могла использовать этот модификатор в ней должен быть special value "damage_return"

function modifier_knight_cuirass_damage_return_lua:GetAttributes()
	return MODIFIER_ATTRIBUTE_MULTIPLE + MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_knight_cuirass_damage_return_lua:IsHidden()
	return true
end

function modifier_knight_cuirass_damage_return_lua:IsPurgable()
	return false
end

function modifier_knight_cuirass_damage_return_lua:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
 
	return funcs
end

function modifier_knight_cuirass_damage_return_lua:OnAttackLanded(params) 
	if IsServer() then
		if params.target == self:GetParent() and not self:GetParent():HasModifier("modifier_illusion") then 
			self.attack_record = params.record 
			self.ranged_attack = params.ranged_attack
		end 
	end
end


function modifier_knight_cuirass_damage_return_lua:OnTakeDamage(params)
	if IsServer() then
		if params.unit == self:GetParent() and not self:GetParent():HasModifier("modifier_illusion") and not IsFlagSet(params.damage_flags,DOTA_DAMAGE_FLAG_REFLECTION) then
			
			if self:GetParent():PassivesDisabled() then
				return 0
			end

			if self.attack_record == params.record and not self.ranged_attack then
				local target = params.unit
				
				local reflect_percent
				if target:HasModifier("modifier_item_lia_knight_cuirass_ability") then 
					reflect_percent = self:GetAbility():GetSpecialValueFor("damage_return_abi")
				else 
					reflect_percent = self:GetAbility():GetSpecialValueFor("damage_return")
				end 

				local return_damage = reflect_percent*0.01*params.original_damage
				
				local damageApplied = ApplyDamage(
				{
					victim = params.attacker, 
					attacker = target, 
					damage = return_damage, 
					damage_type = DAMAGE_TYPE_MAGICAL,
					damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
					ability = params.ability
				})
				--print("Original damage = ",params.original_damage," Damage to return = ",return_damage," Applied damdge = ",damageApplied)

			end
		end
	end
end

