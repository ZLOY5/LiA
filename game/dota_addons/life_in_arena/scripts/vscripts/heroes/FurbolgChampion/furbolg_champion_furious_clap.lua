furbolg_champion_furious_clap = class({})

function furbolg_champion_furious_clap:OnAbilityPhaseStart()
    self.trigger_health_cost = true
    return true
end

function furbolg_champion_furious_clap:OnSpellStart()
    local caster = self:GetCaster()
    local damage = self:GetSpecialValueFor("initial_damage") + self:GetSpecialValueFor("damage_per_strength") * self:GetCaster():GetStrength()
    local stun_duration = self:GetSpecialValueFor("stun_duration")
    local radius = self:GetSpecialValueFor("radius")
    local health_cost = self:GetSpecialValueFor("health_cost")

    local sharp_claws = caster:FindModifierByName("modifier_furbolg_champion_sharp_claws")
    if sharp_claws then
        if sharp_claws.full_stacks then
            self.sharp_claws_ready = true
        else
            self.sharp_claws_ready = false
        end
    end

    if self.trigger_health_cost then
        local self_damage = {
            victim = caster,
            attacker = caster,
            damage = health_cost, 
            damage_type = DAMAGE_TYPE_PURE,
            ability = self,
            damage_flags = DOTA_DAMAGE_FLAG_NON_LETHAL + DOTA_DAMAGE_FLAG_HPLOSS + DOTA_DAMAGE_FLAG_NO_DAMAGE_MULTIPLIERS,
        }
    
        ApplyDamage( self_damage )
    end
    
    self.trigger_health_cost = false

    local targets = FindUnitsInRadius(caster:GetTeamNumber(),
										caster:GetAbsOrigin(),
										nil,
										radius,
										DOTA_UNIT_TARGET_TEAM_ENEMY, 
										DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
										DOTA_UNIT_TARGET_FLAG_NONE, 
										FIND_ANY_ORDER, 
										false) 

    for _,v in pairs(targets) do
        local damage = {
            victim = v,
            attacker = caster,
            damage = damage,
            damage_type = DAMAGE_TYPE_MAGICAL,
            ability = self
        }

        if self.sharp_claws_ready then
            v:AddNewModifier(caster, self, "modifier_stunned", {duration = stun_duration})
        end

        ApplyDamage( damage )
    end

    local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_ursa/ursa_earthshock.vpcf", PATTACH_WORLDORIGIN, nil )
	ParticleManager:SetParticleControl( nFXIndex, 0, self:GetCaster():GetOrigin() )
	ParticleManager:SetParticleControlForward( nFXIndex, 0, self:GetCaster():GetForwardVector() )
	ParticleManager:SetParticleControl( nFXIndex, 1, Vector(radius/2, radius/2, radius/2) )
	ParticleManager:ReleaseParticleIndex( nFXIndex )

    EmitSoundOn( "Hero_Ursa.Earthshock", caster )
end