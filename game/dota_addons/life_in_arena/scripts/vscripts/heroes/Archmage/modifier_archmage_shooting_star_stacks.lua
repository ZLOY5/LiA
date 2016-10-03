modifier_archmage_shooting_star_stacks = class({})

function modifier_archmage_shooting_star_stacks:DeclareFunctions()
    local funcs = { MODIFIER_PROPERTY_TOOLTIP, }

    return funcs
end

function modifier_archmage_shooting_star_stacks:IsPurgable()
	return false
end

function modifier_archmage_shooting_star_stacks:IsHidden()
--	if self:GetParent().shootingStarStackCount == 0 then
--		return true
--	end
	return false
end

function modifier_archmage_shooting_star_stacks:RemoveOnDeath()
	return false
end

function modifier_archmage_shooting_star_stacks:OnCreated()

	if self:GetParent().shootingStarStackCount ~= nil then
		self:SetStackCount(self:GetParent().shootingStarStackCount)
	end

	if not self:GetParent().shootingStarOverhead then
		self:GetParent().shootingStarOverhead = ParticleManager:CreateParticle( "particles/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	end
	--ParticleManager:SetParticleControl(self:GetParent().shootingStarOverhead, 1, Vector(1,0,0))
	--ParticleManager:ReleaseParticleIndex(self:GetParent().shootingStarOverhead)
	
end


function modifier_archmage_shooting_star_stacks:OnTooltip(params)
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage_per_charge") + self:GetAbility():GetSpecialValueFor("initial_damage")
end

