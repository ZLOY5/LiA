function Illusions( event )
	local caster = event.caster
	local ability = event.ability
	local unit_name = caster:GetUnitName()
	local images_count = ability:GetSpecialValueFor("images_count")
	local duration = ability:GetSpecialValueFor("illusion_duration")
	local outgoingDamage = ability:GetSpecialValueFor("illusion_outgoing_damage")
	local incomingDamage = ability:GetSpecialValueFor("illusion_incoming_damage")

	local casterOrigin = caster:GetAbsOrigin()
	local casterAngles = caster:GetAngles()

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

	-- Setup a table of potential spawn positions
	local vRandomSpawnPos = {
		Vector( 150, 0, 0 ),		-- North
		Vector( 0, 150, 0 ),		-- East
		Vector( -150, 0, 0 ),	-- South
		Vector( 0, -150, 0 ),	-- West
	}

	for i=#vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
		local j = RandomInt( 1, i )
		vRandomSpawnPos[i], vRandomSpawnPos[j] = vRandomSpawnPos[j], vRandomSpawnPos[i]
	end

	-- Insert the center position and make sure that at least one of the units will be spawned on there.
	table.insert( vRandomSpawnPos, RandomInt( 1, images_count+1 ), Vector( 0, 0, 0 ) )

	-- At first, move the main hero to one of the random spawn positions.
	FindClearSpaceForUnit( caster, casterOrigin + table.remove( vRandomSpawnPos, 1 ), true )

	-- Spawn illusions
	for i=1, images_count do

		local origin = casterOrigin + table.remove( vRandomSpawnPos, 1 )

		-- handle_UnitOwner needs to be nil, else it will crash the game.
		local illusion = CreateUnitByName(caster:GetUnitName() , origin, true, caster, caster, caster:GetTeam())
		
		illusion:SetAngles( casterAngles.x, casterAngles.y, casterAngles.z )
		
		-- set life and mana illusion
		illusion:SetMana(caster:GetMana())
		illusion:SetHealth(caster:GetHealth())
		illusion:SetDeathXP(0)

		-- Set the unit as an illusion
		-- modifier_illusion controls many illusion properties like +Green damage not adding to the unit damage, not being able to cast spells and the team-only blue particle
		illusion:AddNewModifier(caster, ability, "modifier_illusion", { duration = duration, outgoing_damage = outgoingDamage, incoming_damage = incomingDamage })
		
		-- Without MakeIllusion the unit counts as a hero, e.g. if it dies to neutrals it says killed by neutrals, it respawns, etc.
		illusion:MakeIllusion()

		-- Add the illusion created to a table within the caster handle, to remove the illusions on the next cast if necessary
		table.insert(caster.mirror_image_illusions, illusion)

	end
end
