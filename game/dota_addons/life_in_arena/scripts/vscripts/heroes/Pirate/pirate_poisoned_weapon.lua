pirate_poisoned_weapon = class({})
LinkLuaModifier("modifier_pirate_poisoned_weapon","heroes/Pirate/modifier_pirate_poisoned_weapon.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_pirate_poisoned_weapon_debuff","heroes/Pirate/modifier_pirate_poisoned_weapon_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function pirate_poisoned_weapon:GetIntrinsicModifierName()
	return "modifier_pirate_poisoned_weapon"
end

