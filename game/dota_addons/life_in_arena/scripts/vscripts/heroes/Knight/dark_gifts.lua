function makeEffect( event )
	local caster = event.caster
	local ability = event.ability
	local duration = ability:GetLevelSpecialValueFor( "duration", ability:GetLevel() - 1 )
	local modif = caster:FindModifierByName("modifier_knight_dark_gifts")
	local timeSet = duration-modif:GetElapsedTime()
	local modifIll
	-- приделаем эффект ульты на существующие в данный момент иллюзии
	if caster.mirror_image_illusions then
		for i=1, #caster.mirror_image_illusions do
			if not caster.mirror_image_illusions[i]:IsNull() then
				ability:ApplyDataDrivenModifier( caster, caster.mirror_image_illusions[i], 'modifier_knight_dark_gifts', {} ) --Duration = timeSet
				modifIll = caster.mirror_image_illusions[i]:FindModifierByName("modifier_knight_dark_gifts")
				modifIll:SetDuration(timeSet,false)
			end
		end
	end

end
