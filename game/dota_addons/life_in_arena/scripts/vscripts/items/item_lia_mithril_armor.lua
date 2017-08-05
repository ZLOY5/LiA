item_lia_mithril_armor = class({})
LinkLuaModifier("modifier_mithril_armor", "items/modifier_mithril_armor.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_mithril_armor_taunt", "items/modifier_mithril_armor_taunt.lua", LUA_MODIFIER_MOTION_NONE)


function item_lia_mithril_armor:GetIntrinsicModifierName()
	return "modifier_mithril_armor"
end

function item_lia_mithril_armor:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local duration_hero = duration/2

	local targets = FindUnitsInRadius(caster:GetTeamNumber(),
		caster:GetAbsOrigin(),
		nil,
		radius,
		DOTA_UNIT_TARGET_TEAM_ENEMY,
		DOTA_UNIT_TARGET_BASIC+DOTA_UNIT_TARGET_HERO,
		DOTA_DAMAGE_FLAG_NONE,
		FIND_ANY_ORDER,
		false
	)



	for _,unit in pairs(targets) do
		unit:Interrupt()
		unit:MoveToTargetToAttack(caster)

		local dur = ( unit:IsRealHero() or string.find(unit:GetUnitName(),"megaboss") ) and duration_hero or duration
		unit:AddNewModifier(caster,self,"modifier_mithril_armor_taunt",{duration = dur})
	end

	EmitSoundOn("Hero_Sven.Warcry",caster)

	local fx = ParticleManager:CreateParticle("particles/units/heroes/hero_sven/sven_spell_warcry.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
	ParticleManager:ReleaseParticleIndex(fx)
end 