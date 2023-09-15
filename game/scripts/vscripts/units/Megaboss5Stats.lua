require('timers')

function Spawn(entityKeyValues)	
	Timers:CreateTimer(0.01,function()
		
		local mult = Survival:GetHeroCount(false)
		local hp = 3625 + 375*mult
		local armor = 15 + 5*mult
		local dmg_min = 150 + 30*mult
		local dmg_max = dmg_min + 6

		thisEntity:SetMaxHealth(hp)
		thisEntity:SetBaseMaxHealth(hp)
		thisEntity:SetHealth(hp)
		thisEntity:SetPhysicalArmorBaseValue(armor)
		thisEntity:SetBaseDamageMin(dmg_min)	
		thisEntity:SetBaseDamageMax(dmg_max)
	

	end)
	
end
