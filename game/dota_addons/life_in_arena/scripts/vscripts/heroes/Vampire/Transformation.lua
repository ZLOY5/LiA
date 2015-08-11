LinkLuaModifier("modifier_vampire_transformation_regen", "heroes/Vampire/modifier_vampire_transformation_regen.lua", LUA_MODIFIER_MOTION_NONE)

--[[Author: Pizzalol/Noya
	Date: 10.01.2015.
	Swaps the ranged attack, projectile and caster model
]]
function ModelSwapStart( keys )
	local caster = keys.caster
	local model = keys.model
	local projectile_model = keys.projectile_model
	--
	caster:Stop()
	-- Saves the original model and attack capability
	if caster.caster_model == nil then 
		caster.caster_model = caster:GetModelName()
	end
	caster.caster_attack = caster:GetAttackCapability()

	-- Sets the new model and projectile
	caster:SetOriginalModel(model)
	caster:SetRangedProjectileName(projectile_model)

	-- Sets the new attack type
	caster:SetAttackCapability(DOTA_UNIT_CAP_RANGED_ATTACK)
end

--[[Author: Pizzalol/Noya
	Date: 10.01.2015.
	Reverts back to the original model and attack type
]]
function ModelSwapEnd( keys )
	local caster = keys.caster
	--
	caster:Stop()
	--
	caster:SetModel(caster.caster_model)
	caster:SetOriginalModel(caster.caster_model)
	caster:SetAttackCapability(caster.caster_attack)
end

--[[Author: Noya
	Date: 10.01.2015.
	Hides all dem hats
]]
function HideWearables( event )
	local hero = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	print("Hiding Wearables")
	--hero:AddNoDraw() -- Doesn't work on classname dota_item_wearable

	hero.wearableNames = {} -- In here we'll store the wearable names to revert the change
	hero.hiddenWearables = {} -- Keep every wearable handle in a table, as its way better to iterate than in the MovePeer system
    local model = hero:FirstMoveChild()
    while model ~= nil do
        if model:GetClassname() ~= "" and model:GetClassname() == "dota_item_wearable" then
            local modelName = model:GetModelName()
            if string.find(modelName, "invisiblebox") == nil and modelName ~= "" and modelName ~= nil then
            	-- Add the original model name to revert later
            	table.insert(hero.wearableNames,modelName)
            	print("Hidden "..modelName.."")

            	-- Set model invisible
            	model:SetModel("models/development/invisiblebox.vmdl")
            	table.insert(hero.hiddenWearables,model)
            end
        end
        model = model:NextMovePeer()
        if model ~= nil then
        	print("Next Peer:" .. model:GetModelName())
        end
    end
end

--[[Author: Noya
	Date: 10.01.2015.
	Shows the hidden hero wearables
]]
function ShowWearables( event )
	local hero = event.caster
	print("Showing Wearables on ".. hero:GetModelName())

	-- Iterate on both tables to set each item back to their original modelName
	for i,v in ipairs(hero.hiddenWearables) do
		--for index,modelName in ipairs(hero.wearableNames) do
		--	if i==index then
				print("Changed "..v:GetModelName().. " back to "..hero.wearableNames[i])
				v:SetModel(hero.wearableNames[i])
		--	end
		--end
	end
end

function DamageAndHeal(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local targets = event.target_entities
	local attack_damage = event.attack_damage
	local tp_aoe_dmg_mult = ability:GetLevelSpecialValueFor("tp_aoe_dmg_mult", ability:GetLevel() - 1)
	local aoe_dmg = tp_aoe_dmg_mult*(caster.thirst_points or 0)
	local tp_attack_heal_mult = ability:GetLevelSpecialValueFor("tp_attack_heal_mult", ability:GetLevel() - 1)
	local heal = tp_attack_heal_mult*(caster.thirst_points or 0)

	for _,v in pairs(targets) do
		ApplyDamage({ victim = v, attacker = caster, damage = aoe_dmg, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability })
	end
	caster:Heal(heal, caster)
end

function InitialDamage(event)
	local ability = event.ability
	local caster = event.caster
	local target = event.target
	local targets = event.target_entities
	local tp_mult_init_dmg = ability:GetLevelSpecialValueFor("tp_transformation_dmg_mult", ability:GetLevel() - 1)
	local init_dmg = tp_mult_init_dmg*(caster.thirst_points or 0)
	local modifier = caster:FindModifierByName("modifier_vampire_lifesteal")
	local duration = ability:GetSpecialValueFor("duration")

	if caster.thirst_points then
		caster.thirst_points = 0
		modifier:SetStackCount(0)
	end
	
	for _,v in pairs(targets) do
		ApplyDamage({ victim = v, attacker = caster, damage = init_dmg, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
	end
	
	caster:AddNewModifier(caster, ability, "modifier_vampire_transformation_regen", {duration = duration})
end
