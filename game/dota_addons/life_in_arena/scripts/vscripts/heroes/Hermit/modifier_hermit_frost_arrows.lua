modifier_hermit_frost_arrows = class ({})

function modifier_hermit_frost_arrows:DeclareFunctions()
	local funcs = {
		MODIFIER_EVENT_ON_ORB_EFFECT,
	}
 
	return funcs
end
 
--------------------------------------------------------------------------------
 
function modifier_hermit_frost_arrows:OnOrbEffect( params )
	if IsServer() then
		if params.attacker == self:GetParent() and ( not self:GetParent():IsIllusion() ) then
			--if self:GetParent():PassivesDisabled() then
			--	return 0
			--end
 
			local target = params.target
			if target ~= nil and target:GetTeamNumber() ~= self:GetParent():GetTeamNumber() then
			
			
				--local cleaveDamage = ( self.great_cleave_damage * params.damage ) / 100.0
				--DoCleaveAttack( self:GetParent(), target, self:GetAbility(), cleaveDamage, self.great_cleave_radius, "particles/units/heroes/hero_sven/sven_spell_great_cleave.vpcf" )
			end
		end
	end
 
	return 0
end

function modifier_hermit_frost_arrows:OnCreated(params)
		local hCaster = self:GetCaster()
		local ability = self:GetAbility()
		local lvl = ability:GetLevel()-1
		local unitname
		local PID = hCaster:GetPlayerOwnerID()
		local cre
		--
		local num = ability:GetSpecialValueFor( "unit_count" )
		local durat = ability:GetSpecialValueFor( "duration" )
		local obl = ability:GetSpecialValueFor( "spawn_radius" )
		--


end

--function modifier_hermit_summon_water_elemental:OnAttackLanded(params)
--	if IsServer() then
--
--	end
--end

