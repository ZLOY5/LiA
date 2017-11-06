function Purge(event)
	event.caster:Purge(false,true,false,false,false)
end

function OnDestroy( event )
	local caster = event.caster	
	ResolveNPCPositions(caster:GetAbsOrigin(),25)
end