archmage_shooting_star = class({})


function archmage_shooting_star:OnUpgrade()
	if self:GetCaster().shootingStarStackCount == nil then
		self:GetCaster().shootingStarStackCount = 0
		print(self:GetCaster().shootingStarStackCount)
	end
end

function archmage_shooting_star:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function archmage_shooting_star:GetManaCost(level)

	local defManaCost =  self.BaseClass.GetManaCost( self, level )
	local charge_limit = self:GetSpecialValueFor("charge_limit") 
	local manacost_per_charge = self:GetSpecialValueFor("manacost_per_charge") 

	if self:GetIntAttr("stackCount") == nil then
		return defManaCost
	elseif self:GetIntAttr("stackCount") > charge_limit then
		return defManaCost + manacost_per_charge*charge_limit
	else
		return defManaCost + manacost_per_charge*self:GetIntAttr("stackCount")
	end
	--print(self:GetCaster().shootingStarStackCount)
	
end

function archmage_shooting_star:OnSpellStart()
	local damagePerCharge = self:GetSpecialValueFor("damage_per_charge") 
	local damageInit = self:GetSpecialValueFor("initial_damage") 
	local charge_limit = self:GetSpecialValueFor("charge_limit") 
	local charge_duration = self:GetSpecialValueFor("charge_duration")
	local target = self:GetCursorTarget()

	local starfall_delay = self:GetSpecialValueFor("starfall_delay")

	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_ABSORIGIN, nil, target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Mirana.Starstorm.Cast", target )

	Timers:CreateTimer(starfall_delay,
		function()
			if target ~= nil and ( not target:IsInvulnerable() ) and ( not target:TriggerSpellAbsorb( self ) ) and ( not target:IsMagicImmune() ) then

				if self:GetCaster().shootingStarStackCount > charge_limit then
					self:GetCaster().shootingStarDamageToDeal = damageInit + damagePerCharge*charge_limit
				else
					self:GetCaster().shootingStarDamageToDeal = damageInit + damagePerCharge*self:GetCaster().shootingStarStackCount
				end

				local starDamage = {
						victim = target,
						attacker = self:GetCaster(),
						damage = self:GetCaster().shootingStarDamageToDeal,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}

				ApplyDamage(starDamage)

				self:GetCaster().shootingStarStackCount = self:GetCaster().shootingStarStackCount + 1
				self:SetIntAttr("stackCount",self:GetCaster().shootingStarStackCount)

				Timers:CreateTimer(charge_duration,
					function()
						self:GetCaster().shootingStarStackCount = self:GetCaster().shootingStarStackCount - 1
						self:SetIntAttr("stackCount",self:GetCaster().shootingStarStackCount)
					end
				)


				
			end	
		end
	)


end