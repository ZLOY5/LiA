spider_queen_infection = class({})
LinkLuaModifier("modifier_spider_queen_infection","heroes/SpiderQueen/modifier_spider_queen_infection.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spider_queen_infection_debuff","heroes/SpiderQueen/modifier_spider_queen_infection_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function spider_queen_infection:GetIntrinsicModifierName()
	return "modifier_spider_queen_infection"
end

function spider_queen_infection:OnAbilityPhaseStart()
    if IsServer() then
        local spider_max_count = self:GetSpecialValueFor("spider_max_count")
        local alive_spiders = self:GetCaster():FindModifierByName("modifier_spider_queen_infection"):GetStackCount()
        if spider_max_count - alive_spiders <= 0 then
            return false 
        end
        
        self.spiders_to_spawn = spider_max_count / 2
    end

    return true
end

function spider_queen_infection:OnSpellStart() 
    local caster = self:GetCaster()
    local front_position = caster:GetAbsOrigin() + caster:GetForwardVector() * 65
    for i=1,self.spiders_to_spawn,1 do
        self:SpawnSpider(front_position)
    end
    EmitSoundOn("Hero_Broodmother.SpawnSpiderlings", self:GetCaster())
end

function spider_queen_infection:SpawnSpider(vLocation)
    if IsServer() then
        local spider_max_count = self:GetSpecialValueFor("spider_max_count")
        local alive_spiders = self:GetCaster():FindModifierByName("modifier_spider_queen_infection"):GetStackCount()
        if spider_max_count - alive_spiders <= 0 then return end

        local caster = self:GetCaster()
        local spider_duration = self:GetSpecialValueFor("spider_duration")
        local spider_name = "npc_dota_broodmother_spiderling_custom_"..tostring(self:GetLevel())
        local spider = CreateUnitByName(spider_name, vLocation, false, caster, caster, caster:GetTeam())
        spider:SetControllableByPlayer(caster:GetPlayerOwnerID(), false)
        spider:AddNewModifier(caster, nil, "modifier_kill", { duration = spider_duration })
        spider:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
        ResolveNPCPositions(vLocation, 65)
        caster:FindModifierByName("modifier_spider_queen_infection"):IncrementStackCount()
    end
end