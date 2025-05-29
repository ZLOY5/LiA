require("heroes/ShadowMaster/Shadow")

---@class shadow_master_art_of_shadows:CDOTA_Ability_Lua
shadow_master_art_of_shadows = class({})

LinkLuaModifier("modifier_shadow_master_art_of_shadows","heroes/ShadowMaster/shadow_master_art_of_shadows.lua",LUA_MODIFIER_MOTION_NONE)
LinkLuaModifier("modifier_shadow_master_art_of_shadows_tracker","heroes/ShadowMaster/shadow_master_art_of_shadows.lua",LUA_MODIFIER_MOTION_NONE)

function shadow_master_art_of_shadows:GetIntrinsicModifierName()
	return "modifier_shadow_master_art_of_shadows"
end

function shadow_master_art_of_shadows:OnToggle()
    return
end

local function UpdateShadowStacks(ability)
    local mod = ability:GetCaster():FindModifierByName("modifier_shadow_master_art_of_shadows")
    if mod then
        mod:SetStackCount(#ability.shadows)
    end
end

-- adds a freshly-spawned shadow to the table and enforces the hard cap
function shadow_master_art_of_shadows:AddShadow(unit)
	if not self.shadows then self.shadows = {} end

	table.insert(self.shadows, unit)

	-- kill the oldest shadow if we go over the limit
	local max = self:GetSpecialValueFor("max_shadows")
	if #self.shadows > max then
		local oldest = table.remove(self.shadows, 1)
		if oldest and not oldest:IsNull() and oldest:IsAlive() then
			oldest:ForceKill(false)
		end
	end

    UpdateShadowStacks(self)
end

-- removes a shadow reference when it dies / expires
function shadow_master_art_of_shadows:RemoveShadow(unit)
	if not self.shadows then return end
	for i = #self.shadows, 1, -1 do
		if self.shadows[i] == unit then
			table.remove(self.shadows, i)
			break
		end
	end

    UpdateShadowStacks(self)
end

------------------------------------------------------
-- Modifier: Internal stack tracker + attack listener
------------------------------------------------------
---@class modifier_shadow_master_art_of_shadows:CDOTA_Modifier_Lua
modifier_shadow_master_art_of_shadows = class({})

function modifier_shadow_master_art_of_shadows:IsHidden()      return false  end
function modifier_shadow_master_art_of_shadows:IsPurgable()    return false end
function modifier_shadow_master_art_of_shadows:GetOrbPriority() return DOTA_ORB_PRIORITY_ABILITY end

function modifier_shadow_master_art_of_shadows:DeclareFunctions()
    return { MODIFIER_EVENT_ON_ATTACK_LANDED }
end

function modifier_shadow_master_art_of_shadows:OnCreated()
    self.caster = self:GetCaster()
    self.ability = self:GetAbility()
    self.max_shadows = self.ability:GetSpecialValueFor("max_shadows")
    self.shadow_lifetime = self.ability:GetSpecialValueFor("shadow_lifetime")
    self.shadow_attributes_perc = self.ability:GetSpecialValueFor("shadow_attributes_perc") * 0.01
    self.spawn_chance = self.ability:GetSpecialValueFor("spawn_chance")

    if not self.ability.shadowsNumber then 
		self.ability.shadowsNumber = 0
		self.ability.shadows = {}
	end 

    self:SetStackCount(0)

    if IsServer() then
        RegisterOrbEffectModifier(self)
		self.pseudo = PseudoRandom:New(self.spawn_chance*0.01)
	end
end

function modifier_shadow_master_art_of_shadows:OnRefresh()
    self.max_shadows = self.ability:GetSpecialValueFor("max_shadows")
    self.shadow_lifetime = self.ability:GetSpecialValueFor("shadow_lifetime")
    self.shadow_attributes_perc = self.ability:GetSpecialValueFor("shadow_attributes_perc")
end

function modifier_shadow_master_art_of_shadows:OnOrbImpact(event)
    -- if not IsServer() then return end

    if not self.ability:GetToggleState() then
        return
    end

    if self.pseudo:Trigger() then

        local casterForwardVec = self.caster:GetForwardVector()
        local spawnPos = self.caster:GetAbsOrigin() + RotatePosition(Vector(0,0,0), QAngle(0,-90,0),casterForwardVec)*75

        local strength = self.caster:GetStrength() * self.shadow_attributes_perc * 0.01
        local agility = self.caster:GetAgility() * self.shadow_attributes_perc * 0.01
        local intellect = self.caster:GetIntellect(false) * self.shadow_attributes_perc * 0.01

        local shadow = CreateShadow(self.caster,spawnPos,casterForwardVec,self.shadow_lifetime,strength,agility,intellect,2)

        -- keep track of it
        self.ability:AddShadow(shadow)

        -- attach the tracker modifier so we know when it’s gone
        shadow:AddNewModifier(
            self.caster,
            self.ability,
            "modifier_shadow_master_art_of_shadows_tracker",
            { duration = self.shadow_lifetime }   -- still gets cleaned up early on death
        )
    end

end


---@class modifier_shadow_master_art_of_shadows_tracker:CDOTA_Modifier_Lua
modifier_shadow_master_art_of_shadows_tracker = class({})

function modifier_shadow_master_art_of_shadows_tracker:IsHidden()   return true  end
function modifier_shadow_master_art_of_shadows_tracker:IsPurgable() return false end

function modifier_shadow_master_art_of_shadows_tracker:DeclareFunctions()
	return { MODIFIER_EVENT_ON_DEATH }
end

-- remove reference when the shadow unit dies
function modifier_shadow_master_art_of_shadows_tracker:OnDeath(event)
	if not IsServer() then return end
	if event.unit ~= self:GetParent() then return end

	local ability = self:GetAbility()
	if ability and not ability:IsNull() then
		ability:RemoveShadow(event.unit)
	end
end

-- also catch the case where the modifier simply ends (lifetime expired)
function modifier_shadow_master_art_of_shadows_tracker:OnDestroy()
	if not IsServer() then return end

	local ability = self:GetAbility()
	if ability and not ability:IsNull() then
		ability:RemoveShadow(self:GetParent())
	end
end