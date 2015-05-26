--[[

]]



function SetHealKret( keys )
	local caster = keys.caster
	--
	local procVal_porog = keys.procVal_porog
	local procVal_hp = keys.procVal_hp
	--
	if ( caster:GetHealth()/caster:GetMaxHealth() )*100 < procVal_porog then
		caster:Heal( (caster:GetMaxHealth()/100)*procVal_hp, caster )
	end

end

