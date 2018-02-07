witch_doctor_frost_armor = class ({})
LinkLuaModifier("modifier_witch_doctor_frost_armor_buff","heroes/WithcDoctor/modifier_witch_doctor_frost_armor_buff.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_witch_doctor_frost_armor_debuff","heroes/WithcDoctor/modifier_witch_doctor_frost_armor_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function witch_doctor_frost_armor:OnSpellStart()
	if IsServer() then
		if self:GetCaster():HasScepter() then
			self.duration = self:GetSpecialValueFor( "duration" )
		else
			self.duration = self:GetSpecialValueFor( "duration_scepter" )
		end
		
		local target = self:GetCursorTarget()
		
		

		target:AddNewModifier(self:GetCaster(), self, pszScriptName, hModifierTable)

		EmitSoundOn("Hero_Lich.FrostArmor", self:GetCaster())
	end
end
