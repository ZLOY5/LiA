modifier_destuctable_object = class({})

function modifier_destuctable_object:IsHidden()
	return false
end

function modifier_destuctable_object:IsPurgable()
	return false
end

function modifier_destuctable_object:OnCreated()
    CreateTempTree(self:GetParent():GetAbsOrigin(), 7200)
end

function modifier_destuctable_object:OnRemoved()
    GridNav:DestroyTreesAroundPoint(self:GetParent():GetAbsOrigin(), 5, true)
end