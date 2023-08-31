modifier_destuctable_object = class({})

function modifier_destuctable_object:IsHidden()
	return false
end

function modifier_destuctable_object:IsPurgable()
	return false
end

function modifier_destuctable_object:OnCreated()
    if IsServer() then
        self.parent = self:GetParent()
        self.parent.obstruction = SpawnEntityFromTableSynchronous('point_simple_obstruction', {origin = self:GetParent():GetAbsOrigin()})
        self.origin = self.parent:GetAbsOrigin()
        
        DebugDrawCircle(self.origin, Vector(120,0,0),20,100,true,100)
    end
end

function modifier_destuctable_object:OnDestroy()
    if IsServer() then
        -- if self.parent.obstruction then
        --     UTIL_Remove(self.parent.obstruction)
        -- end
        self.barrels = FindUnitsInRadius(DOTA_TEAM_GOODGUYS, 
                            self.origin, 
                            nil, 
                            120, 
                            DOTA_UNIT_TARGET_TEAM_BOTH, 
                            DOTA_UNIT_TARGET_ALL, 
                            DOTA_UNIT_TARGET_FLAG_NONE, 
                            FIND_ANY_ORDER, 
                            false)
        print(#self.barrels)
        if (#self.barrels) then
            for k, v in pairs(self.barrels) do
                print(v.obstruction)
                if v.obstruction then
                    UTIL_Remove(self.parent.obstruction)
                end
            end
        end
    end
end