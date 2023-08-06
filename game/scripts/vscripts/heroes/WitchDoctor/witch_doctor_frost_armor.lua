witch_doctor_frost_armor = class ({})
LinkLuaModifier("modifier_witch_doctor_frost_armor_buff","heroes/WitchDoctor/modifier_witch_doctor_frost_armor_buff.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_witch_doctor_frost_armor_debuff","heroes/WitchDoctor/modifier_witch_doctor_frost_armor_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function witch_doctor_frost_armor:GetManaCost(iLevel)
	--print("Level",iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end


function witch_doctor_frost_armor:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasScepter() then
			self.duration = self:GetSpecialValueFor( "duration_scepter" )
		else
			self.duration = self:GetSpecialValueFor( "duration" )
		end
		
		local target = self:GetCursorTarget()
		
		

		target:AddNewModifier(self:GetCaster(), self, "modifier_witch_doctor_frost_armor_buff", {duration = self.duration})

		EmitSoundOn("Hero_Lich.FrostArmor", self:GetCaster())
	end
end

function witch_doctor_frost_armor:OnUpgrade()
	self:SetContextThink("Autocast", Dynamic_Wrap(self, "AutocastThink"), 1)	
end

function witch_doctor_frost_armor:AutocastThink()
	if self:GetAutoCastState() and self:IsFullyCastable() then
		local caster = self:GetCaster()
		local target
		if not self:GetCaster():HasModifier("modifier_witch_doctor_frost_armor_buff") then
			target = caster
		else
			local units = FindUnitsInRadius(caster:GetTeamNumber(), caster:GetAbsOrigin(), nil, self:GetCastRange(caster:GetAbsOrigin(),nil), DOTA_UNIT_TARGET_TEAM_FRIENDLY, DOTA_UNIT_TARGET_HERO, DOTA_UNIT_TARGET_FLAG_NOT_ILLUSIONS, FIND_ANY_ORDER, false )
			for _,unit in pairs(units) do
				if not unit:HasModifier("modifier_witch_doctor_frost_armor_buff") then
					target = unit
					break
				end
			end
		end
		if target then
			local orderTable = { 
				UnitIndex = caster:entindex(), 
 				OrderType = DOTA_UNIT_ORDER_CAST_TARGET,
 		 		TargetIndex = target:entindex(), 
 				AbilityIndex = self:entindex(), 
 				Queue = 1 
			}
			ExecuteOrderFromTable(orderTable)
		end	
	end
	return 1
end
