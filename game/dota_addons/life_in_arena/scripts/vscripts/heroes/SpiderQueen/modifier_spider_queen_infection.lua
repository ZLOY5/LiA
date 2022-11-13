modifier_spider_queen_infection = class({})

function modifier_spider_queen_infection:IsHidden()
	return false
end

function modifier_spider_queen_infection:IsPurgable()
	return false
end

function modifier_spider_queen_infection:OnCreated( kv )
	self.infection_chance = self:GetAbility():GetSpecialValueFor( "infection_chance" )
	if IsServer() then
		self.pseudo = PseudoRandom:New(self.infection_chance*0.01)
	end
end

function modifier_spider_queen_infection:OnRefresh( kv )
	self.infection_chance = self:GetAbility():GetSpecialValueFor( "infection_chance" )
	if IsServer() then
		self.pseudo = PseudoRandom:New(self.infection_chance*0.01)
	end
end

function modifier_spider_queen_infection:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		MODIFIER_EVENT_ON_DEATH
	}
	return funcs
end

function modifier_spider_queen_infection:OnAttackLanded(params) 
	if params.attacker == self:GetParent() and not self:GetParent():IsIllusion() and (params.attacker:GetTeamNumber() ~= params.target:GetTeamNumber()) then 
		self.attack_record = params.record 
	end 
end

function modifier_spider_queen_infection:OnDeath(params)
	if IsServer() then
		if self.attack_record == params.record and self.pseudo:Trigger() and not self:GetParent():PassivesDisabled() and self:GetAbility():IsCooldownReady() then
			self:GetAbility():SpawnSpider(params.unit:GetAbsOrigin())
		elseif string.find(params.unit:GetUnitName(),"npc_dota_broodmother_spiderling_custom_") and (params.unit:GetTeamNumber() == self:GetParent():GetTeamNumber()) then
			local spider_yarn = self:GetParent():FindAbilityByName("spider_queen_spider_yarn")
			if spider_yarn and spider_yarn:GetLevel() > 0  then
				spider_yarn:OnSpiderDeath()
			end
			self:DecrementStackCount()
		end
	end
	return 0.0
end


