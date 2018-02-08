witch_doctor_frost_armor = class ({})
LinkLuaModifier("modifier_witch_doctor_frost_armor_buff","heroes/WitchDoctor/modifier_witch_doctor_frost_armor_buff.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_witch_doctor_frost_armor_debuff","heroes/WitchDoctor/modifier_witch_doctor_frost_armor_debuff.lua",LUA_MODIFIER_MOTION_NONE)

function witch_doctor_frost_armor:GetManaCost(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetSpecialValueFor( "manacost_scepter" )
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
