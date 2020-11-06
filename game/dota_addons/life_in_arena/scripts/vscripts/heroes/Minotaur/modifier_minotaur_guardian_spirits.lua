modifier_minotaur_guardian_spirits = class({})

--------------------------------------------------------------------------------

function modifier_minotaur_guardian_spirits:IsHidden()
	return true
end

--------------------------------------------------------------------------------

function modifier_minotaur_guardian_spirits:IsPurgable()
	return false
end

function modifier_minotaur_guardian_spirits:OnCreated(kv)
	self.ability = self:GetAbility()
	self.caster = self.ability:GetCaster()
	self.radius = self.ability:GetSpecialValueFor( "radius" )

	self.images_count = self.ability:GetSpecialValueFor("images_count")
	self.duration = self.ability:GetSpecialValueFor("illusion_duration")
	self.outgoing_damage_percentage = self.ability:GetSpecialValueFor("outgoing_damage_percentage") - 100
	self.incoming_damage_percentage = self.ability:GetSpecialValueFor("incoming_damage_percentage") - 100
end

function modifier_minotaur_guardian_spirits:OnDestroy()
	if IsServer() then
		self.caster_origin = self.caster:GetAbsOrigin()
		print(self.caster_origin)

		-- Initialize the illusion table to keep track of the units created by the spell
		if not self.caster.guardian_spirits then
			self.caster.guardian_spirits = {}
		end

		print("SPIRITS COUNT ON CAST: ", #self.caster.guardian_spirits)
		-- Kill the old images
		for k,v in pairs(self.caster.guardian_spirits) do
			if v and IsValidEntity(v) then 
				v:ForceKill(false)
			end
		end

		-- -- Start a clean illusion table
		-- self.caster.guardian_spirits = {}
		

		-- Setup a table of potential spawn positions
		self.vRandomSpawnPos = {
			Vector( 72, 0, 0 ),		-- North
			Vector( 0, 72, 0 ),		-- East
			Vector( -72, 0, 0 ),	-- South
			Vector( 0, -72, 0 ),	-- West
		}

		for i=#self.vRandomSpawnPos, 2, -1 do	-- Simply shuffle them
			local j = RandomInt( 1, i )
			self.vRandomSpawnPos[i], self.vRandomSpawnPos[j] = self.vRandomSpawnPos[j], self.vRandomSpawnPos[i]
		end

		-- Insert the center position and make sure that at least one of the units will be spawned on there.
		table.insert( self.vRandomSpawnPos, RandomInt( 1, self.images_count+1 ), Vector( 0, 0, 0 ) )
		-- local heh = self.caster_origin + table.remove( self.vRandomSpawnPos, 1 )
		-- At first, move the main hero to one of the random spawn positions.
		FindClearSpaceForUnit_IgnoreNeverMove( self.caster, self.caster_origin + table.remove( self.vRandomSpawnPos, 1 ), true )

		-- Spawn illusions
		for i=1, self.images_count do

			local origin = self.caster_origin + table.remove( self.vRandomSpawnPos, 1 )

			-- handle_UnitOwner needs to be nil, else it will crash the game.
			local illusion = CreateIllusion_CustomModifier(self.caster,self.caster,origin,self.duration,self.outgoing_damage_percentage,self.incoming_damage_percentage, "modifier_minotaur_guardian_spirits_status_effect")

			-- Add the illusion created to a table within the caster handle, to remove the illusions on the next cast if necessary
			table.insert(self.caster.guardian_spirits, illusion)

			-- illusion:AddNewModifier(self.caster, self.ability, "modifier_minotaur_guardian_spirits_status_effect", nil)


		end
		
	end
end

function modifier_minotaur_guardian_spirits:CheckState()
	local state =
		{
			[MODIFIER_STATE_INVULNERABLE] = true,
			[MODIFIER_STATE_NO_HEALTH_BAR] = true,
			[MODIFIER_STATE_STUNNED] = true,
			[MODIFIER_STATE_OUT_OF_GAME] = true,
		}

	return state
end

function modifier_minotaur_guardian_spirits:GetEffectName()
	return "particles/custom/tauren_chieftain/tauren_chieftain_guardian_spirit.vpcf"
end

function modifier_minotaur_guardian_spirits:GetEffectAttachType()
	return PATTACH_ABSORIGIN_FOLLOW
end

