modifier_tauren_champion_finish_off_animation = class({})

function modifier_tauren_champion_finish_off_animation:DeclareFunctions()
    local funcs = {
        MODIFIER_PROPERTY_TRANSLATE_ACTIVITY_MODIFIERS,
        MODIFIER_EVENT_ON_ATTACK_FINISHED,
    }

    return funcs
end

function modifier_tauren_champion_finish_off_animation:GetActivityTranslationModifiers()
    return "enchant_totem"
end

function modifier_tauren_champion_finish_off_animation:OnAttackFinished( params )
	if IsServer() then
		if self:GetParent() == params.attacker then
			self:GetParent():RemoveModifierByName("modifier_tauren_champion_finish_off_animation")
		end
	end
end

function modifier_tauren_champion_finish_off_animation:IsHidden()
    return true
end

function modifier_tauren_champion_finish_off_animation:OnCreated(kv)
	if IsServer() then
		self.totemUltimateParticle = ParticleManager:CreateParticle("particles/units/heroes/hero_earthshaker/earthshaker_totem_buff.vpcf", PATTACH_POINT_FOLLOW, self:GetParent())
		ParticleManager:SetParticleControlEnt(self.totemUltimateParticle, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "attach_totem", Vector(0,0,0), false)
	end
end

function modifier_tauren_champion_finish_off_animation:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.totemUltimateParticle, false)
	end
end