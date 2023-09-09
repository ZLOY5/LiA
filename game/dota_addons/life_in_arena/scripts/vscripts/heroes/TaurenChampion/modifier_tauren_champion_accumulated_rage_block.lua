
modifier_tauren_champion_accumulated_rage_block = class({})

function modifier_tauren_champion_accumulated_rage_block:IsHidden()
	return false
end

function modifier_tauren_champion_accumulated_rage_block:IsPurgable()
	return false
end

function modifier_tauren_champion_accumulated_rage_block:OnCreated(kv)
	self.max_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("max_damage_blocked_percent")*0.01
	self.min_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("min_damage_blocked_percent")*0.01
	self.absorption_count = self:GetAbility():GetSpecialValueFor("absorption_count")
	self.shield_cooldown = self:GetAbility():GetSpecialValueFor("shield_cooldown")
	if IsServer() then
		self:SetStackCount(self.absorption_count)
		self.accumulatedRageArmor = ParticleManager:CreateParticle( "particles/units/heroes/hero_pangolier/pangolier_tailthump_buff.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
		ParticleManager:SetParticleControlEnt(self.accumulatedRageArmor, 1, self:GetCaster(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetParent():GetOrigin() + Vector(0,0,-50), true)

	end
end

function modifier_tauren_champion_accumulated_rage_block:OnRefresh(kv)
	self.max_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("max_damage_blocked_percent")*0.01
	self.min_damage_blocked_percent = self:GetAbility():GetSpecialValueFor("min_damage_blocked_percent")*0.01
	self.absorption_count = self:GetAbility():GetSpecialValueFor("absorption_count")
	self.shield_cooldown = self:GetAbility():GetSpecialValueFor("shield_cooldown")
end

function modifier_tauren_champion_accumulated_rage_block:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_TOTAL_CONSTANT_BLOCK,
		MODIFIER_EVENT_ON_ATTACK_FINISHED,
	}
 
	return funcs
end


function modifier_tauren_champion_accumulated_rage_block:GetModifierTotal_ConstantBlock(params)
	if IsServer() then
		local damage = params.original_damage
		local caster = self:GetParent()

		if caster:PassivesDisabled() then
			return 0
		end

	--	print(caster:GetHealth() * self.min_damage_blocked_percent .. "  " .. damage)
		if damage >= caster:GetHealth() * self.min_damage_blocked_percent then
	--		print("blocked")
			self.accumulatedRageBlock = ParticleManager:CreateParticle( "particles/units/heroes/hero_pangolier/pangolier_tailthump_shield_impact.vpcf", PATTACH_CUSTOMORIGIN_FOLLOW, self:GetParent() )
			ParticleManager:SetParticleControlEnt(self.accumulatedRageBlock, 0, self:GetCaster(), PATTACH_POINT_FOLLOW, "follow_origin", self:GetParent():GetOrigin() + Vector(0,0,-50), true)
			EmitSoundOn("Hero_Pangolier.TailThump.Shield", self:GetParent())
			self:DecrementStackCount()
		--	print(self:GetStackCount().." block")
			return damage
		end
	end
end

function modifier_tauren_champion_accumulated_rage_block:OnAttackFinished(params)
	if IsServer() then
		if params.target == self:GetParent() then
			if self:GetStackCount() == 0 then
			--	print(self:GetStackCount().." land")
				self:Destroy()
			end
		end
	end
end

function modifier_tauren_champion_accumulated_rage_block:OnDestroy()
	if IsServer() then
		ParticleManager:DestroyParticle(self.accumulatedRageArmor, true)
		self:GetParent():AddNewModifier(self:GetParent(), self:GetAbility(), "modifier_tauren_champion_accumulated_rage_damage", {duration = self.shield_cooldown})
	end
end



