item_lia_armor_of_the_red_mist = class({})
LinkLuaModifier("modifier_armor_of_the_red_mist", "items/modifier_armor_of_the_red_mist.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_armor_of_the_red_mist_taunt", "items/modifier_armor_of_the_red_mist_taunt.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_armor_of_the_red_mist_buff", "items/modifier_armor_of_the_red_mist_buff.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_armor_of_the_red_mist:GetIntrinsicModifierName()
	return "modifier_armor_of_the_red_mist"
end

function item_lia_armor_of_the_red_mist:OnSpellStart()
	local caster = self:GetCaster()
	local radius = self:GetSpecialValueFor("radius")
	local duration = self:GetSpecialValueFor("duration")
	local duration_hero = duration/2

	caster:AddNewModifier(caster,self,"modifier_armor_of_the_red_mist_buff",{duration = duration})
	
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

	local damage_table = { 
		attacker = caster, 
		damage = self:GetSpecialValueFor("damage"),
		damage_type = DAMAGE_TYPE_MAGICAL,
		ability = self
	}

	for _,unit in pairs(targets) do
		unit:Interrupt()
		unit:MoveToTargetToAttack(caster)

		local dur = ( unit:IsRealHero() or string.find(unit:GetUnitName(),"megaboss") ) and duration_hero or duration
		unit:AddNewModifier(caster,self,"modifier_armor_of_the_red_mist_taunt",{duration = dur})

		damage_table.victim = unit
		ApplyDamage(damage_table)
	end

	EmitSoundOn("Hero_Sven.WarCry.Signet",caster)

	local fx = ParticleManager:CreateParticle("particles/econ/items/axe/axe_helm_shoutmask/axe_beserkers_call_owner_shoutmask.vpcf",PATTACH_ABSORIGIN_FOLLOW,caster)
	ParticleManager:SetParticleControl(fx, 2, Vector(radius,radius,0))
	ParticleManager:ReleaseParticleIndex(fx)
end 