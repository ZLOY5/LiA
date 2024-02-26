modifier_orb_controller = class({})

DOTA_ORB_PRIORITY_DEFAULT = 0
DOTA_ORB_PRIORITY_ITEM = 1
DOTA_ORB_PRIORITY_ABILITY = 2

function modifier_orb_controller:IsPurgable() return false end
function modifier_orb_controller:IsHidden() return true end
function modifier_orb_controller:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE end

function modifier_orb_controller:DeclareFunctions()
	return {
		MODIFIER_EVENT_ON_ATTACK_START,
		MODIFIER_EVENT_ON_ATTACK_RECORD,
		MODIFIER_EVENT_ON_ATTACK,
		MODIFIER_EVENT_ON_ATTACK_LANDED,
		--MODIFIER_EVENT_ON_TAKEDAMAGE,
		MODIFIER_EVENT_ON_ATTACK_RECORD_DESTROY,
		MODIFIER_PROPERTY_PROJECTILE_NAME,
	}
end

function modifier_orb_controller:OnCreated()
	self.parent = self:GetParent()

	self.orb_modifiers = {}
	self.orb_record = {}
end

function modifier_orb_controller:RegisterOrb(modifier)
	if not table.contains(self.orb_modifiers, modifier) then
		table.insert(self.orb_modifiers, modifier)
	end
end

function modifier_orb_controller:SortOrbsByPriority()
	for i = #self.orb_modifiers, 1, -1 do
		local modifier = self.orb_modifiers[i]
		if modifier:IsNull() then table.remove(self.orb_modifiers, i) end
	end

	table.sort(self.orb_modifiers, function(a,b) 
		local priority_a = a.GetOrbPriority and a:GetOrbPriority() or DOTA_ORB_PRIORITY_DEFAULT
		local priority_b = b.GetOrbPriority and b:GetOrbPriority() or DOTA_ORB_PRIORITY_DEFAULT

		if priority_a ~= priority_b then return priority_a > priority_b end

		local ability_a = a:GetAbility()
		local ability_b = b:GetAbility()

		if ability_a:IsItem() and ability_b:IsItem() then return ability_a:GetItemSlot() < ability_b:GetItemSlot() end

		return a:GetCreationTime() < b:GetCreationTime()
	end)

	--for k,v in ipairs(self.orb_modifiers) do print(k,v:GetName()) end
end

function modifier_orb_controller:GetActiveOrb(event)
	self:SortOrbsByPriority()

	local active_orb

	for k, modifier in ipairs(self.orb_modifiers) do
		if modifier.IsOrbActive then
			local success, result = xpcall(modifier.IsOrbActive, error, modifier, event)
			if success and result then 
				active_orb = modifier 
				break
			end
		else
			active_orb = modifier
			break
		end
	end

	return active_orb
end

function modifier_orb_controller:OnAttackStart(event)
	if self.parent ~= event.attacker then return end

	local active_orb = self:GetActiveOrb(event)

	--print("modifier_orb_controller:OnAttackStart")
	--print(active_orb and active_orb:GetName() or "NIL")
	
	self.active_orb = active_orb
end

function modifier_orb_controller:OnAttackRecord(event)
	if self.parent ~= event.attacker then return end
	
	--print("modifier_orb_controller:OnAttackRecord")
	--print(self.active_orb and self.active_orb:GetName() or "NIL")
	
	self.orb_record[event.record] = self.active_orb
end

function modifier_orb_controller:OnAttack(event)
	if self.parent ~= event.attacker then return end

	local orb_modifier = self.orb_record[event.record]
	
	if orb_modifier and not orb_modifier:IsNull() and orb_modifier.OnOrbFire then
		orb_modifier:OnOrbFire(event)
	end
end


function modifier_orb_controller:OnAttackLanded(event)
	if self.parent ~= event.attacker then return end

	local orb_modifier = self.orb_record[event.record]

	if orb_modifier and not orb_modifier:IsNull() and orb_modifier.OnOrbImpact then
		orb_modifier:OnOrbImpact(event)
	end
end

function modifier_orb_controller:OnTakeDamage(event)
	local orb_modifier = self.orb_record[event.record]

	if orb_modifier and not orb_modifier:IsNull() and orb_modifier.OnOrbDamage then
		orb_modifier:OnOrbDamage(event)
	end
end

function modifier_orb_controller:OnAttackRecordDestroy(event)
	if self.parent ~= event.attacker then return end

	self.orb_record[event.record] = nil
end


function modifier_orb_controller:GetModifierProjectileName(event)
	if self.active_orb and self.active_orb.GetOrbProjectileName then 
		local success, result = xpcall(self.active_orb.GetOrbProjectileName, error, self.active_orb)
		if success then return result end
	end
end
