modifier_archmage_polymorph_lua = class({})

function modifier_archmage_polymorph_lua:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_PROPERTY_MOVESPEED_BASE_OVERRIDE
    }

    return funcs
end

function modifier_archmage_polymorph_lua:GetModifierModelChange()
    return "models/items/hex/sheep_hex/sheep_hex.vmdl"
end

function modifier_archmage_polymorph_lua:CheckState() 
  local state = {
    [MODIFIER_STATE_DISARMED] = true,
    [MODIFIER_STATE_MUTED] = true,
    [MODIFIER_STATE_HEXED] = true,
    [MODIFIER_STATE_EVADE_DISABLED] = true,
    [MODIFIER_STATE_SILENCED] = true,
  }

  return state
end

function modifier_archmage_polymorph_lua:GetModifierMoveSpeedOverride()
    return 100
end

function modifier_archmage_polymorph_lua:OnCreated()
	local target = self:GetParent()
	local illusion_damage = self:GetAbility():GetSpecialValueFor("illusion_damage")

	if target:IsIllusion() then
    	ApplyDamage({ victim = target, attacker = self:GetCaster(), damage = illusion_damage, damage_type = DAMAGE_TYPE_PURE, ability = self:GetAbility() })
    end
end