--====================================================
-- scripts/vscripts/heroes/speedwarden/speedwarden_mad_charge.lua
--====================================================
---@class speedwarden_mad_charge:CDOTA_Ability_Lua
if speedwarden_mad_charge == nil then speedwarden_mad_charge = class({}) end

LinkLuaModifier("modifier_speedwarden_mad_charge","heroes/Speedwarden/speedwarden_mad_charge.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_speedwarden_mad_charge_buff","heroes/Speedwarden/speedwarden_mad_charge.lua",LUA_MODIFIER_MOTION_NONE)

function speedwarden_mad_charge:GetIntrinsicModifierName()
    return "modifier_speedwarden_mad_charge"
end

------------------------------------------------------
-- Modifier: tracks movement and grants charges
------------------------------------------------------
---@class modifier_speedwarden_mad_charge:CDOTA_Modifier_Lua
modifier_speedwarden_mad_charge = class({})

function modifier_speedwarden_mad_charge:IsHidden()      return true  end
function modifier_speedwarden_mad_charge:IsPurgable()    return false end

function modifier_speedwarden_mad_charge:OnCreated()
    if not IsServer() then return end
    local ability = self:GetAbility()
    -- AbilityValues
    self.distance_per_charge = self:GetRequiredDistance()
    
    self.speed_pct           = ability:GetSpecialValueFor("speed_pct")
    self.max_charges         = ability:GetSpecialValueFor("max_charges")
    self.charge_duration     = ability:GetSpecialValueFor("charge_duration")

    -- State
    self.charges = 0
    self.travelled = 0
    self.last_pos = self:GetParent():GetAbsOrigin()

    self:StartIntervalThink(0.1)
end

function modifier_speedwarden_mad_charge:GetRequiredDistance()
    if self:GetCaster():HasModifier("modifier_speedwarden_wardens_swiftness") then
		return self:GetAbility():GetSpecialValueFor("distance_per_charge_swiftness")
	end
    return self:GetAbility():GetSpecialValueFor("distance_per_charge")
end

function modifier_speedwarden_mad_charge:OnIntervalThink()
    local parent = self:GetParent()
    local new_pos = parent:GetAbsOrigin()
    local dist = (new_pos - self.last_pos):Length2D()
    self.last_pos = new_pos
    self.travelled = self.travelled + dist

    self.distance_per_charge = self:GetRequiredDistance()

    if self.travelled < self.distance_per_charge then return end

    -- Calculate number of possible charges gained
    local gained = math.floor(self.travelled / self.distance_per_charge)
    self.travelled = self.travelled - gained * self.distance_per_charge

    for i = 1, gained do
        if self.charges < self.max_charges then
            self.charges = self.charges + 1
            local buff = parent:AddNewModifier(parent, self:GetAbility(), "modifier_speedwarden_mad_charge_buff", {duration = self.charge_duration})
            if buff then buff:SetStackCount(self.charges) end
        else
            -- Already at max, refresh existing buff duration
            local buff = parent:FindModifierByName("modifier_speedwarden_mad_charge_buff")
            if buff then buff:SetDuration(self.charge_duration, true) end
        end
    end
end

------------------------------------------------------
-- Buff: grants movement speed and shows stacks
------------------------------------------------------
---@class modifier_speedwarden_mad_charge_buff:CDOTA_Modifier_Lua
modifier_speedwarden_mad_charge_buff = class({})

function modifier_speedwarden_mad_charge_buff:IsHidden()   return false end
function modifier_speedwarden_mad_charge_buff:IsPurgable() return true  end

function modifier_speedwarden_mad_charge_buff:OnCreated()
    self.parent = self:GetParent()
    self.speed_pct = self:GetAbility():GetSpecialValueFor("speed_pct")
end

function modifier_speedwarden_mad_charge_buff:OnRefresh()
    self.parent = self:GetParent()
    self.speed_pct = self:GetAbility():GetSpecialValueFor("speed_pct")
end

function modifier_speedwarden_mad_charge_buff:DeclareFunctions()
    return { MODIFIER_PROPERTY_MOVESPEED_BONUS_PERCENTAGE }
end

function modifier_speedwarden_mad_charge_buff:GetModifierMoveSpeedBonus_Percentage()
    local stacks = self:GetStackCount()
    return stacks * self.speed_pct
end

function modifier_speedwarden_mad_charge_buff:OnDestroy()
    if not IsServer() then return end
    -- Reset tracking in the main modifier when buff expires
    local parent = self:GetParent()
    local track = parent:FindModifierByName("modifier_speedwarden_mad_charge")
    if track then
        track.charges   = 0
        track.travelled = 0
        track.last_pos  = parent:GetAbsOrigin()
    end
end
