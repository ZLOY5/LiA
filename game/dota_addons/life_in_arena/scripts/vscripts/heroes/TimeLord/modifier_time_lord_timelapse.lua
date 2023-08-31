modifier_time_lord_timelapse = class({})

function modifier_time_lord_timelapse:IsHidden()
	return true
end

function modifier_time_lord_timelapse:IsPurgable()
	return false
end

if IsServer() then

	function modifier_time_lord_timelapse:OnCreated()
		self.time = self:GetAbility():GetSpecialValueFor("time")
		
		self.tick = 0.2
		self:StartIntervalThink(self.tick)
	end

	function modifier_time_lord_timelapse:OnIntervalThink()
		local ability = self:GetAbility()
		local caster = self:GetCaster()

		ability.heroState = ability.heroState or {}

		if ability.lastGameState ~= Survival.State then
			ability.heroState = {}
		end

		local ticks = math.modf(self.time/self.tick)
		if #ability.heroState >= ticks then
			table.remove(ability.heroState,1)
		end

		table.insert(ability.heroState,{caster:GetAbsOrigin(),caster:GetHealth(),caster:GetMana()})
		--DebugDrawSphere(caster:GetAbsOrigin(),Vector(255,0,0),255,20,true,5)
		ability.lastGameState = Survival.State

		return self.tick
	end

end