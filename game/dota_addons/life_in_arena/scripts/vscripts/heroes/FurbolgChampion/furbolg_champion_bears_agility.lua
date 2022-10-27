furbolg_champion_bears_agility = class({})
LinkLuaModifier("modifier_furbolg_champion_bears_agility","heroes/FurbolgChampion/modifier_furbolg_champion_bears_agility.lua",LUA_MODIFIER_MOTION_NONE)


function furbolg_champion_bears_agility:OnSpellStart()
    local duration = self:GetSpecialValueFor("duration")
    self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_furbolg_champion_bears_agility", {duration = duration})
    EmitSoundOn( "Hero_Ursa.Overpower", self:GetCaster() )
end