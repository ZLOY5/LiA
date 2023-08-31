LinkLuaModifier( "modifier_troll_cutthroat_animation", "heroes/TrollCutthroat/modifier_troll_cutthroat_animation.lua", LUA_MODIFIER_MOTION_NONE)

function Spawn(entityKeyValues)
Timers:CreateTimer(0.01,function()
	thisEntity:AddNewModifier(thisEntity,nil,"modifier_troll_cutthroat_animation",nil)
	return nil
end)

end