function HealOwner(event)
	local caster = event.caster
	local owner = caster.owner
	--print(ownerEnt:GetUnitName())
	if owner and IsValidEntity(owner) then
		owner:Heal(event.owner_health_restore, caster) 
	end
end

function KillShadow(event)
	event.caster:ForceKill(true)
end