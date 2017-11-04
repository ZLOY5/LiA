require('timers')

function Spawn(entityKeyValues)	
	Timers:CreateTimer(0.01,function()
		
		local mult = Survival:GetHeroCount(false)
		local hp = 20000 + 2500*mult
		local armor = 80 + 10*mult
		local dmgMin = 675 + 25*mult
		local dmgMax = 725 + 25*mult

		thisEntity:SetMaxHealth(hp)
		thisEntity:SetBaseMaxHealth(hp)
		thisEntity:SetHealth(hp)
		thisEntity:SetPhysicalArmorBaseValue(armor)
		thisEntity:SetBaseDamageMin(dmgMin)	
		thisEntity:SetBaseDamageMax(dmgMax)
	

	end)
	
end
