wave_1_poison_extreme = class({})
LinkLuaModifier( "modifier_wave_1_poison", "abilities/modifier_wave_1_poison", LUA_MODIFIER_MOTION_NONE )
LinkLuaModifier( "modifier_wave_1_poison_debuff", "abilities/modifier_wave_1_poison", LUA_MODIFIER_MOTION_NONE )

-------------------------------------------------------------------------

function wave_1_poison_extreme:GetIntrinsicModifierName()
	return "modifier_wave_1_poison"
end

-------------------------------------------------------------------------
