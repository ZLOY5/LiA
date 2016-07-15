archmage_shooting_star = class({})

function archmage_shooting_star:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function archmage_shooting_star:GetManaCost(level)
	local defManaCost =  self.BaseClass.GetManaCost( self, level )
	local charge_limit = self:GetSpecialValueFor("charge_limit") 
	local manacost_per_charge = self:GetSpecialValueFor("manacost_per_charge") 
	local netTable = CustomNetTables:GetTableValue("custom_modifier_state",tostring(self:GetEntityIndex()))

	local charges = 0
	if netTable then 
		charges = netTable.stackCount
	end

	if charges > charge_limit then
		return defManaCost + manacost_per_charge*charge_limit
	else
		return defManaCost + manacost_per_charge*charges

	end
	--print(self:GetCaster().shootingStarStackCount)
	
end

function archmage_shooting_star:OnSpellStart()
	local damagePerCharge = self:GetSpecialValueFor("damage_per_charge") 
	local damageInit = self:GetSpecialValueFor("initial_damage") 
	local charge_limit = self:GetSpecialValueFor("charge_limit") 
	local charge_duration = self:GetSpecialValueFor("charge_duration")
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()

	if caster.shootingStarStackCount == nil then
		caster.shootingStarStackCount = 0
		CustomNetTables:SetTableValue("custom_modifier_state",tostring(self:GetEntityIndex()),{ stackCount = 0 })
	end

	local starfall_delay = self:GetSpecialValueFor("starfall_delay")

	local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN, target)
	ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_ABSORIGIN, nil, target:GetOrigin(), true )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

	EmitSoundOn( "Hero_Mirana.Starstorm.Cast", target )

	Timers:CreateTimer(starfall_delay,
		function()
			if target ~= nil and ( not target:IsInvulnerable() ) and ( not target:TriggerSpellAbsorb( self ) ) and ( not target:IsMagicImmune() ) then

				if caster.shootingStarStackCount > charge_limit then
					caster.shootingStarDamageToDeal = damageInit + damagePerCharge*charge_limit
				else
					caster.shootingStarDamageToDeal = damageInit + damagePerCharge*self:GetCaster().shootingStarStackCount
				end

				local starDamage = {
						victim = target,
						attacker = caster,
						damage = caster.shootingStarDamageToDeal,
						damage_type = DAMAGE_TYPE_MAGICAL,
					}

				ApplyDamage(starDamage)

				caster.shootingStarStackCount = caster.shootingStarStackCount + 1
				CustomNetTables:SetTableValue("custom_modifier_state",tostring(self:GetEntityIndex()),{ stackCount = caster.shootingStarStackCount })
				Timers:CreateTimer(charge_duration,
					function()
						caster.shootingStarStackCount = caster.shootingStarStackCount - 1
						CustomNetTables:SetTableValue("custom_modifier_state",tostring(self:GetEntityIndex()),{ stackCount = caster.shootingStarStackCount })
					end
				)


				
			end	
		end
	)


end