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
	return true
end

function modifier_archmage_shooting_star_stacks:OnCreated()

	self:SetStackCount(0)
	self:GetParent().shootingStarOverhead = ParticleManager:CreateParticle( "particles/visage_soul_overhead.vpcf", PATTACH_OVERHEAD_FOLLOW, self:GetParent())
	--ParticleManager:SetParticleControl(self:GetParent().shootingStarOverhead, 1, Vector(1,0,0))
	--ParticleManager:ReleaseParticleIndex(self:GetParent().shootingStarOverhead)
	
end


function modifier_archmage_shooting_star_stacks:OnTooltip(params)
	return self:GetStackCount() * self:GetAbility():GetSpecialValueFor("damage_per_charge") + self:GetAbility():GetSpecialValueFor("initial_damage")
end