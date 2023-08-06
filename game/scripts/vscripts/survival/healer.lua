function OnStartTouch(trigger)
	local ent = trigger.activator
	ent:AddNewModifier(trigger.activator, nil, "modifier_lia_healer_effect", nil)
end

function OnEndTouch(trigger)
	local ent = trigger.activator
	ent:RemoveModifierByName("modifier_lia_healer_effect")
end

LinkLuaModifier("modifier_lia_healer_effect", "survival/healer.lua" ,LUA_MODIFIER_MOTION_NONE)

modifier_lia_healer_effect = class({})

function modifier_lia_healer_effect:IsHidden()
	return true
end

function modifier_lia_healer_effect:GetEffectName()
	return "particles/generic_gameplay/radiant_fountain_regen.vpcf"
end	

function modifier_lia_healer_effect:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end	

function modifier_lia_healer_effect:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_MANA_REGEN_TOTAL_PERCENTAGE,
		MODIFIER_PROPERTY_HEALTH_REGEN_PERCENTAGE,
	}
 
	return funcs
end

function modifier_lia_healer_effect:GetModifierHealthRegenPercentage(params)
	return 10
end

function modifier_lia_healer_effect:GetModifierTotalPercentageManaRegen(params)
	return 10
end

