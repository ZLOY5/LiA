modifier_archmage_magic_barrier = class({})

function modifier_archmage_magic_barrier:IsHidden()
	--if self:GetAbility().barrierMana <= 0 then
	--	return true 
	--else 
		return false 
	--end
end

function modifier_archmage_magic_barrier:IsPurgable()
	return false
end

function modifier_archmage_magic_barrier:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ABILITY_EXECUTED,
		MODIFIER_PROPERTY_TOOLTIP,
		MODIFIER_EVENT_ON_DEATH,
	}
 
	return funcs
end

function modifier_archmage_magic_barrier:OnCreated(kv)
	self.barrierManaPercent = self:GetAbility():GetSpecialValueFor("lol")*0.01
	self.barrierManaLoss = self:GetAbility():GetSpecialValueFor("lol1")/2
	self:StartIntervalThink(0.5)

	if not self:GetAbility().barrierMana then
		self:GetAbility().barrierMana = 0
	end
end

function modifier_archmage_magic_barrier:OnRefresh(kv)
	self.barrierManaPercent = self:GetAbility():GetSpecialValueFor("lol")*0.01
	self.barrierManaLoss = self:GetAbility():GetSpecialValueFor("lol1")/2
end

function modifier_archmage_magic_barrier:GetBlockedDamage(attack_damage)
	local ability = self:GetAbility()
	local blocked_damage = 0 
	
	if ability.barrierMana == 0 then
		return 0 
	end

	if ability.barrierMana > attack_damage then 
		blocked_damage = attack_damage
	else
		blocked_damage = ability.barrierMana
	end

	ability.barrierMana = ability.barrierMana - blocked_damage
	CustomNetTables:SetTableValue("custom_modifier_state", tostring( ability:GetEntityIndex() ) ,{ barrierMana = ability.barrierMana })

	return blocked_damage
end

function modifier_archmage_magic_barrier:OnAbilityExecuted(params)
	local eventAbility = params.ability 

	if eventAbility:IsItem() then
		return 
	end

	self:GetAbility().barrierMana = self:GetAbility().barrierMana + eventAbility:GetManaCost(-1)*self.barrierManaPercent
	CustomNetTables:SetTableValue("custom_modifier_state",tostring(self:GetAbility():GetEntityIndex()),{ barrierMana = self:GetAbility().barrierMana })
	print("Archmage[Mana barrier]: Added "..eventAbility:GetManaCost(-1)*self.barrierManaPercent.." mana",self:GetAbility().barrierMana)
end

function modifier_archmage_magic_barrier:OnIntervalThink()
	local ability = self:GetAbility()

	if IsServer() then
		if ability.barrierMana < self.barrierManaLoss then
			ability.barrierMana = 0
		else
			ability.barrierMana = ability.barrierMana - self.barrierManaLoss
		end

		if ability.barrierMana > 0 then
			local shield_size = 75

			if self:GetParent().magicBarrerParticle == nil then
				self:GetParent().magicBarrerParticle = ParticleManager:CreateParticle("particles/abaddon_aphotic_shield.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
				ParticleManager:SetParticleControl(self:GetParent().magicBarrerParticle, 1, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(self:GetParent().magicBarrerParticle, 2, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(self:GetParent().magicBarrerParticle, 4, Vector(shield_size,0,shield_size))
				ParticleManager:SetParticleControl(self:GetParent().magicBarrerParticle, 5, Vector(shield_size,0,0))

				ParticleManager:SetParticleControlEnt(self:GetParent().magicBarrerParticle, 0, self:GetParent(), PATTACH_POINT_FOLLOW, "attach_hitloc", self:GetParent():GetAbsOrigin(), true)
				--
			end	
		elseif ability.barrierMana == 0 and self:GetParent().magicBarrerParticle ~= nil then
			ParticleManager:DestroyParticle(self:GetParent().magicBarrerParticle,true)
			self:GetParent().magicBarrerParticle = nil
		end

		CustomNetTables:SetTableValue("custom_modifier_state", tostring( ability:GetEntityIndex() ) ,{ barrierMana = ability.barrierMana })
	else
		local netTable = CustomNetTables:GetTableValue("custom_modifier_state", tostring( ability:GetEntityIndex() ) )

		if netTable then
			ability.barrierMana = netTable.barrierMana
		end
	end


	return 0.5
end

if IsServer() then

	function modifier_archmage_magic_barrier:OnDeath(params)
		if params.unit == self:GetParent() then
			self:GetAbility().target = nil
			CustomNetTables:SetTableValue("custom_modifier_state", tostring( self:GetAbility():GetEntityIndex() ), 
				{ behavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET } )
			if self:GetCaster():IsAlive() then
				self:GetCaster():AddNewModifier(self:GetCaster(),self:GetAbility(),"modifier_archmage_magic_barrier",nil)
			end
		end
	end

end

function modifier_archmage_magic_barrier:OnTooltip(params)
	return ability.barrierMana
end