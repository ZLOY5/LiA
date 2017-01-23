require('timers')

function Spawn(entityKeyValues)
Timers:CreateTimer(0.01,function()
	thisEntity:AddNewModifier(thisEntity,nil,"modifier_troll_cutthroat_animation",nil)
	return 1
end)

end