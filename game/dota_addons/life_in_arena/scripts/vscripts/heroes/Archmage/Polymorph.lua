function Polymorph(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	local anomaly_radius = ability:GetSpecialValueFor("anomaly_radius")
	if target:TriggerSpellAbsorb(ability) then
		return 
	end

	if target:HasModifier("modifier_archmage_anomaly") then

		local searchForDummies = FindUnitsInRadius(caster:GetTeamNumber(), 
													target:GetAbsOrigin(), 
													nil, anomaly_radius, 
													DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
													DOTA_UNIT_TARGET_ALL, 
													DOTA_UNIT_TARGET_FLAG_INVULNERABLE + DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD, 
													FIND_ANY_ORDER, 
													false)


		for _,v in pairs(searchForDummies) do
			if v:GetUnitName() == "dummy_unit_anomaly" and v:GetOwner() == caster then
				local polymorphTargets = FindUnitsInRadius(caster:GetTeam(), 
																v:GetAbsOrigin(), 
																nil, anomaly_radius, 
																DOTA_UNIT_TARGET_TEAM_ENEMY, 
																DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, 
																0, 
																FIND_ANY_ORDER, 
																false)

				

				for k,t in pairs(polymorphTargets) do
					ParticleManager:CreateParticle("particles/lion_spell_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, t)
					if target:IsHero() then
						t:AddNewModifier(caster,ability,"modifier_archmage_polymorph_lua",{duration = ability:GetSpecialValueFor("hero_duration")})
					else
						t:AddNewModifier(caster,ability,"modifier_archmage_polymorph_lua",{duration = ability:GetSpecialValueFor("duration")})
					end
				end



			end 
			
		end

	else
		ParticleManager:CreateParticle("particles/lion_spell_voodoo.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
		if target:IsHero() then
			target:AddNewModifier(caster,ability,"modifier_archmage_polymorph_lua",{duration = ability:GetSpecialValueFor("hero_duration")})
		else
			target:AddNewModifier(caster,ability,"modifier_archmage_polymorph_lua",{duration = ability:GetSpecialValueFor("duration")})
		end
	end
	target:EmitSound("Hero_ShadowShaman.SheepHex.Target")
end

--[[Author: Pizzalol
	Date: 18.01.2015.
	Checks if the target is an illusion, if true then it kills it
	otherwise the target model gets swapped into a frog]]
function voodoo_start( keys )
	local target = keys.target
	local model = keys.model

	if target:IsIllusion() then
		target:ForceKill(true)
	else
		if target.target_model == nil then
			target.target_model = target:GetModelName()
		end

		target:SetOriginalModel(model)
	end
end

--[[Author: Pizzalol
	Date: 18.01.2015.
	Reverts the target model back to what it was]]
function voodoo_end( keys )
	local target = keys.target

	-- Checking for errors
	if target.target_model ~= nil then
		target:SetModel(target.target_model)
		target:SetOriginalModel(target.target_model)
	end
end

--[[Author: Noya
	Date: 10.01.2015.
	Hides all dem hats
]]
function HideWearables( event )
	local hero = event.target

	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	--print("Hiding Wearables")
	--hero:AddNoDraw() -- Doesn't work on classname dota_item_wearable

	hero.wearableNames = {} -- In here we'll store the wearable names to revert the change
	hero.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system

	-- Handle faulty models (might be more!)
	if hero:GetModelName() == "models/heroes/lina/lina.vmdl" then
		print("lina.vmdl is potato")
		DeepPrintTable(hero:GetChildren())
		return
	end

    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            local modelName = model:GetModelName()
            if string.find(modelName, "invisiblebox") == nil then
            	-- Add the original model name to revert later
            	table.insert(hero.wearableNames,modelName)
            	--print("Hidden "..modelName.."")

            	-- Set model invisible
            	model:SetModel("models/development/invisiblebox.vmdl")
            	table.insert(hero.hiddenWearables,model)
            end
        end
        model = model:NextMovePeer()
        if model ~= nil and model:GetClassname() == "dota_item_wearable" then
        	--print("Next Peer:" .. model:GetModelName())
        end
    end
end

--[[Author: Noya
	Date: 10.01.2015.
	Shows the hidden hero wearables
]]
function ShowWearables( event )
	local hero = event.target
	--print("Showing Wearables on ".. hero:GetModelName())

	if hero.hiddenWearables then
		-- Iterate on both tables to set each item back to their original modelName
		for i,v in ipairs(hero.hiddenWearables) do
			for index,modelName in ipairs(hero.wearableNames) do
				if i==index then
					--print("Changed "..v:GetModelName().. " back to "..modelName)
					v:SetModel(modelName)
				end
			end
		end
	end
end

function PolymorphLevelCheck( event )
	local target = event.target
	local hero = event.caster:GetPlayerOwner():GetAssignedHero()
	local pID = hero:GetPlayerID()
	
	if target:GetLevel() > 5 then
		event.caster:Interrupt()
		SendErrorMessage(pID, "#error_cant_target_level6")
	end
end