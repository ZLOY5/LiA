wave_2_centaur_chieftain_aura = class({})
LinkLuaModifier("modifier_wave_2_centaur_chieftain_aura", "abilities/modifier_wave_2_centaur_chieftain_aura.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_wave_2_centaur_chieftain_aura_effect", "abilities/modifier_wave_2_centaur_chieftain_aura_effect", LUA_MODIFIER_MOTION_NONE)

--------------------------------------------------------------------------------

function wave_2_centaur_chieftain_aura:GetIntrinsicModifierName()
	return "modifier_wave_2_centaur_chieftain_aura"
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
