require('timers')

function Spawn(entityKeyValues)	
	Timers:CreateTimer(0.01,function()
		
		local mult = Survival:GetHeroCount(false)
		local hp = 22250 + 750*mult
		local armor = 55 + 10*mult
		local dmg = 725 + 75*mult

		thisEntity:SetMaxHealth(hp)
		thisEntity:SetBaseMaxHealth(hp)
		thisEntity:SetHealth(hp)
		thisEntity:SetPhysicalArmorBaseValue(armor)
		thisEntity:SetBaseDamageMin(dmg)	
		thisEntity:SetBaseDamageMax(dmg)
	

	end)
	
end
