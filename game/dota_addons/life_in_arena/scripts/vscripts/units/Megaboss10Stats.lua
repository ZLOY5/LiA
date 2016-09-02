require('timers')

function Spawn(entityKeyValues)	
	Timers:CreateTimer(0.01,function()
		
		local mult = Survival:GetHeroCount(false)
		local hp = 23000 + 500*mult
		local armor = 70 + 5*mult
		local dmg = 800 + 50*mult

		thisEntity:SetMaxHealth(hp)
		thisEntity:SetBaseMaxHealth(hp)
		thisEntity:SetHealth(hp)
		thisEntity:SetPhysicalArmorBaseValue(armor)
		thisEntity:SetBaseDamageMin(dmg)	
		thisEntity:SetBaseDamageMax(dmg)
	

	end)
	
end