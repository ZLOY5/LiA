modifier_item_lia_pure_light = class({})
modifier_item_lia_pure_light_protection = class({})

function modifier_item_lia_pure_light:IsHidden()
	return true 
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
		local health_percent_threshold = self:GetAbility():GetSpecialValueFor("health_percent_threshold")
		local totem_radius = self:GetAbility():GetSpecialValueFor("totem_radius")
		local buff_duration = self:GetAbility():GetSpecialValueFor("buff_duration")
		local totem_targets = self:GetAbility():GetSpecialValueFor("totem_targets")

		local pureLightPossibleTargets = FindUnitsInRadius(self:GetParent():GetTeamNumber(), 
																self:GetParent():GetAbsOrigin(), 
																nil, totem_radius, 
																DOTA_UNIT_TARGET_TEAM_FRIENDLY, 
																DOTA_UNIT_TARGET_HERO, 
																DOTA_UNIT_TARGET_FLAG_INVULNERABLE, 
																FIND_ANY_ORDER, 
																false)

		for _,v in pairs(pureLightPossibleTargets) do
			print(v:HasModifier("modifier_item_lia_pure_light_protection"))
			if v:GetHealthPercent() <= health_percent_threshold and not v:HasModifier("modifier_item_lia_pure_light_protection") and self:GetAbility():GetOwner().pureLightTargetCount < totem_targets  then
				print(v:GetUnitName())
				v:AddNewModifier(caster,self:GetAbility(),"modifier_item_lia_pure_light_protection",{duration = buff_duration})
				self:GetAbility():GetOwner().pureLightTargetCount = self:GetAbility():GetOwner().pureLightTargetCount + 1
			end

		end

	end

end




--------------------------------------------------------------------------------------------------------------------

function modifier_item_lia_pure_light_protection:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_INCOMING_DAMAGE_PERCENTAGE,
	}
 
	return funcs
end

function modifier_item_lia_pure_light_protection:IsPurgable()
	return false
end

function modifier_item_lia_pure_light_protection:OnCreated(kv)
	self:StartIntervalThink(0.1)
	if IsServer() then
		self:GetParent().pureLightParticleTeher = ParticleManager:CreateParticle("particles/puck_dreamcoil_tether_pure_light.vpcf",PATTACH_POINT_FOLLOW,self:GetParent())
		ParticleManager:SetParticleControlEnt(self:GetParent().pureLightParticleTeher, 0, self:GetAbility():GetOwner(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetAbility():GetOwner():GetAbsOrigin(), true) 
		ParticleManager:SetParticleControlEnt(self:GetParent().pureLightParticleTeher, 1, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
	end
end

function modifier_item_lia_pure_light_protection:OnIntervalThink()
	if IsServer() then
	--	if not self:GetParent():HasModifier("modifier_item_lia_pure_light_radius_check") then
		if not self:GetParent():FindModifierByNameAndCaster("modifier_item_lia_pure_light_radius_check", self:GetParent()) then
			self:GetParent():RemoveModifierByName("modifier_item_lia_pure_light_protection")
		end
		

	end

end

function modifier_item_lia_pure_light_protection:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self:GetParent().pureLightParticleTeher,false)
		self:GetAbility():GetOwner().pureLightTargetCount = self:GetAbility():GetOwner().pureLightTargetCount - 1
	end
end

function modifier_item_lia_pure_light_protection:GetModifierIncomingDamage_Percentage()
	local damagePerc = self:GetAbility():GetSpecialValueFor("totem_damage_reduction")

	return damagePerc
end