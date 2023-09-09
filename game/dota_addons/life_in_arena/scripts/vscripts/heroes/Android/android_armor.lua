android_armor = class({}) 
LinkLuaModifier("modifier_android_armor", "heroes/Android/modifier_android_armor.lua", LUA_MODIFIER_MOTION_NONE)

function android_armor:GetIntrinsicModifierName()
	return "modifier_android_armor" 
end