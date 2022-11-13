spider_queen_spider_yarn = class({})
LinkLuaModifier("modifier_spider_queen_spider_yarn_thinker","heroes/SpiderQueen/modifier_spider_queen_spider_yarn_thinker.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_spider_queen_spider_yarn_debuff","heroes/SpiderQueen/modifier_spider_queen_spider_yarn_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function spider_queen_spider_yarn:GetAOERadius()
	return self:GetSpecialValueFor( "radius" )
end

function spider_queen_spider_yarn:OnUpgrade()
	if not self.webs_table then self.webs_table = {} end
end

function spider_queen_spider_yarn:OnSpellStart()
	local web_thinker = CreateModifierThinker(
		self:GetCaster(),
		self,
		"modifier_spider_queen_spider_yarn_thinker",
		{ 
			duration = self:GetSpecialValueFor("base_duration") 
		},
		self:GetCursorPosition(),
		self:GetCaster():GetTeamNumber(),
		false
	)	
end				

function spider_queen_spider_yarn:OnSpiderDeath()
	if IsServer() then
		for k, v in pairs (self.webs_table) do
			v:SetDuration(v:GetRemainingTime() + v.bonus_duration_per_spider, true)
		end
	end
end