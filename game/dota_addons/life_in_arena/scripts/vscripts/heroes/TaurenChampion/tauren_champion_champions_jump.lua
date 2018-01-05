tauren_champion_champions_jump = class({})
LinkLuaModifier("modifier_tauren_champion_champions_jump","heroes/TaurenChampion/modifier_tauren_champion_champions_jump.lua",LUA_MODIFIER_MOTION_BOTH)
LinkLuaModifier("modifier_tauren_champion_champions_jump_phase","heroes/TaurenChampion/modifier_tauren_champion_champions_jump_phase.lua",LUA_MODIFIER_MOTION_BOTH)

function tauren_champion_champions_jump:OnSpellStart() 
	if IsServer() then
		local kv =
		{
			vLocX = self:GetCursorPosition().x,
			vLocY = self:GetCursorPosition().y,
			vLocZ = self:GetCursorPosition().z
		}

		self:GetCaster():AddNewModifier( self:GetCaster(), self, "modifier_tauren_champion_champions_jump", kv )
	end
end

-------------------------------------------------------------------------------
