function ShowCenterMessage(msg, dur, wave)
	FireGameEvent("show_center_message",{message = msg,duration = dur}) 
	if wave then
		Timers:CreateTimer(0.01, function() FireGameEvent("show_center_message_fix",{wave = wave}) return nil end)
	end
end

function ResetAllAbilitiesCooldown(unit)
	local abilities = unit:GetAbilityCount()
	for i = 0, abilities-1 do
		local ability = unit:GetAbilityByIndex(i)
		if ability and not ability:IsCooldownReady() and ability:GetAbilityName() ~= "time_lord_wisdom_flow" then
			ability:EndCooldown()
		end
	end
	for i = 0, 8 do
		local item = unit:GetItemInSlot(i)
		if item and not item:IsCooldownReady() then
			item:EndCooldown()
		end
	end
end

function GetItemInInventory(unit,itemName)
	for i = 0, 5 do
		local item = unit:GetItemInSlot(i) 
		if item then
			if item:GetName() == itemName then
				return item 
			end
		end
	end
	return nil
end

POPUP_SYMBOL_PRE_PLUS = 0
POPUP_SYMBOL_PRE_MINUS = 1
POPUP_SYMBOL_PRE_SADFACE = 2
POPUP_SYMBOL_PRE_BROKENARROW = 3
POPUP_SYMBOL_PRE_SHADES = 4
POPUP_SYMBOL_PRE_MISS = 5
POPUP_SYMBOL_PRE_EVADE = 6
POPUP_SYMBOL_PRE_DENY = 7
POPUP_SYMBOL_PRE_ARROW = 8

POPUP_SYMBOL_POST_EXCLAMATION = 0
POPUP_SYMBOL_POST_POINTZERO = 1
POPUP_SYMBOL_POST_MEDAL = 2
POPUP_SYMBOL_POST_DROP = 3
POPUP_SYMBOL_POST_LIGHTNING = 4
POPUP_SYMBOL_POST_SKULL = 5
POPUP_SYMBOL_POST_EYE = 6
POPUP_SYMBOL_POST_SHIELD = 7
POPUP_SYMBOL_POST_POINTFIVE = 8

function PopupNumbers(player,target, pfx, color, lifetime, number, presymbol, postsymbol)
    local pfxPath = string.format("particles/msg_fx/msg_%s.vpcf", pfx)
    local pidx
    if player then
    	pidx = ParticleManager:CreateParticleForPlayer(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target, player)
    else
    	pidx = ParticleManager:CreateParticle(pfxPath, PATTACH_ABSORIGIN_FOLLOW, target) -- target:GetOwner()
    end
    local digits = 0
    if number ~= nil then
        digits = #tostring(number)
    end
    if presymbol ~= nil then
        digits = digits + 1
    end
    if postsymbol ~= nil then
        digits = digits + 1
    end

    ParticleManager:SetParticleControl(pidx, 1, Vector(tonumber(presymbol), tonumber(number), tonumber(postsymbol)))
    ParticleManager:SetParticleControl(pidx, 2, Vector(lifetime, digits, 0))
    ParticleManager:SetParticleControl(pidx, 3, color)
end


function SetCameraToPosForPlayer(playerID,vector)
	local camera_guy = CreateUnitByName("camera_guy", vector, false, nil, nil, DOTA_TEAM_GOODGUYS)
	Timers:CreateTimer(1,function() camera_guy:RemoveSelf() end)
	if playerID == -1 then --для всех игроков
		DoWithAllHeroes(function(hero)
			PlayerResource:SetCameraTarget(hero:GetPlayerID(),camera_guy)
		end)
		Timers:CreateTimer(0.1,function()
			DoWithAllHeroes(function(hero)
				PlayerResource:SetCameraTarget(hero:GetPlayerID(),nil)
			end)
		end)
	else --для одного игрока
		PlayerResource:SetCameraTarget(playerID,camera_guy)
		Timers:CreateTimer(0.1,function()
			PlayerResource:SetCameraTarget(playerID,nil)
		end)
	end

	
end

