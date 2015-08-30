dark_knight_speed = class ({})
LinkLuaModifier("modifier_dark_knight_speed", "heroes/DarkKnight/modifier_dark_knight_speed.lua", LUA_MODIFIER_MOTION_NONE)

function dark_knight_speed:GetIntrinsicModifierName() 
	return "modifier_dark_knight_speed"
end