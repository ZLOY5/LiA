require('timers')

function Spawn(entityKeyValues)	
	Timers:CreateTimer(0.01,function()
		
		local mult = Survival:GetHeroCount(false)
		local hp = 4000 + 250*mult
		local armor = 20 + 2*mult
		local dmg_min = 181 + 20*mult
		local dmg_max = dmg_min + 6

		thisEntity:SetMaxHealth(hp)
		thisEntity:SetBaseMaxHealth(hp)
		thisEntity:SetHealth(hp)
		thisEntity:SetPhysicalArmorBaseValue(armor)
		thisEntity:SetBaseDamageMin(dmg_min)	
		thisEntity:SetBaseDamageMax(dmg_max)
	

	end)
	
end