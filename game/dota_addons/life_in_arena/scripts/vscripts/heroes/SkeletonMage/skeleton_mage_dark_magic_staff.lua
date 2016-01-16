skeleton_mage_dark_magic_staff = class({})
LinkLuaModifier("modifier_skeleton_mage_dark_magic", "heroes/SkeletonMage/modifier_skeleton_mage_dark_magic.lua", LUA_MODIFIER_MOTION_NONE)


function skeleton_mage_dark_magic_staff:GetIntrinsicModifierName()
	return "modifier_skeleton_mage_dark_magic"
end