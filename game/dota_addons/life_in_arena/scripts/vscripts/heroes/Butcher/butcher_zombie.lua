butcher_zombie = class ({})
LinkLuaModifier("modifier_butcher_zombie", "heroes/Butcher/modifier_butcher_zombie.lua" ,LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_butcher_zombie_bonus_stats", "heroes/Butcher/modifier_butcher_zombie_bonus_stats.lua" ,LUA_MODIFIER_MOTION_NONE)

function butcher_zombie:GetIntrinsicModifierName() 
	return "modifier_butcher_zombie"
end

function butcher_zombie:CastFilterResultTarget( hTarget )
	if IsServer() then 
		local modifier_stacks = self:GetCaster():FindModifierByName("modifier_butcher_zombie"):GetStackCount()
		if modifier_stacks == 0 then
			return UF_FAIL_CUSTOM
		end
	end

	return UnitFilter(hTarget,DOTA_UNIT_TARGET_TEAM_BOTH,DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_BASIC,DOTA_UNIT_TARGET_FLAG_NONE,self:GetCaster():GetTeamNumber())

end

function butcher_zombie:GetCustomCastErrorTarget( hTarget )
	if IsServer() then 
		local modifier_stacks = self:GetCaster():FindModifierByName("modifier_butcher_zombie"):GetStackCount()
		if modifier_stacks == 0 then
			return "#lia_hud_error_butcher_zombie"
		end
	end
end

function butcher_zombie:CastFilterResultLocation( vLocation )
	if IsServer() then 
		local modifier_stacks = self:GetCaster():FindModifierByName("modifier_butcher_zombie"):GetStackCount()
		if modifier_stacks == 0 then
			return UF_FAIL_CUSTOM
		end
	end

	return UF_SUCCESS

end

function butcher_zombie:GetCustomCastErrorLocation( vLocation )
	if IsServer() then 
		local modifier_stacks = self:GetCaster():FindModifierByName("modifier_butcher_zombie"):GetStackCount()
		if modifier_stacks == 0 then
			return "#lia_hud_error_butcher_zombie"
		end
	end
end

function butcher_zombie:OnSpellStart()
	if IsServer() then
		self.zombie_butcher_bonus_health = self:GetSpecialValueFor( "zombie_base_health" ) + self:GetCaster():GetMaxHealth() * self:GetSpecialValueFor( "zombie_butcher_heath_percent" ) * 0.01
		self.zombie_butcher_bonus_damage_min = self:GetCaster():GetBaseDamageMin() * self:GetSpecialValueFor( "zombie_butcher_damage_percent" ) * 0.01
		self.zombie_butcher_bonus_damage_max = self:GetCaster():GetBaseDamageMax() * self:GetSpecialValueFor( "zombie_butcher_damage_percent" ) * 0.01
		self.circle_radius = self:GetSpecialValueFor( "circle_radius" )

		local vPos = nil
		if self:GetCaster():IsAlive() then
			if self:GetCursorTarget() then
				vPos = self:GetCursorTarget():GetOrigin()
			else
				vPos = self:GetCursorPosition()
			end
		else
			vPos = self:GetCaster():GetAbsOrigin()
		end

		local caster = self:GetCaster()
		local level = self:GetLevel()
		local unit_name = {"butcher_zombie_1","butcher_zombie_2","butcher_zombie_3"}
		local butcher_return_level = caster:FindAbilityByName("butcher_skin"):GetLevel()
		local modifier = self:GetCaster():FindModifierByName("modifier_butcher_zombie")
		local modifier_stacks = self:GetCaster():FindModifierByName("modifier_butcher_zombie"):GetStackCount()

		if modifier_stacks ~= 0 then
			for i=1,modifier_stacks do
				local position = self:GetPositionOnCircle(vPos,Vector(1,0,0),self.circle_radius,i,modifier_stacks)
				zombie = CreateUnitByName(unit_name[level], position, false, caster, caster, caster:GetTeam())
				zombie:SetControllableByPlayer(caster:GetPlayerID(), false)
				zombie:FindAbilityByName("butcher_skin"):SetLevel(butcher_return_level)
				zombie:AddNewModifier(self:GetCaster(), self, "modifier_butcher_zombie_bonus_stats", nil)		

				ResolveNPCPositions(zombie:GetAbsOrigin(),65)

				local nFXIndex = ParticleManager:CreateParticle( "particles/units/heroes/hero_undying/undying_zombie_spawn.vpcf", PATTACH_CUSTOMORIGIN, zombie )
				ParticleManager:SetParticleControl( nFXIndex, 0, zombie:GetAbsOrigin() )
				ParticleManager:ReleaseParticleIndex( nFXIndex )
			end
			self:GetCaster():FindModifierByName("modifier_butcher_zombie"):SetStackCount(0)
		end

		EmitSoundOn("Hero_Undying.Tombstone", self:GetCaster())
	end
end

function butcher_zombie:GetPositionOnCircle(vCenter,vForward,flRadius,nPosition,nPositionCount)
	 local angle = nPosition / nPositionCount * 360
	 local QAngle = VectorToAngles(vForward)
	 QAngle.y = QAngle.y + angle
	 return RotatePosition(vCenter, QAngle, vCenter+vForward*flRadius)
end
