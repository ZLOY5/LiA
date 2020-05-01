if IsClient() then
	_G.abilityKV = LoadKeyValues("scripts/npc/npc_abilities_override.txt")
	--DeepPrintTable(abilityKV["witch_doctor_frost_armor"])

	_G.abilitySpecialValues = {}

	function ParseSpecialString(string)
		local result = {}
		for s in string.gmatch(string, "[+-]?%d+%.?%d*") do
			table.insert(result, tonumber(s))
		end
		return result
	end

	function ParseSpecialValues(abiName)
		local specialKV = abilityKV[abiName].AbilitySpecial
		local specialValues = {}

		if specialKV then
			for k,v in pairs(specialKV) do
				for kk,vv in pairs(v) do
					if kk ~= "var_type" then
						if type(vv) == "number" then
							specialValues[kk] = vv
						else
							specialValues[kk] = ParseSpecialString(vv)
						end
					end
				end
			end
			return specialValues
		else
			return
		end
	end

	function C_DOTABaseAbility:GetLevelSpecialValueFor(szName,nLevel)
		local abiName = self:GetName()
		if nLevel == -1 then
			return self:GetSpecialValueFor(szName)
		else
			nLevel = nLevel + 1

			local abilitySpecial = _G.abilitySpecialValues[abiName]
			if not abilitySpecial then
				abilitySpecial = ParseSpecialValues(abiName)
				if not abilitySpecial then
					return
				end
				_G.abilitySpecialValues[abiName] = abilitySpecial
			end
			local value = abilitySpecial[szName]
			if type(value) == "table" then
				while true do
					if value[nLevel] then
						return value[nLevel]
					end
					nLevel = nLevel - 1
					if nLevel <= 0 then
						return 
					end

				end
			else
				return value
			end

		end
	end

	--DeepPrintTable(ParseSpecialValues("witch_doctor_frost_armor"))


end