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

function CauseDamageDecor(event)
	local ability = event.ability
	local attacker = event.attacker
	--local target = event.target
	local targets = event.target_entities
	local attack_damage = event.attack_damage
	for _,v in pairs(targets) do
		if v.destructable == 1 then
			ApplyDamage({victim = v, attacker = attacker, damage = attack_damage, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability})
		end
	end

end

function CauseDamage(event)
	local ability = event.ability
	local target = event.target
	local attacker = event.attacker
	local attack_damage = event.attack_damage

	local halfDamage = attack_damage / 2
	local quarterDamage = attack_damage / 4

	local damageTable = {attacker = attacker, damage = attack_damage/2, damage_type = DAMAGE_TYPE_PHYSICAL, ability = ability}

	local targets = FindUnitsInRadius(attacker:GetTeamNumber(),
		target:GetAbsOrigin(),
		nil,
		250,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_BUILDING,
		DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES,
		FIND_ANY_ORDER,
		false)

	for _,v in pairs(targets) do
		damageTable.victim = v

		local range = v:GetRangeToUnit(target)

		if range <= 50 then
			damageTable.damage = attack_damage
		elseif range <= 150 then
			damageTable.damage = halfDamage
		else
			damageTable.damage = quarterDamage
		end

		ApplyDamage(damageTable)
	end

	

end