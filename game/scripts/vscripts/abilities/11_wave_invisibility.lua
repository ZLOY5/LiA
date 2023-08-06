function modifier_11_wave_datadriven_on_attack_landed(keys)
	if not keys.caster.invisTimer then 
		keys.caster.invisTimer = DoUniqueString(nil)
	end
	Timers:CreateTimer(keys.caster.invisTimer,{ endTime = 1, callback = function()
		keys.ability:ApplyDataDrivenModifier(keys.caster, keys.caster, "modifier_11_wave_invisibility_datadriven", nil)
    	return nil
    end}) 
end