minotaur_thunder_strike = class({})
LinkLuaModifier("modifier_minotaur_thunder_strike","heroes/Minotaur/modifier_minotaur_thunder_strike.lua",LUA_MODIFIER_MOTION_NONE)

function minotaur_thunder_strike:OnAbilityPhaseStart()
	if IsServer() then

		if self:GetCaster():IsRealHero() then
			if self:GetCaster().guardian_spirits ~= nil and #self:GetCaster().guardian_spirits > 0 then
				for i = 1, #self:GetCaster().guardian_spirits do
					local unit = self:GetCaster().guardian_spirits[i]
					if IsValidEntity(unit) then
						print("GOTOV KASTOVAT")
						-- unit:StartGesture(ACT_DOTA_CAST_ABILITY_1)
						unit:CastAbilityNoTarget(unit:FindAbilityByName("minotaur_thunder_strike"), self:GetCaster():GetPlayerID())
					end
				end
			end
			return true

		else 
			return true
		end
	end
end

function minotaur_thunder_strike:OnAbilityPhaseInterrupted()
	if IsServer() then

		if self:GetCaster():IsRealHero() then
			if self:GetCaster().guardian_spirits ~= nil and #self:GetCaster().guardian_spirits > 0 then
				for i = 1, #self:GetCaster().guardian_spirits do
					local unit = self:GetCaster().guardian_spirits[i]
					print("PRERVANO")
					-- unit:StartGesture(ACT_DOTA_CAST_ABILITY_1)
					unit:Interrupt()
				end
			end
		end
	end
end

function minotaur_thunder_strike:OnSpellStart()
	self.caster = self:GetCaster()
	self.caster:RemoveGesture(ACT_DOTA_CAST_ABILITY_1)
	self.radius = self:GetSpecialValueFor( "radius" )

	self.damage = self:GetSpecialValueFor( "damage" )
	self.slow_duration = self:GetSpecialValueFor( "slow_duration" )

	local targets = FindUnitsInRadius(self.caster:GetTeamNumber(),
										self.caster:GetAbsOrigin(),
										nil,
										self.radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false)

	for _,v in pairs(targets) do

		ApplyDamage({ victim = v, attacker = self.caster, damage = self.damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self })
		v:AddNewModifier(self.caster, self, "modifier_minotaur_thunder_strike", {duration = self.slow_duration})
	end

	local particleName = "particles/econ/items/brewmaster/brewmaster_offhand_elixir/brewmaster_thunder_clap_elixir.vpcf"

	self.FXIndex = ParticleManager:CreateParticle( particleName, PATTACH_POINT, self.caster)
	ParticleManager:SetParticleControl( self.FXIndex, 0, self.caster:GetAbsOrigin() )
	ParticleManager:SetParticleControl( self.FXIndex, 1, Vector( self.radius, 0, 0 ) )
	ParticleManager:ReleaseParticleIndex(self.FXIndex)

	EmitSoundOn( "Hero_Centaur.HoofStomp", self.caster )
end
