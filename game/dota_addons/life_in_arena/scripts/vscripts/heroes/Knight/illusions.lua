function illusions( event )
	local caster = event.caster
	local ability = event.ability
	local images_count = ability:GetSpecialValueFor("images_count")
	local duration = ability:GetSpecialValueFor("illusion_duration")
	local outgoingDamage = ability:GetSpecialValueFor("outgoing_damage")
	local incomingDamage = ability:GetSpecialValueFor("incoming_damage")
	local radius = ability:GetSpecialValueFor("radius_hide")

	local casterOrigin = caster:GetAbsOrigin()
	local casterForward = caster:GetForwardVector()

	local casterHealthPercent = caster:GetHealthPercent()*0.01
	
	-- Initialize the illusion table to keep track of the units created by the spell
	if not caster.mirror_image_illusions then
		caster.mirror_image_illusions = {}
	end

	-- Kill the old images
	for k,v in pairs(caster.mirror_image_illusions) do
		if v and IsValidEntity(v) then 
			v:ForceKill(false)
		end
	end

	-- Start a clean illusion table
	caster.mirror_image_illusions = {}

	----------------------------------------------------------------------------------

	local angle = 360/(images_count+1)
	local vRandomSpawnPos = {}
	vRandomSpawnPos[1] = casterOrigin + RotatePosition(Vector(0,0,0), QAngle(0,-90,0),casterForward)*radius
	--print(vRandomSpawnPos[1],casterOrigin)
	for i=1,images_count do 
		vRandomSpawnPos[i+1] = RotatePosition(casterOrigin, QAngle(0,angle,0), vRandomSpawnPos[i])
		--print(vRandomSpawnPos[i+1])
	end



	-- At first, move the main hero to one of the random spawn positions.
	FindClearSpaceForUnit( caster, table.remove( vRandomSpawnPos,RandomInt(1, #vRandomSpawnPos)), true )

	-- Spawn illusions
	for i=1, images_count do
		local origin = table.remove( vRandomSpawnPos,RandomInt(1, #vRandomSpawnPos))

		local illusion = CreateIllusion(caster,caster,origin,duration,outgoingDamage,incomingDamage)
		illusion:SetHealth(casterHealthPercent*illusion:GetMaxHealth())
		-- Add the illusion created to a table within the caster handle, to remove the illusions on the next cast if necessary
		table.insert(caster.mirror_image_illusions, illusion)

	end
	--
	local abilityM = caster:FindAbilityByName("knight_dark_gifts")
	local durationM = abilityM:GetLevelSpecialValueFor( "duration", abilityM:GetLevel() - 1 )
	local modif = caster:FindModifierByName("modifier_knight_dark_gifts")
	if modif then
		local timeSet = durationM-modif:GetElapsedTime()
		local modifIll
		-- приделаем эффект ульты на существующие в данный момент иллюзии
		for i=1, #caster.mirror_image_illusions do
			if not caster.mirror_image_illusions[i]:IsNull() then
				abilityM:ApplyDataDrivenModifier( caster, caster.mirror_image_illusions[i], 'modifier_knight_dark_gifts', {} ) --Duration = timeSet
				modifIll = caster.mirror_image_illusions[i]:FindModifierByName("modifier_knight_dark_gifts")
				modifIll:SetDuration(timeSet, false)
			end
		end
		--print("			modif:GetElapsedTime =", modif:GetElapsedTime())
	end
end

function debuff( event )
	local caster = event.caster
	--local ability = event.ability
	--
	--print(" --------------		Purge ")
	caster:Purge(false, true, false, true, false)
	--
end


