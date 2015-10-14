function LinkDamage( event )
	local attacker = event.attacker
	local target = event.unit
	local damage = event.Damage
	local ability = event.ability
	local factor = ability:GetSpecialValueFor('distribution_factor') 

	if IsValidAlive(target) then
		target:Heal(damage * factor, attacker)
	end

	local j = TableFindKey(event.caster.linked, target:GetEntityIndex())
	local k = TableCount(event.caster.linked)

	-- DeepPrintTable(event.caster.linked)
	if not j then j = -1 end
	-- print('=======================')
	-- print('Damage on main target: ' .. damage * factor)
	-- print('Index of main target: ' .. j)
	-- print('Table general count: ' .. k)
	-- print('=======================')
	if k-1 > 0 then
		local dist_damage = (damage * factor) / (k-1)
		for i=1,k do
			if i ~= j then
				if event.caster.linked[i] then
					local linked = EntIndexToHScript(event.caster.linked[i])
					if IsValidAlive(linked) then
						local new_health = linked:GetHealth() - dist_damage
						if new_health < 1 then
							new_health = 1
							linked:RemoveModifierByName('modifier_spirit_link')
						end
						linked:SetHealth(new_health)
						-- print('=======================')
						-- print('Damage on linked unit: ' .. dist_damage)
						-- print('Index of linked unit: ' .. i)
						-- print('=======================')
					end
				end
			end
		end
	end
end

function LinkStart( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local radius = ability:GetSpecialValueFor('radius')

	local units = 1
	local max = ability:GetSpecialValueFor('max_unit')
	local allies = FindUnitsInRadius(caster:GetTeamNumber(), target:GetAbsOrigin(), nil, radius, DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_BASIC + DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NONE, FIND_CLOSEST, false)
	if caster.linked == nil then
		caster.linked = {}
	end
	ability:ApplyDataDrivenModifier(caster, target, 'modifier_spirit_link', {})
	local anyunit = false
	while units < max do
		for k,ally in pairs(allies) do
			if units < max and (not ally:FindModifierByName('modifier_spirit_link') or anyunit or ally ~= caster) then
				ability:ApplyDataDrivenModifier(caster, ally, 'modifier_spirit_link', {})
				units = units + 1
			end
		end
		anyunit = true
	end
end

function AddLinkedUnit( event )
	local unit = event.target
	table.insert(event.caster.linked, unit:GetEntityIndex())
end

function RemoveLinkedUnit( event )
	local unit = event.target
	if IsValidEntity(unit) then
		-- print('=======================')
		local i = getIndex(event.caster.linked, unit:GetEntityIndex())
		if i ~= -1 then
			table.remove(event.caster.linked, i)
			-- print('Unit removed from table')
		else
			-- print("Invalid index")
		end
		-- print('=======================')
	end
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