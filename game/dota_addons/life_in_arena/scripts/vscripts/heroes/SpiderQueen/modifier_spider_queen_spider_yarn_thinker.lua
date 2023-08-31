modifier_spider_queen_spider_yarn_thinker = class({})

function modifier_spider_queen_spider_yarn_thinker:IsHidden()
	return false
end

function modifier_spider_queen_spider_yarn_thinker:IsPurgable()
	return false
end

function modifier_spider_queen_spider_yarn_thinker:IsAura()
	return true
end

function modifier_spider_queen_spider_yarn_thinker:GetModifierAura()
	return "modifier_spider_queen_spider_yarn_debuff"
end

function modifier_spider_queen_spider_yarn_thinker:GetAuraSearchTeam()
	return DOTA_UNIT_TARGET_TEAM_ENEMY
end

function modifier_spider_queen_spider_yarn_thinker:GetAuraSearchType()
	return DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP
end

function modifier_spider_queen_spider_yarn_thinker:GetAuraSearchFlags()
	return DOTA_UNIT_TARGET_FLAG_NONE
end

function modifier_spider_queen_spider_yarn_thinker:GetAuraRadius()
	return self.radius
end

if IsServer() then
	function modifier_spider_queen_spider_yarn_thinker:OnCreated(kv)
		self.ability = self:GetAbility()
		table.insert(self.ability.webs_table, self)
		self.caster = self.ability:GetCaster()
		
		self.bIsSideEffectThinker = true
		self.damage_per_second = self.ability:GetSpecialValueFor( "damage_per_second" )

		self.radius = self.ability:GetSpecialValueFor("radius")
		self.bonus_duration_per_spider = self.ability:GetSpecialValueFor("bonus_duration_per_spider")

		self.webParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_broodmother/broodmother_web.vpcf",PATTACH_ABSORIGIN,self:GetParent())
		ParticleManager:SetParticleControl(self.webParticle,1,Vector(self.radius,0,self.radius))
		EmitSoundOn("Hero_Broodmother.SpinWebCast",self:GetParent())
		self:StartIntervalThink(1)		
	end


	function modifier_spider_queen_spider_yarn_thinker:OnIntervalThink()
		if IsServer() then
			local targets = FindUnitsInRadius(self.caster:GetTeamNumber(), 
												self:GetParent():GetAbsOrigin(), 
												nil, self.radius, 
												DOTA_UNIT_TARGET_TEAM_ENEMY, 
												DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, 
												DOTA_UNIT_TARGET_FLAG_NONE, 
												FIND_ANY_ORDER, 
												false)

			for k,v in pairs (targets) do
				ApplyDamage({ victim = v, attacker = self:GetCaster(), damage = self.damage_per_second, damage_type = DAMAGE_TYPE_MAGICAL, ability = self.ability })
			end 

		end
	end
end

function modifier_spider_queen_spider_yarn_thinker:OnDestroy()
	if IsServer() then
		for k,v in pairs (self.ability.webs_table) do
			if v == self then 
				table.remove(self.ability.webs_table, k) 
				break 
			end
		end
		ParticleManager:DestroyParticle(self.webParticle, false)
	end
end

