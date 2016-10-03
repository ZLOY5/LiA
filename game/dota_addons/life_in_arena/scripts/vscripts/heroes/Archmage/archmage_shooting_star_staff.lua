archmage_shooting_star_staff = class({})
LinkLuaModifier("modifier_archmage_shooting_star_stacks", "heroes/Archmage/modifier_archmage_shooting_star_stacks.lua",LUA_MODIFIER_MOTION_NONE)

function archmage_shooting_star_staff:GetIntrinsicModifierName() 
	return "modifier_archmage_shooting_star_stacks"
end

function archmage_shooting_star_staff:GetCastAnimation()
	return ACT_DOTA_CAST_ABILITY_4
end

function archmage_shooting_star_staff:OnUpgrade()
	local modifier = self:GetCaster():FindModifierByName("modifier_archmage_shooting_star_stacks")
	local stacks = modifier:GetStackCount()
	local charge_limit = self:GetSpecialValueFor("charge_limit") 

	if self:GetCaster().shootingStarStackCount ~= nil  then
		if self:GetCaster().shootingStarStackCount >= charge_limit then
			modifier:SetStackCount(charge_limit)	
			ParticleManager:SetParticleControl(self:GetCaster().shootingStarOverhead, modifier:GetStackCount(), Vector(1,0,0))	
		end	
	end
end

function archmage_shooting_star_staff:GetManaCost(level)
	local caster = self:GetCaster()
	local defManaCost =  self.BaseClass.GetManaCost( self, level )
	local charge_limit = self:GetSpecialValueFor("charge_limit") 
	local manacost_per_charge = self:GetSpecialValueFor("manacost_per_charge") 
	local netTable = CustomNetTables:GetTableValue("custom_modifier_state",tostring(caster:GetEntityIndex()).."shootingStar")

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

