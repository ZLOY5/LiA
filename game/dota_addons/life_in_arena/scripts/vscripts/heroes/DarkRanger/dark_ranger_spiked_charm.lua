dark_ranger_spiked_charm = class({})

LinkLuaModifier("modifier_dark_ranger_spiked_charm", "heroes/DarkRanger/modifier_dark_ranger_spiked_charm.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_dark_ranger_spiked_charm_aura", "heroes/DarkRanger/modifier_dark_ranger_spiked_charm_aura.lua", LUA_MODIFIER_MOTION_NONE)

function dark_ranger_spiked_charm:GetIntrinsicModifierName()
	return "modifier_dark_ranger_spiked_charm"
end

