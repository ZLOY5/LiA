time_lord_timelapse = class({})
LinkLuaModifier("modifier_time_lord_timelapse", "heroes/TimeLord/modifier_time_lord_timelapse.lua", LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_time_lord_timelapse_invul", "heroes/TimeLord/modifier_time_lord_timelapse_invul.lua", LUA_MODIFIER_MOTION_NONE)

function time_lord_timelapse:GetIntrinsicModifierName()
	return "modifier_time_lord_timelapse"
end

function time_lord_timelapse:GetCooldown(iLevel)
	if self:GetCaster():HasScepter() then
		return self:GetLevelSpecialValueFor( "cooldown_scepter" , iLevel)
	end

	return self.BaseClass.GetCooldown( self, iLevel ) 
end

function time_lord_timelapse:OnSpellStart()
	local caster = self:GetCaster()

	local damage = self:GetSpecialValueFor("damage")
	local damage_radius = self:GetSpecialValueFor("damage_radius")

	caster:AddNewModifier(caster,self,"modifier_time_lord_timelapse_invul",nil)

	local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
	for _,unit in pairs(targets) do 
		ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
	end

	ParticleManager:CreateParticle("particles/items_fx/blink_dagger_start.vpcf", PATTACH_ABSORIGIN, caster)

	caster:EmitSound("DOTA_Item.BlinkDagger.Activate")

	Timers:CreateTimer(0.1,
		function()
			if not caster:IsAlive() then
				return
			end

			if self.heroState ~= nil then
				FindClearSpaceForUnit_IgnoreNeverMove(caster, self.heroState[1][1], true)
				caster:SetHealth(self.heroState[1][2])
				--caster:SetMana(self.heroState[1][3])
			end

			local targets = FindUnitsInRadius(caster:GetTeam(), caster:GetAbsOrigin(), nil, damage_radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_ALL - DOTA_UNIT_TARGET_BUILDING, DOTA_UNIT_TARGET_FLAG_NONE, FIND_ANY_ORDER, false)
			for _,unit in pairs(targets) do 
				ApplyDamage({victim = unit, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = self})
			end

			ParticleManager:CreateParticle("particles/items_fx/blink_dagger_end.vpcf", PATTACH_ABSORIGIN, caster)
	
			caster:RemoveModifierByName("modifier_time_lord_timelapse_invul")
			
		end
	)

end

