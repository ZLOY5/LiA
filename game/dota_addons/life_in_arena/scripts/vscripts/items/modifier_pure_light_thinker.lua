modifier_pure_light_thinker = class({})


function modifier_pure_light_thinker:IsHidden()
	return true
end

function modifier_pure_light_thinker:IsPurgable()
	return false
end

function modifier_pure_light_thinker:GetEffectName()
	return "particles/templar_assassin_trap_rings_butterfly.vpcf"
end

function modifier_pure_light_thinker:GetEffectAttachType()
	return PATTACH_ABSORIGIN
end

if IsServer() then

	function modifier_pure_light_thinker:OnCreated(kv)
		self:StartIntervalThink(0.1)

		self.pureLightParticle = ParticleManager:CreateParticle("particles/puck_dreamcoil_pure_light.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt( self.pureLightParticle, 1, self:GetParent(), PATTACH_ABSORIGIN, nil, self:GetParent():GetAbsOrigin(), true )

		self.pureLightTargetCount = 0
		
	end

	function modifier_pure_light_thinker:OnDestroy()
		ParticleManager:DestroyParticle(self.pureLightParticle,false)
	end


	function modifier_pure_light_thinker:OnIntervalThink()
		local ability = self:GetAbility()
		local parent =  self:GetParent()
		local caster = self:GetCaster()

		local totem_radius = ability:GetSpecialValueFor("totem_radius")
		local totem_targets = ability:GetSpecialValueFor("totem_targets")
		

		local pureLightPossibleTargets = FindUnitsInRadius(parent:GetTeamNumber(), 
																parent:GetAbsOrigin(), 
																nil, totem_radius, 
																DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
																DOTA_UNIT_TARGET_HERO, 
																DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
																FIND_ANY_ORDER, 
																false)

		table.sort(pureLightPossibleTargets,function(a,b) 
			if a:GetHealth() == b:GetHealth() then
				return a:GetEntityIndex() < b:GetEntityIndex() --super stabil'nost'
			end


			return a:GetHealth() < b:GetHealth() end) 

		local nTargets = 0

		for _,v in pairs(pureLightPossibleTargets) do
			if nTargets < totem_targets then
				local modifier = v:FindModifierByName("modifier_pure_light_protection")
				if modifier then
					if modifier:GetCaster() == caster then
						v:AddNewModifier(caster,ability,"modifier_pure_light_protection", {thinker = parent:entindex()} ):SetDuration(0.15, false)
						nTargets = nTargets + 1
					end
				else

					v:AddNewModifier(caster,ability,"modifier_pure_light_protection", {thinker = parent:entindex()} ):SetDuration(0.15, false)
					nTargets = nTargets + 1
				end	
			end
		end 

	end

end