require('timers')

function Spawn(entityKeyValues)	
	Timers:CreateTimer(0.01,function()
		thisEntity:SetRenderColor(0,0,0)
		thisEntity:SetMinimumGoldBounty(82)
		thisEntity:SetMaximumGoldBounty(85)
	end)
	
end