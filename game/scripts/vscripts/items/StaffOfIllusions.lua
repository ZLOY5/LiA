function MakeIllusion(event)
	local caster = event.caster
	local player = caster:GetPlayerID()
	local target = event.target
	local unit_name = target:GetUnitName()
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "illusion_duration", ability:GetLevel() - 1 )
	local outgoingDamage = ability:GetLevelSpecialValueFor( "illusion_outgoing_damage", ability:GetLevel() - 1 )
	local incomingDamage = ability:GetLevelSpecialValueFor( "illusion_incoming_damage", ability:GetLevel() - 1 )
	local hPlayer = caster:GetPlayerOwner()

	if string.find(unit_name,"megaboss") then
		ability:RefundManaCost()
		ability:EndCooldown()
		FireGameEvent( 'custom_error_show', { player_ID = event.caster:GetPlayerOwnerID(), _error = "#lia_hud_error_item_lia_staff_of_illusions_megaboss" } )
		return
	end

	local origin = target:GetAbsOrigin() + ( target:GetForwardVector() * 150 )
	
	CreateIllusion(target,caster,origin,duration,outgoingDamage,incomingDamage)

	ResolveNPCPositions(origin,65)
end