function illusions( event )
	local caster = event.caster
	local player = caster:GetPlayerID()
	local ability = event.ability
	local unit_name = caster:GetUnitName()

	local duration = ability:GetLevelSpecialValueFor( "time", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "incoming_damage", ability:GetLevel() - 1 )



end



