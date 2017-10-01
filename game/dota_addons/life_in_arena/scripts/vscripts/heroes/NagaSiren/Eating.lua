function Heal( event )
	local ability = event.ability
	
	if ability:IsCooldownReady() then
  		event.caster:Heal(event.unit:GetMaxHealth()*ability:GetLevelSpecialValueFor("heal_percentage", ability:GetLevel() - 1 )*0.01, event.unit)	
  		ability:StartCooldown(ability:GetCooldown(ability:GetLevel()))
  	end
end