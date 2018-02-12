vowen_from_blood_spiritual_flame = class({})
LinkLuaModifier("modifier_vowen_from_blood_spiritual_flame","heroes/VowenFromBlood/modifier_vowen_from_blood_spiritual_flame.lua",LUA_MODIFIER_MOTION_NONE)

function vowen_from_blood_spiritual_flame:GetManaCost( iLevel )
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel )  
end

function vowen_from_blood_spiritual_flame:OnSpellStart()
	self:GetCursorTarget():AddNewModifier(self:GetCaster(),self,"modifier_vowen_from_blood_spiritual_flame",{duration = self:GetSpecialValueFor("duration")})
	EmitSoundOn("Hero_EmberSpirit.FireRemnant.Activate",self:GetCursorTarget())
end