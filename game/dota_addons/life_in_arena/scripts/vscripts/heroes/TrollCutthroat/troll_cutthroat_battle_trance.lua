troll_cutthroat_battle_trance = class({})
LinkLuaModifier("modifier_troll_cutthroat_battle_trance","heroes/TrollCutthroat/modifier_troll_cutthroat_battle_trance.lua",LUA_MODIFIER_MOTION_NONE)


function troll_cutthroat_battle_trance:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_troll_cutthroat_battle_trance", {duration = duration})
end