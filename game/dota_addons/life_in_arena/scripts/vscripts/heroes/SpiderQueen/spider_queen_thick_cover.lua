spider_queen_thick_cover = class({})
LinkLuaModifier("modifier_spider_queen_thick_cover","heroes/SpiderQueen/modifier_spider_queen_thick_cover.lua",LUA_MODIFIER_MOTION_NONE)

function spider_queen_thick_cover:GetIntrinsicModifierName()
	return "modifier_spider_queen_thick_cover"
end

function spider_queen_thick_cover:OnUpgrade()
	local agility = self:GetLevelSpecialValueFor("bonus_base_agility", 0)
	self:GetCaster():ModifyAgility(agility)
end