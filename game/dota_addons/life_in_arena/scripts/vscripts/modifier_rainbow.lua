modifier_rainbow = class({})

function modifier_rainbow:DeclareFunctions()
    local funcs = {
    }

    return funcs
end

function modifier_rainbow:CheckState()
  local state = {
  }
  return state
end

function modifier_rainbow:IsHidden()
    return false
end

function modifier_rainbow:GetEffectName()
  return "particles/rainbow.vpcf"
end

function modifier_rainbow:GetEffectAttachType()
    return PATTACH_ABSORIGIN_FOLLOW
end

function modifier_rainbow:GetAttributes()
    return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE
end

function modifier_rainbow:GetTexture()
  return "rainbow"
end


--particles/econ/courier/courier_trapjaw/courier_trapjaw_trail.vpcf
--particles/econ/items/earth_spirit/earth_spirit_ti6_boulder/espirit_ti6_rollingboulder_trail_main.vpcf