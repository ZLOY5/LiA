lord_of_lightning_lightning_shield = class({})
LinkLuaModifier("modifier_lord_of_lightning_lightning_shield", "heroes/LightningLord/modifier_lord_of_lightning_lightning_shield.lua", LUA_MODIFIER_MOTION_NONE)

function lord_of_lightning_lightning_shield:GetManaCost(iLevel)
	--print("Level",iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "manacost_scepter" , iLevel)
	end

	return self.BaseClass.GetManaCost( self, iLevel ) 
end

function lord_of_lightning_lightning_shield:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()
	
	local duration = self:GetSpecialValueFor("duration")

	if target:GetTeamNumber() ~= caster:GetTeamNumber() and target:TriggerSpellAbsorb(self) then
		return 
	end

	target:EmitSound("Hero_Zuus.StaticField")

	local particle = ParticleManager:CreateParticle("particles/units/heroes/hero_zuus/zuus_thundergods_wrath_start_bolt_parent.vpcf", PATTACH_ABSORIGIN_FOLLOW, target)
	ParticleManager:SetParticleControl(particle, 1, target:GetAbsOrigin())
	
	target:AddNewModifier(caster, self, "modifier_lord_of_lightning_lightning_shield", {duration = duration})
end