function DistanceBetweenPoints(v1,v2)
	return math.sqrt(math.pow(v2.x - v1.x,2) + math.pow(v2.y - v1.y,2) + math.pow(v2.z - v1.z,2))
end

function CleanUnitsOnMap()
	local units = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, Vector(0,0,0), nil, 9999, DOTA_UNIT_TARGET_TEAM_BOTH, DOTA_UNIT_TARGET_ALL, DOTA_UNIT_TARGET_FLAG_MAGIC_IMMUNE_ENEMIES+DOTA_UNIT_TARGET_FLAG_INVULNERABLE--[[+DOTA_UNIT_TARGET_FLAG_OUT_OF_WORLD]], FIND_ANY_ORDER, true)
    for _,unit in pairs(units) do
        if not unit:IsRealHero() and not unit.destructable then
        	--print(unit:GetUnitName())
        	unit.cleanerKilled = 1
            unit:ForceKill(true)
        end
    end
end

function PrintTable(title,table)
	print(title)
	for k,v in pairs(table) do
		print(k,v)
	end
	print("--------------------End of table--------------------------")
end


function IsValidAlive( unit )
	return (IsValidEntity(unit) and unit:IsAlive())
end

function TableFindKey( table, val )
    if table == nil then
        print( "nil" )
        return nil
    end

    for k, v in pairs( table ) do
        if v == val then
            return k
        end
    end
    return nil
end

function TableCount( t )
    local n = 0
    for _ in pairs( t ) do
        n = n + 1
    end
    return n
end

function getIndex(list, element)
    if list == nil then return false end
    for i=1,#list do
        if list[i] == element then
            return i
        end
    end
    return -1
end

function MergeTables( t1, t2 )
    for name,info in pairs(t2) do
        t1[name] = info
    end
end

function IsFlagSet(number,flag)
	return (number % (2*flag) >= flag)
end

function CreateIllusion(target,caster,origin,duration,outgoing_damage,incoming_damage)
	local player = caster:GetPlayerOwner()

	local illusion = CreateUnitByName(target:GetUnitName(), origin, true, caster, caster, caster:GetTeamNumber())
	
	illusion:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
	illusion:SetForwardVector(target:GetForwardVector())
	illusion:SetControllableByPlayer(player:GetPlayerID(), true)
	illusion:SetOwner(caster)
	
	if target:IsRealHero() then
		illusion:SetPlayerID(player:GetPlayerID())
		illusion:SetOwner(player)
		--local targetLevel = target:GetLevel()
		--for i=1,targetLevel-1 do
		--	illusion:HeroLevelUp(false)
		--end
		illusion:SetAbilityPoints(0)
	end

	
	for abilitySlot=0,15 do
		local ability = target:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			--print(abilityName,abilityLevel)
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end

	if target:HasInventory() then
		for itemSlot=0,5 do
			local item = target:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, illusion, illusion)
				illusion:AddItem(newItem)
			end
		end
	end

	if target:IsRealHero() then
		illusion:SetBaseAgility(target:GetBaseAgility())
		illusion:SetBaseIntellect(target:GetBaseIntellect())
		illusion:SetBaseStrength(target:GetBaseStrength())
		illusion:CalculateStatBonus(true)
	end

	if target:HasModifier("modifier_metamorphosis") then
		local meta_ability = illusion:FindAbilityByName("pirate_metamorphosis")
		meta_ability:ApplyDataDrivenModifier(illusion, illusion, "modifier_metamorphosis", nil)
	end

	if target:HasModifier("modifier_vampire_transformation") then
		local meta_ability = illusion:FindAbilityByName("vampire_transformation")
		meta_ability:ApplyDataDrivenModifier(illusion, illusion, "modifier_vampire_transformation", nil)
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, nil, "modifier_illusion", { duration = duration, outgoing_damage = outgoing_damage, incoming_damage = incoming_damage })
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	--
	ResolveNPCPositions(illusion:GetAbsOrigin(),65)

	return illusion
end

