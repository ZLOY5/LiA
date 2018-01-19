witch_doctor_frost_armor = class ({})
LinkLuaModifier("modifier_witch_doctor_frost_armor_buff","heroes/WithcDoctor/modifier_witch_doctor_frost_armor_buff.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_witch_doctor_frost_armor_debuff","heroes/WithcDoctor/modifier_witch_doctor_frost_armor_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function witch_doctor_frost_armor:OnSpellStart()
	if IsServer() then
		local duration = self:GetSpecialValueFor( "duration" )
		local target = self:GetCursorTarget()
		
		if self:GetCaster():HasScepter() then
			duration = self:GetSpecialValueFor( "duration_scepter" )
		end

		target:AddNewModifier(self:GetCaster(), self, pszScriptName, hModifierTable)

		EmitSoundOn("Hero_Lich.FrostArmor", self:GetCaster())
	end
end
