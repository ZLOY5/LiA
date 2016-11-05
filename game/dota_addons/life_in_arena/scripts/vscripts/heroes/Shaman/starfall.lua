
function starfallRegen(keys)

	--local heroCaster = keys.heroCaster
	local caster = keys.caster
	local regen_percentage = keys.regen_percentage
	local tick = keys.tick
	local value1perc = caster:GetMaxHealth() / 100	
	local reg = value1perc * regen_percentage * tick
	--
	--
	--caster:Heal(reg,caster)
	caster:SetHealth(caster:GetHealth() + reg)
	caster:Purge(false,true,false,false,false)
end
