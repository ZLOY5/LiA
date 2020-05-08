skeleton_mage_dark_magic = class({})
LinkLuaModifier("modifier_skeleton_mage_dark_magic", "heroes/SkeletonMage/modifier_skeleton_mage_dark_magic.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_skeleton_mage_dark_magic_cooldown", "heroes/SkeletonMage/modifier_skeleton_mage_dark_magic_cooldown.lua", LUA_MODIFIER_MOTION_NONE)


function skeleton_mage_dark_magic:GetIntrinsicModifierName()
	return "modifier_skeleton_mage_dark_magic"
end