function Heal( event )
	local ability = event.ability
	
	if ability:IsCooldownReady() and not event.caster:PassivesDisabled() then
  		event.caster:Heal(event.unit:GetMaxHealth()*ability:GetLevelSpecialValueFor("heal_percentage", ability:GetLevel() - 1 )*0.01, event.unit)	
  		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
  	end
end
