function HealOwner(event)
	local caster = event.caster
	local owner = caster:GetOwner()
	--print(ownerEnt:GetUnitName())
	if owner and IsValidEntity(owner) and owner:IsAlive() then
		owner:Heal(event.owner_health_restore, caster) 
	end
end

function KillShadow(event)
	event.caster:ForceKill(true)
end