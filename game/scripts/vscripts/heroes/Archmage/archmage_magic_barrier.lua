archmage_magic_barrier = class({})
LinkLuaModifier("modifier_archmage_magic_barrier","heroes/Archmage/modifier_archmage_magic_barrier.lua",LUA_MODIFIER_MOTION_NONE)


function archmage_magic_barrier:GetIntrinsicModifierName()
	return "modifier_archmage_magic_barrier"
end

function archmage_magic_barrier:GetBehavior()
	local netTable = CustomNetTables:GetTableValue("custom_modifier_state", tostring( self:GetEntityIndex() ).."behavior" )

	if netTable and netTable.behavior then 
		return netTable.behavior
	else
		return self.BaseClass.GetBehavior(self)
	end
end

function archmage_magic_barrier:OnSpellStart()
	local caster = self:GetCaster()
	local target = self:GetCursorTarget()

	if not target and self:GetBehavior() == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE then
		return 
	end

	if self:GetBehavior() == DOTA_ABILITY_BEHAVIOR_UNIT_TARGET then
		self.target = target
		caster:RemoveModifierByName("modifier_archmage_magic_barrier")
		target:AddNewModifier(caster,self,"modifier_archmage_magic_barrier",nil)
		CustomNetTables:SetTableValue("custom_modifier_state", tostring( self:GetEntityIndex() ).."behavior", 
			{ behavior = DOTA_ABILITY_BEHAVIOR_NO_TARGET + DOTA_ABILITY_BEHAVIOR_IMMEDIATE } )
	else
		if IsValidEntity(self.target) then
			self.target:RemoveModifierByName("modifier_archmage_magic_barrier")
		end
		self.target = nil
		caster:AddNewModifier(caster,self,"modifier_archmage_magic_barrier",nil)
		CustomNetTables:SetTableValue("custom_modifier_state", tostring( self:GetEntityIndex() ).."behavior", 
			{ behavior = DOTA_ABILITY_BEHAVIOR_UNIT_TARGET } )
	end
end	

function archmage_magic_barrier:OnUpgrade()
	if not self.barrierMana then
		self.barrierMana = 0
	end
end

function archmage_magic_barrier:OnOwnerDied()
	self.barrierMana = 0
	if IsValidEntity(self.target) then
		self.target:RemoveModifierByName("modifier_archmage_magic_barrier")
	end
	self.target = nil
end