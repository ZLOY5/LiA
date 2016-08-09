modifier_item_lia_pure_light = class({})


function modifier_item_lia_pure_light:IsHidden()
	return false
end

function modifier_item_lia_pure_light:IsPurgable()
	return false
end

function modifier_item_lia_pure_light:OnCreated(kv)
	self:StartIntervalThink(0.1)

	if IsServer() then
		self:GetParent().pureLightParticle = ParticleManager:CreateParticle("particles/puck_dreamcoil_pure_light.vpcf",PATTACH_ABSORIGIN_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt( self:GetParent().pureLightParticle, 1, self:GetParent(), PATTACH_ABSORIGIN, nil, self:GetParent():GetAbsOrigin(), true )

		self:GetAbility():GetOwner().pureLightTargetCount = 0
	end

	

end

function modifier_item_lia_pure_light:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self:GetParent().pureLightParticle,false)
	end
end

function modifier_item_lia_pure_light:OnIntervalThink()
	if IsServer() then
		local ability = self:GetAbility()
		local caster = self:GetParent()

		local health_percent_threshold = ability:GetSpecialValueFor("health_percent_threshold")
		local totem_radius = ability:GetSpecialValueFor("totem_radius")
		local buff_duration = ability:GetSpecialValueFor("buff_duration")
		local totem_targets = ability:GetSpecialValueFor("totem_targets")
		

		local pureLightPossibleTargets = FindUnitsInRadius(caster:GetTeamNumber(), 
																caster:GetAbsOrigin(), 
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
				local modifier = v:FindModifierByName("modifier_item_lia_pure_light_protection")
				if modifier then
					if modifier:GetCaster() == caster then
						v:AddNewModifier(caster,ability,"modifier_item_lia_pure_light_protection",nil):SetDuration(0.15, false)
						nTargets = nTargets + 1
					end
				else

					v:AddNewModifier(caster,ability,"modifier_item_lia_pure_light_protection",nil):SetDuration(0.15, false)
					nTargets = nTargets + 1
				end	
			end
		end 
	end

end




--------------------------------------------------------------------------------------------------------------------

modifier_item_lia_pure_light_protection = class({})

function modifier_item_lia_pure_light_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
 
	return funcs
end

function modifier_item_lia_pure_light_protection:IsPurgable()
	return false
end

function modifier_item_lia_pure_light_protection:IsHidden()
	return false
end

function modifier_item_lia_pure_light_protection:OnCreated(kv)
	if IsServer() then
		self:GetParent().pureLightParticleTeher = ParticleManager:CreateParticle("particles/puck_dreamcoil_tether_pure_light.vpcf",PATTACH_POINT_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(self:GetParent().pureLightParticleTeher, 0, self:GetAbility():GetOwner(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetAbility():GetOwner():GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(self:GetParent().pureLightParticleTeher, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	end
	self.damagePerc = self:GetAbility():GetSpecialValueFor("totem_damage_reduction")
end



function modifier_item_lia_pure_light_protection:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self:GetParent().pureLightParticleTeher,false)
	end
end

function modifier_item_lia_pure_light_protection:GetModifierIncomingDamage_Percentage()
	return self.damagePerc
end