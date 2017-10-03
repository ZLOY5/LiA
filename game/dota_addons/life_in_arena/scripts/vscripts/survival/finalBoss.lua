function Survival:FinalBoss_StartSecondStage()
    self.FinalBossStage2 = true

    Survival:_HideFinalBoss()
        
    self.nDeathCounter_SecondStage = 0
    local counter = 1
    Timers:CreateTimer(2,function()
        if counter <= 10 then
            local unit = CreateUnitByName("orn_mutant_boss", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
            ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, unit)
            unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
            unit.FinalBoss_secondStage = 1
            counter = counter + 1
            return 2
        else
            return nil
        end
    end)
end

function Survival:FinalBoss_StartFirstStage()
    self.FinalBossStage1 = true

    Survival:_HideFinalBoss() 

    self.nDeathCounter_FirstStage = 0
    local counter = 5
    Timers:CreateTimer(2,function()
        if counter <= 19 then
            local unit
            if counter % 5 == 0 then
                unit = CreateUnitByName(tostring(counter).."_wave_megaboss", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
            else
                if self.IsExtreme then
                    unit = CreateUnitByName(tostring(counter).."_wave_boss_extreme", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
                else    
                    unit = CreateUnitByName(tostring(counter).."_wave_boss", ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), true, nil, nil, DOTA_TEAM_NEUTRALS)
                end
            end
            print("Spawned Boss",counter,unit:GetUnitName())    
            unit.FinalBoss_firstStage = 1
            ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, unit)
            unit:EmitSound("DOTA_Item.BlinkDagger.Activate")
            counter = counter + 1
            return 2
        else
            return nil
        end
    end)
end

function Survival:OnOrnDamaged(event) 
    if event.unit:GetHealthPercent() <= 30 and not self.FinalBossStage2 and self.FinalBossStage1 then --зомби
        Survival:FinalBoss_StartSecondStage()
    elseif event.unit:GetHealthPercent() <= 70 and not self.FinalBossStage1 then --на арену выходят все предыдущие боссы
        Survival:FinalBoss_StartFirstStage()
    end
end

function Survival:_OnFinalBossDeath(event)
    local killed = EntIndexToHScript(event.entindex_killed)

    if killed == self.hFinalBoss then
        Survival:EndGame(DOTA_TEAM_GOODGUYS)
    elseif killed.FinalBoss_firstStage and not killed.giveNoRatingPoints then
        self.nDeathCounter_FirstStage = self.nDeathCounter_FirstStage + 1
        
        if self.nDeathCounter_FirstStage == 15 then
            Survival:_UnhideFinalBoss()  
        end
    elseif killed.FinalBoss_secondStage then
        self.nDeathCounter_SecondStage = self.nDeathCounter_SecondStage + 1
        
        if self.nDeathCounter_SecondStage == 10 then
            Survival:_UnhideFinalBoss()
        end
    end
end

function Survival:_UnhideFinalBoss()
    self.hFinalBoss:RemoveModifierByName("modifier_hide_lua") 
    self.hFinalBoss:RemoveNoDraw()
    FindClearSpaceForUnit(self.hFinalBoss, ARENA_CENTER_COORD + RandomVector(RandomInt(-800, 800)), false)
    
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, self.hFinalBoss)
    self.hFinalBoss:EmitSound("DOTA_Item.BlinkDagger.Activate")   
end

function Survival:_HideFinalBoss()
    ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, self.hFinalBoss)
    self.hFinalBoss:EmitSound("DOTA_Item.BlinkDagger.Activate")
    
    self.hFinalBoss:AddNewModifier(self.hFinalBoss, nil, "modifier_hide_lua", {duration = -1})
    self.hFinalBoss:AddNoDraw()
    self.hFinalBoss:SetAbsOrigin(Vector(0,0,0)) 
end