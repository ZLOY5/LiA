knight_dark_shield = class({})

LinkLuaModifier("modifier_knight_dark_shield", "heroes/Knight/modifier_knight_dark_shield.lua", LUA_MODIFIER_MOTION_NONE)

function knight_dark_shield:GetIntrinsicModifierName()
	return "modifier_knight_dark_shield"
end