function archmage_shooting_star_staff:OnSpellStart()
	local damagePerCharge = self:GetSpecialValueFor("damage_per_charge") 
	local damageInit = self:GetSpecialValueFor("initial_damage") 
	local charge_limit = self:GetSpecialValueFor("charge_limit") 
	local charge_duration = self:GetSpecialValueFor("charge_duration")
	local anomaly_radius = self:GetSpecialValueFor("anomaly_radius")
	local target = self:GetCursorTarget()
	local caster = self:GetCaster()
	local stack_modifier = caster:FindModifierByName("modifier_archmage_shooting_star_stacks")
	local half_damage_radius = self:GetSpecialValueFor("half_damage_radius")

	if caster.shootingStarStackCount == nil then
		caster.shootingStarStackCount = 0
		CustomNetTables:SetTableValue("custom_modifier_state",tostring(caster:GetEntityIndex()).."shootingStar",{ stackCount = 0 })
	end

	local starfall_delay = self:GetSpecialValueFor("starfall_delay")

	 

	caster.shootingStarStackCount = caster.shootingStarStackCount + 1
	if caster.shootingStarStackCount <= charge_limit then
		ParticleManager:SetParticleControl(caster.shootingStarOverhead, caster.shootingStarStackCount, Vector(1,0,0))
		stack_modifier:SetStackCount(caster.shootingStarStackCount)
		SetParticleStackCount(caster.shootingStarOverhead,caster.shootingStarStackCount)
	end

	CustomNetTables:SetTableValue("custom_modifier_state",tostring(caster:GetEntityIndex()).."shootingStar",{ stackCount = caster.shootingStarStackCount })
	self:MarkAbilityButtonDirty()
	Timers:CreateTimer(charge_duration,
		function()
			caster.shootingStarStackCount = caster.shootingStarStackCount - 1
			
			CustomNetTables:SetTableValue("custom_modifier_state",tostring(caster:GetEntityIndex()).."shootingStar",{ stackCount = caster.shootingStarStackCount })
			
			if caster.shootingStarStackCount < charge_limit then
				ParticleManager:SetParticleControl(caster.shootingStarOverhead, caster.shootingStarStackCount+1, Vector(0,0,0))
				
				stack_modifier = caster:FindModifierByName("modifier_archmage_shooting_star_stacks")
				if stack_modifier then
					stack_modifier:SetStackCount(caster.shootingStarStackCount)
				end
				SetParticleStackCount(caster.shootingStarOverhead,caster.shootingStarStackCount)
			end
			
			local ability = caster:FindAbilityByName("archmage_shooting_star") or caster:FindAbilityByName("archmage_shooting_star_staff")
			ability:MarkAbilityButtonDirty()
		
		end
	)	

	if target:HasModifier("modifier_archmage_anomaly") then

		EmitSoundOn( "Hero_Mirana.Starstorm.Cast", target )

		local searchForDummies = FindUnitsInRadius(self:GetCaster():GetTeamNumber(), 
													target:GetAbsOrigin(), 
													nil, anomaly_radius, 
													DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
													DOTA_UNIT_TARGET_ALL, 
													DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 
													FIND_ANY_ORDER, 
													false)


		for _,v in pairs(searchForDummies) do
			if v:GetUnitName() == "dummy_unit_anomaly" and v:GetOwner() == self:GetCaster() then
				local shootingStarsTargets = FindUnitsInRadius(self:GetCaster():GetTeam(), 
																v:GetAbsOrigin(), 
																nil, anomaly_radius, 
																DOTA_UNIT_TARGET_TEAM_ENEMY, 
																DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
																0, 
																FIND_ANY_ORDER, 
																false)

				if caster.shootingStarStackCount -1 > charge_limit then
					caster.shootingStarDamageToDeal = damageInit + damagePerCharge*charge_limit
				else
					caster.shootingStarDamageToDeal = damageInit + damagePerCharge*(self:GetCaster().shootingStarStackCount - 1)
				end

				for k,t in pairs(shootingStarsTargets) do

					local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, t)
					ParticleManager:SetParticleControlEnt( nFXIndex, 1, t, PATTACH_ABSORIGIN, nil, t:GetOrigin(), true )
					ParticleManager:ReleaseParticleIndex( nFXIndex )

					Timers:CreateTimer(starfall_delay,
						function()
							if t ~= nil and ( not t:IsInvulnerable() ) and ( not t:TriggerSpellAbsorb( self ) ) and ( not t:IsMagicImmune() ) then

								local starDamage = {
										victim = t,
										attacker = caster,
										damage = caster.shootingStarDamageToDeal,
										damage_type = DAMAGE_TYPE_MAGICAL,
									}

								ApplyDamage(starDamage)
								
								EmitSoundOn( "Hero_Mirana.Starstorm.Impact", target )
							end	
						end
					)


				end



			end 
			
		end

	else

		local nFXIndex = ParticleManager:CreateParticle( "particles/econ/items/mirana/mirana_starstorm_bow/mirana_starstorm_starfall_attack.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		ParticleManager:SetParticleControlEnt( nFXIndex, 1, target, PATTACH_ABSORIGIN, nil, target:GetOrigin(), true )
		ParticleManager:ReleaseParticleIndex( nFXIndex )

		EmitSoundOn( "Hero_Mirana.Starstorm.Cast", target )

		Timers:CreateTimer(starfall_delay,
			function()
				if target ~= nil and ( not target:IsInvulnerable() ) and ( not target:TriggerSpellAbsorb( self ) ) and ( not target:IsMagicImmune() ) then

					if caster.shootingStarStackCount -1 > charge_limit then
						caster.shootingStarDamageToDeal = damageInit + damagePerCharge*charge_limit
					else
						caster.shootingStarDamageToDeal = damageInit + damagePerCharge*(self:GetCaster().shootingStarStackCount - 1)
					end

			--		print(caster.shootingStarDamageToDeal)

					local starDamage = {
							victim = target,
							attacker = caster,
							damage = caster.shootingStarDamageToDeal,
							damage_type = DAMAGE_TYPE_MAGICAL,
						}

					ApplyDamage(starDamage)

					local halfDamageTargets = FindUnitsInRadius(self:GetCaster():GetTeam(), 
																target:GetAbsOrigin(), 
																nil, half_damage_radius, 
																DOTA_UNIT_TARGET_TEAM_ENEMY, 
																DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
																0, 
																FIND_ANY_ORDER, 
																false)

					for a,b in pairs(halfDamageTargets) do

						

						if b ~= target then

							local halfDamage = {
									victim = b,
									attacker = caster,
									damage = caster.shootingStarDamageToDeal/2,
									damage_type = DAMAGE_TYPE_MAGICAL,
									}

							ApplyDamage(halfDamage)
							
						end


					end
					
					EmitSoundOn( "Hero_Mirana.Starstorm.Impact", target )
				end	
			end
		)
	end

--	print(self:GetCaster().shootingStarStackCount, " s SP")
end

function SetParticleStackCount(pIndex,nStackCount)
	for i=1,7 do
		if i <= nStackCount then
			ParticleManager:SetParticleControl(pIndex, i, Vector(1,0,0))
		else
			ParticleManager:SetParticleControl(pIndex, i, Vector(0,0,0))
		end
	end
end