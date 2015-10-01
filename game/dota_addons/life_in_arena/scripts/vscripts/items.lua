function HealthTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetMaxHealth( casterUnit:GetMaxHealth() + 50 )
    --casterUnit:SetHealth(casterUnit:GetHealth() + 50)
    --BUG: When buying a new item, the Health will reset.

    --local item = CreateItem( "item_tome_of_health_modifier", source, source)
    --item:ApplyDataDrivenModifier(casterUnit, casterUnit, "modifier_tome_of_health_mod_1", {})
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_health_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_health_modifier", nil)
        picker:SetModifierStackCount("tome_health_modifier", picker, 30)
        picker.HealthTomesStack = 0
    else
        picker:SetModifierStackCount("tome_health_modifier", picker, (picker:GetModifierStackCount("tome_health_modifier", picker) + 30))
    end
    --print(event.caster:GetModifierStackCount("tome_health_modifier", nil))

    local TomePopUp = require("popups")
    PopupHealthTome(picker, 30)
end

function StrengthTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseStrength( casterUnit:GetBaseStrenght() + 1 )
    --casterUnit:ModifyStrength(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end


    if picker:HasModifier("tome_strenght_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_strenght_modifier", nil)
        picker:SetModifierStackCount("tome_strenght_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_strenght_modifier", picker, (picker:GetModifierStackCount("tome_strenght_modifier", picker) + statBonus))
    end
    --SetModifierStackCount(string modifierName, handle b, int modifierCount) 
    --GetModifierStackCount(string modifierName, handle b) 
    
    local TomePopUp = require("popups")
    PopupStrTome(picker, statBonus)
end

function AgilityTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseAgility( casterUnit:GetBaseAgility() + 1 )
    --casterUnit:ModifyAgility(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_agility_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_agility_modifier", nil)
        picker:SetModifierStackCount("tome_agility_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_agility_modifier", picker, (picker:GetModifierStackCount("tome_agility_modifier", picker) + statBonus))
    end

    local TomePopUp = require("popups")
    PopupAgiTome(picker, statBonus)
end

function IntellectTomeUsed( event )
    local picker = event.caster
    local tome = event.ability
    local statBonus = event.bonus_stat
    --casterUnit:SetBaseIntellect( casterUnit:GetBaseIntellect() + 1 )
    --casterUnit:ModifyIntellect(statBonus)
    if picker:IsRealHero() == false then
    	picker = picker:GetPlayerOwner():GetAssignedHero()
    end
    if picker:HasModifier("tome_intelect_modifier") == false then
        tome:ApplyDataDrivenModifier( picker, picker, "tome_intelect_modifier", nil)
        picker:SetModifierStackCount("tome_intelect_modifier", picker, statBonus)
    else
        picker:SetModifierStackCount("tome_intelect_modifier", picker, (picker:GetModifierStackCount("tome_intelect_modifier", picker) + statBonus))
    end

    local TomePopUp = require("popups")
    PopupIntTome(picker, statBonus)
end

function Heal(event)
    if event.caster:GetHealthPercent() ~= 100 then
        event.caster:Heal(event.heal_amount, event.caster)
        event.ability:SetCurrentCharges(event.ability:GetCurrentCharges()-1)
        if event.ability:GetCurrentCharges() == 0 then
            event.caster:RemoveItem(event.ability)
        end
    else
        FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_heal_potion_full_hp" } )
        event.ability:EndCooldown()
    end

end

function ReplenishMana(event)
    if event.caster:GetManaPercent() ~= 100 then
        event.caster:GiveMana(event.mana_amount)
        event.ability:SetCurrentCharges(event.ability:GetCurrentCharges()-1)
        if event.ability:GetCurrentCharges() == 0 then
            event.caster:RemoveItem(event.ability)
        end
    else
        FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_mana_potion_full_mana" } )
        event.ability:EndCooldown()
    end
end

function ReplenishManaAOE(event)

    -- Find units
    units = FindUnitsInRadius(event.caster:GetTeamNumber(),
                              event.caster:GetAbsOrigin(),
                              nil,
                              250,
                              DOTA_UNIT_TARGET_TEAM_FRIENDLY,
                              DOTA_UNIT_TARGET_ALL,
                              DOTA_UNIT_TARGET_FLAG_NONE,
                              FIND_ANY_ORDER,
                              false)
 
    for _,unit in pairs(units) do
        unit:GetPlayerOwner():GetAssignedHero():GiveMana(event.mana_amount)
    end
    event.caster:GetPlayerOwner():GetAssignedHero():GiveMana(event.mana_amount)
end


function DisableRegenOnEnemyNear(event) 
    print("Checking Units in Range")
    local units_in_range = FindUnitsInRadius(   DOTA_TEAM_GOODGUYS,
                                                event.caster:GetAbsOrigin(),
                                                nil,
                                                300,
                                                DOTA_UNIT_TARGET_TEAM_ENEMY,
                                                DOTA_UNIT_TARGET_ALL,
                                                DOTA_UNIT_TARGET_FLAG_NONE,
                                                FIND_ANY_ORDER,
                                                false)   
    if units_in_range[1] ~= nil then
        print("Regen Disabled")
        event.ability:ApplyDataDrivenModifier(hero, hero, "modifier_warchasers_solo_buff_combat", {})
    else 
        print ("No Units Found")
    end
    --event.ability:ApplyDataDrivenModifier(event.caster, event.target, "modifier_warchasers_solo_buff_combat", nil) 

end

function SummonInferno(event)
    local inferno_cast = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    local inferno_landed = ParticleManager:CreateParticle("particles/units/heroes/hero_warlock/warlock_rain_of_chaos_start.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(inferno_landed, 0, event.target:GetAbsOrigin())
end

function SummonDoomGuard(event)
    local doomguard = ParticleManager:CreateParticle("particles/units/heroes/hero_doom_bringer/doom_bringer_lvl_death_bonus.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(doomguard, 0, event.target:GetAbsOrigin())
end

function SummonRedDrake(event)
    local reddrake = ParticleManager:CreateParticle("particles/units/heroes/hero_dragon_knight/dragon_knight_transform_red.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(reddrake, 0, event.target:GetAbsOrigin())
end

function SummonFellhound(event)
    local fellhound = ParticleManager:CreateParticle("particles/econ/items/doom/doom_f2p_death_effect/doom_bringer_f2p_death.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(fellhound, 0, event.target:GetAbsOrigin())
end

function SummonTony(event)
    local tony = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_death_rocks.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(tony, 0, event.target:GetAbsOrigin())
    local tony = ParticleManager:CreateParticle("particles/units/heroes/hero_tiny/tiny_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(tony, 0, event.target:GetAbsOrigin())
end

function SummonFulborg(event)
    local bear = ParticleManager:CreateParticle("particles/units/heroes/hero_lone_druid/lone_druid_bear_spawn.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(bear, 0, event.target:GetAbsOrigin())
end

function FrostmourneAttack(event)
    --Deal 5% of the target's current health in physical damage
    ApplyDamage({
                    victim = event.target,
                    attacker = event.caster,
                    damage = event.target:GetHealth() * 0.05,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = event.ability
                    })
end

function FrostmourneRuin(event)
    --take 15% of targets max HP
    local targetHP = event.target:GetMaxHealth() * 0.15
    ApplyDamage({
                    victim = event.target,
                    attacker = event.caster,
                    damage = event.target:GetMaxHealth() * 0.15,
                    damage_type = DAMAGE_TYPE_PHYSICAL,
					ability = event.ability
                    })
    event.caster:Heal(targetHP, event.caster)
    local coil = ParticleManager:CreateParticle("particles/units/heroes/hero_abaddon/abaddon_aphotic_shield_explosion.vpcf", PATTACH_ABSORIGIN_FOLLOW, event.target)
    ParticleManager:SetParticleControl(coil, 0, event.target:GetAbsOrigin())

end

function GuldanSkull(event)

    local hero = EntIndexToHScript( event.caster_entindex )
    --hero:SetRenderColor(0, 0, 0)
    hero:SetModel("models/heroes/warlock/warlock_demon.vmdl")
    local feet_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_feet_effects.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)

    local transform_particle = ParticleManager:CreateParticle("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_transform.vpcf", PATTACH_ABSORIGIN_FOLLOW, hero)

    if hero:IsRangedAttacker() then
        hero:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
    else
        hero:SetAttackCapability(2)
        hero:SetRangedProjectileName("particles/units/heroes/hero_terrorblade/terrorblade_metamorphosis_base_attack.vpcf")
    end

    if hero:HasModifier("modifier_warchasers_solo_buff") then
        print("Removed Modifier")
        hero:RemoveModifierByName("modifier_warchasers_solo_buff")
    end

end
