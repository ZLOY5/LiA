spider_queen_killer_instinct = class({})
LinkLuaModifier("modifier_spider_queen_killer_instinct","heroes/SpiderQueen/modifier_spider_queen_killer_instinct.lua",LUA_MODIFIER_MOTION_NONE)

function spider_queen_killer_instinct:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_spider_queen_killer_instinct", {duration = duration})
    EmitSoundOn( "Hero_Broodmother.InsatiableHunger", self:GetCaster() )
end