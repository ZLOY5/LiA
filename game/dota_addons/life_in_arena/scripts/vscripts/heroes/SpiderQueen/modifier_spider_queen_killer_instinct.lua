modifier_spider_queen_killer_instinct = class({})

function modifier_spider_queen_killer_instinct:IsHidden()
	return false
end

function modifier_spider_queen_killer_instinct:IsPurgable()
	return true
end

function modifier_spider_queen_killer_instinct:OnCreated( kv )
	self.damage = self:GetAbility():GetSpecialValueFor( "damage" )
	self.full_damage_radius = self:GetAbility():GetSpecialValueFor( "full_radius" )
	self.half_damage_radius = self:GetAbility():GetSpecialValueFor( "half_radius" )
	self.attacks_count = self:GetAbility():GetSpecialValueFor( "attacks_count" )
	if IsServer() then
		self:SetStackCount(self.attacks_count)
		self.particle = ParticleManager:CreateParticle( "particles/units/heroes/hero_broodmother/broodmother_hunger_buff.vpcf", PATTACH_CUSTOMORIGIN, self:GetParent() )
		ParticleManager:SetParticleControlEnt( self.particle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_thorax", self:GetParent():GetAbsOrigin(), true )
		self:AddParticle( self.particle, false, false, -1, false, false  )
	end
end

function modifier_spider_queen_killer_instinct:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.particle, true)
		ParticleManager:ReleaseParticleIndex(self.particle)
	end
end

function modifier_spider_queen_killer_instinct:DeclareFunctions()
	local funcs =
	{
		MODIFIER_EVENT_ON_ATTACK_LANDED,
	}
	return funcs
end

function modifier_spider_queen_killer_instinct:OnAttackLanded( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			local hTarget = params.target
			local hAttacker = params.attacker
			
			if hTarget ~= nil and ( hAttacker:GetTeamNumber() ~= hTarget:GetTeamNumber() ) then
				local full_damage_targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
										hTarget:GetAbsOrigin(), 
										nil, self.full_damage_radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)

				local half_damage_targets = FindUnitsInRadius(self:GetParent():GetTeam(), 
										hTarget:GetAbsOrigin(), 
										nil, self.half_damage_radius, 
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC, 
										DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES, 0, false)


				for k,v in pairs (half_damage_targets) do	
					if full_damage_targets[k] ~= nil then
						ApplyDamage({ victim = v, attacker = params.attacker, damage = self.damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() })
					else
						ApplyDamage({ victim = v, attacker = params.attacker, damage = self.damage/2, damage_type = DAMAGE_TYPE_PHYSICAL, ability = self:GetAbility() })
					end
				end
			end
			self:DecrementStackCount()
			if self:GetStackCount() <= 0 then
				self:Destroy()
			end
		end
	end

	return 0.0
end