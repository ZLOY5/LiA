function OnDestroy( event )
	local caster = event.caster	
	FindClearSpaceForUnit_IgnoreNeverMove(caster, caster:GetAbsOrigin(), true)
end