modifier_skeleton_mage_dark_magic = class({})

function modifier_skeleton_mage_dark_magic:IsHidden()
	return true
end

function modifier_skeleton_mage_dark_magic:IsPurgable()
	return false
end

function modifier_skeleton_mage_dark_magic:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_TAKEDAMAGE,
	}
 
	return funcs
end

function modifier_skeleton_mage_dark_magic:OnTakeDamage(params)
	if params.unit == self:GetParent() and not self:GetParent():IsIllusion() and not (params.damage_flags % (2*DOTA_DAMAGE_FLAG_REFLECTION) >= DOTA_DAMAGE_FLAG_REFLECTION) then
		if self:GetParent():PassivesDisabled() then
			return 0
		end

		local damage_return
		if self:GetParent():HasScepter() then 
			damage_return = self:GetAbility():GetSpecialValueFor("damage_return_scepter")
		else 
			damage_return = self:GetAbility():GetSpecialValueFor("damage_return")
		end

		ApplyDamage(
		{
			victim = params.attacker, 
			attacker = params.unit, 
			damage = damage_return, 
			damage_type = DAMAGE_TYPE_MAGICAL,
			damage_flags = DOTA_DAMAGE_FLAG_REFLECTION,
			ability = params.ability
		})
	end
end