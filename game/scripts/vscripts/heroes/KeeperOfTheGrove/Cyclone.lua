--[[
	Author: Noya
	Date: 08.02.2015.
	Progressively sends the target at a max height, then up and down between an interval, and finally back to the original ground position.
]]
function TornadoHeight( event )
	local caster = event.caster
	local target = event.target
	local ability = event.ability
	local duration_hero = ability:GetLevelSpecialValueFor( "duration_hero" , ability:GetLevel() - 1 )
	local duration_unit = ability:GetLevelSpecialValueFor( "duration_unit" , ability:GetLevel() - 1 )
	local cyclone_height = ability:GetLevelSpecialValueFor( "cyclone_height" , ability:GetLevel() - 1 )
	local cyclone_min_height = ability:GetLevelSpecialValueFor( "cyclone_min_height" , ability:GetLevel() - 1 )
	local cyclone_max_height = ability:GetLevelSpecialValueFor( "cyclone_max_height" , ability:GetLevel() - 1 )
	local tornado_start = GameRules:GetGameTime()

	-- Position variables
	local target_initial_x = target:GetAbsOrigin().x
	local target_initial_y = target:GetAbsOrigin().y
	local target_initial_z = target:GetAbsOrigin().z
	local position = Vector(target_initial_x, target_initial_y, target_initial_z)

	-- Adjust duration to hero or unit
	local duration = duration_hero
	if not target:IsHero() then
		duration = duration_unit
	end
	
	-- Height per time calculation
	local time_to_reach_max_height = duration / 10
	local height_per_frame = cyclone_height * 0.03
	print(height_per_frame)

	-- Time to go down
	local time_to_stop_fly = duration - time_to_reach_max_height
	print(time_to_stop_fly)

	-- Loop up and down
	local going_up = true

	-- Loop every frame for the duration
	Timers:CreateTimer(function()
		local time_in_air = GameRules:GetGameTime() - tornado_start
		
		-- First send the target at max height very fast
		if position.z < cyclone_height and time_in_air <= time_to_reach_max_height then
			--print("+",height_per_frame,position.z)
			
			position.z = position.z + height_per_frame
			target:SetAbsOrigin(position)
			return 0.03

		-- Go down until the target reaches the initial z
		elseif time_in_air > time_to_stop_fly and time_in_air <= duration then
			--print("-",height_per_frame)

			position.z = position.z - height_per_frame
			target:SetAbsOrigin(position)
			return 0.03

		-- Do Up and down cycles
		elseif time_in_air <= duration then
			-- Up
			if position.z < cyclone_max_height and going_up then 
				--print("going up")
				position.z = position.z + height_per_frame/3
				target:SetAbsOrigin(position)
				return 0.03

			-- Down
			elseif position.z >= cyclone_min_height then
				going_up = false
				--print("going down")
				position.z = position.z - height_per_frame/3
				target:SetAbsOrigin(position)
				return 0.03

			-- Go up again
			else
				--print("going up again")
				going_up = true
				return 0.03
			end

		-- End
		else
			print("End TornadoHeight")
		end
	end)
end

--[[
	Author: Noya
	Date: 16.01.2015.
	Rotates by an angle degree
]]
function Spin(keys)
    local target = keys.target
    local total_degrees = keys.Angle
    target:SetForwardVector(RotatePosition(Vector(0,0,0), QAngle(0,total_degrees,0), target:GetForwardVector()))
end

function Cyclone(event)
	local target = event.target
	local ability = event.ability
	local caster = event.caster
	if target:TriggerSpellAbsorb(ability) then
		return 
	end
	target:EmitSound("Brewmaster_Storm.Cyclone")
	ability:ApplyDataDrivenModifier(caster, target, "modifier_keeper_of_the_grove_treants_cyclone", {duration = ability:GetSpecialValueFor("duration")})
end

function CycloneEnd(event)
	local target = event.target

	target:StopSound("Brewmaster_Storm.Cyclone")

end