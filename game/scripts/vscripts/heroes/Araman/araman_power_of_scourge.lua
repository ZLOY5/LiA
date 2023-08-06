araman_power_of_scourge = class ({})
LinkLuaModifier("modifier_araman_power_of_scourge", "heroes/Araman/modifier_araman_power_of_scourge.lua", LUA_MODIFIER_MOTION_NONE)

function araman_power_of_scourge:OnSpellStart()
	local hCaster = self:GetCaster()

	if hCaster == nil then
		return
	end

	hCaster:AddNewModifier(hCaster, self, "modifier_araman_power_of_scourge", { duration = self:GetDuration() })

	EmitSoundOnLocationWithCaster( hCaster:GetOrigin(), "Hero_Nightstalker.Darkness", hCaster )

end