function CreateIllusion_CustomModifier(target,caster,origin,duration,outgoing_damage,incoming_damage,illusion_modifier)
	local player = caster:GetPlayerOwner()

	local illusion = CreateUnitByName(target:GetUnitName(), origin, true, caster, caster, caster:GetTeamNumber())
	
	illusion:AddNewModifier(caster, nil, "modifier_phased", { duration = 0.03 })
	illusion:SetForwardVector(target:GetForwardVector())
	illusion:SetControllableByPlayer(player:GetPlayerID(), true)
	illusion:SetOwner(caster)
	
	if target:IsRealHero() then
		illusion:SetPlayerID(player:GetPlayerID())
		illusion:SetOwner(player)
		--local targetLevel = target:GetLevel()
		--for i=1,targetLevel-1 do
		--	illusion:HeroLevelUp(false)
		--end
		illusion:SetAbilityPoints(0)
	end

	
	for abilitySlot=0,15 do
		local ability = target:GetAbilityByIndex(abilitySlot)
		if ability ~= nil then 
			local abilityLevel = ability:GetLevel()
			local abilityName = ability:GetAbilityName()
			--print(abilityName,abilityLevel)
			local illusionAbility = illusion:FindAbilityByName(abilityName)
			if illusionAbility then
				illusionAbility:SetLevel(abilityLevel)
			end
		end
	end

	if target:HasInventory() then
		for itemSlot=0,5 do
			local item = target:GetItemInSlot(itemSlot)
			if item ~= nil then
				local itemName = item:GetName()
				local newItem = CreateItem(itemName, illusion, illusion)
				illusion:AddItem(newItem)
			end
		end
	end

	if target:IsRealHero() then
		illusion:SetBaseAgility(target:GetBaseAgility())
		illusion:SetBaseIntellect(target:GetBaseIntellect())
		illusion:SetBaseStrength(target:GetBaseStrength())
		illusion:CalculateStatBonus(true)
	end

	if target:HasModifier("modifier_metamorphosis") then
		local meta_ability = illusion:FindAbilityByName("pirate_metamorphosis")
		meta_ability:ApplyDataDrivenModifier(illusion, illusion, "modifier_metamorphosis", nil)
	end

	if target:HasModifier("modifier_vampire_transformation") then
		local meta_ability = illusion:FindAbilityByName("vampire_transformation")
		meta_ability:ApplyDataDrivenModifier(illusion, illusion, "modifier_vampire_transformation", nil)
	end

	-- Set the unit as an illusion
	-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
	illusion:AddNewModifier(caster, nil, illusion_modifier, { duration = duration, outgoing_damage = outgoing_damage, incoming_damage = incoming_damage })
	-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
	illusion:MakeIllusion()
	--
	ResolveNPCPositions(illusion:GetAbsOrigin(),65)

	return illusion
end

--[[function CDOTA_Item:GetItemSlot()
	local caster = self:GetCaster()
	if not caster then 
		return nil 
	end

	for i=0,8 do
		if caster:GetItemInSlot(i) == self then
			return i
		end
	end
	return nil
end]]

function CDOTABaseAbility:ReduceCooldown(reduction)
	local cooldown = self:GetCooldownTimeRemaining()
	if cooldown > 0 then
		local newCooldown = cooldown - reduction
		self:EndCooldown()
		if newCooldown > 0 then
			self:StartCooldown(newCooldown)
		end
	end
end

function CDOTA_BaseNPC:FindModifierByNameAndAbility(modifierName,ability)
	for _,mod in pairs(self:FindAllModifiersByName(modifierName)) do
		if mod:GetAbility() == ability then
			return mod
		end
	end
	return nil
end

function CDOTA_BaseNPC:HasItemInInventory(itemName,bIncludeBackpack,hExcludeItem)
	local bIncludeBackpack = bIncludeBackpack or false
	local slots = bIncludeBackpack and 8 or 5

	for i = 0, slots do
		local item = self:GetItemInSlot(i)
		if item and item:GetAbilityName() == itemName and item ~= hExcludeItem then
			return true
		end
	end
	return false
end

function CreateToast(data)
	CustomGameEventManager:Send_ServerToAllClients("lia_create_toast", data)
end

function SendErrorMessage(playerID, message)
   CustomGameEventManager:Send_ServerToPlayer(PlayerResource:GetPlayer(playerID), "custom_error_message", {message=message}) 
end