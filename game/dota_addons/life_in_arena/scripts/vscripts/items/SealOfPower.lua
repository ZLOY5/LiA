item_lia_seal_of_power_shop = class({})

function item_lia_seal_of_power_shop:OnSpellStart()
	local caster = self:GetCaster()

	caster:RemoveItem(self) 
	Timers:CreateTimer(0.01,function()
		local item = caster:AddItemByName("item_lia_seal_of_power_damage")
		item:SetPurchaseTime(GameRules:GetGameTime())
	end)
end

function OnEquip(event)
	local caster = event.caster

	caster:RemoveItem(event.ability) 

	Timers:CreateTimer(0.01, function()
		local item = caster:AddItemByName("item_lia_seal_of_power_damage")
		item:SetPurchaseTime(GameRules:GetGameTime())
	end)

end

---------------------------------------------------------------------------------------
--///////////////////////////////////////////////////////////////////////////////////--
---------------------------------------------------------------------------------------

item_lia_seal_of_power_armor = class({})
LinkLuaModifier("modifier_item_lia_seal_of_power_armor", "items/SealOfPower.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_seal_of_power_armor:GetIntrinsicModifierName() 
	return "modifier_item_lia_seal_of_power_armor"
end

function item_lia_seal_of_power_armor:OnSpellStart()
	local caster = self:GetCaster()
	local purchaseTime = self:GetPurchaseTime()
	local itemSlot1 = self:GetItemSlot()

	caster:RemoveItem(self)

	local item = caster:AddItemByName("item_lia_seal_of_power_damage")
	item:SetPurchaseTime(purchaseTime)

	local itemSlot2 = item:GetItemSlot()
	caster:SwapItems(itemSlot1,itemSlot2)
end

---------------------------------------------------------------------------------------

modifier_item_lia_seal_of_power_armor = class({})

function modifier_item_lia_seal_of_power_armor:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_seal_of_power_armor:IsHidden()
	return false
end

function modifier_item_lia_seal_of_power_armor:IsPurgable()
	return false
end

function modifier_item_lia_seal_of_power_armor:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_item_lia_seal_of_power_armor:OnCreated(kv)
	self.damageBonus = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.armorBonus = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.oneArmorDamage = self:GetAbility():GetSpecialValueFor("damage_needed_for_one_armor")
	self.armorLimit = self:GetAbility():GetSpecialValueFor("armor_limit")
	self.damageLoseFactor = self:GetAbility():GetSpecialValueFor("stats_lose_percent")*0.01
	
	self.armorBonusFromDamage = 0
	self.damageLose = 0

	self.abilityID = self:GetAbility():entindex()
	
	self:StartIntervalThink(0.1)
	self:OnIntervalThink()
end

function modifier_item_lia_seal_of_power_armor:GetModifierPreAttack_BonusDamage(params)
	return self.damageBonus + self.damageLose
end

function modifier_item_lia_seal_of_power_armor:GetModifierPhysicalArmorBonus(params)
	return self.armorBonus + self.armorBonusFromDamage
end

function modifier_item_lia_seal_of_power_armor:OnIntervalThink()
	if IsServer() then
		local damage = math.floor(self:GetCaster():GetAverageTrueAttackDamage(nil) - self.damageLose + 0.5)
		
		self.armorBonusFromDamage = damage/self.oneArmorDamage
		
		if self.armorBonusFromDamage > self.armorLimit then
			self.armorBonusFromDamage = self.armorLimit
		end

		self.damageLose = math.floor(-(self.armorBonusFromDamage*self.oneArmorDamage*self.damageLoseFactor) + 0.5)
		
		--print(damage,self.armorBonusFromDamage,self.damageLose)
		
		self:SetStackCount(math.floor(self.armorBonusFromDamage+0.5))
		CustomNetTables:SetTableValue("custom_modifier_state",tostring(self.abilityID),{armorBonusFromDamage = self.armorBonusFromDamage, damageLose = self.damageLose})
	end

	if IsClient() then
		local netTable = CustomNetTables:GetTableValue("custom_modifier_state",tostring(self.abilityID))
		if netTable then
			self.armorBonusFromDamage = netTable.armorBonusFromDamage
			self.damageLose = netTable.damageLose
			--print("Client",self.armorBonusFromDamage,self.damageLose)
		end
	end
end

---------------------------------------------------------------------------------------
--///////////////////////////////////////////////////////////////////////////////////--
---------------------------------------------------------------------------------------

item_lia_seal_of_power_damage = class({})
LinkLuaModifier("modifier_item_lia_seal_of_power_damage", "items/SealOfPower.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_seal_of_power_damage:GetIntrinsicModifierName() 
	return "modifier_item_lia_seal_of_power_damage"
end

function item_lia_seal_of_power_damage:OnSpellStart()
	local caster = self:GetCaster()
	local purchaseTime = self:GetPurchaseTime()
	local itemSlot1 = self:GetItemSlot()

	caster:RemoveItem(self)

	local item = caster:AddItemByName("item_lia_seal_of_power_armor")
	item:SetPurchaseTime(purchaseTime)

	local itemSlot2 = item:GetItemSlot()
	caster:SwapItems(itemSlot1,itemSlot2)
end

---------------------------------------------------------------------------------------

modifier_item_lia_seal_of_power_damage = class({})

function modifier_item_lia_seal_of_power_damage:GetAttributes() 
	return MODIFIER_ATTRIBUTE_PERMANENT 
end

function modifier_item_lia_seal_of_power_damage:IsHidden()
	return false
end

function modifier_item_lia_seal_of_power_damage:IsPurgable()
	return false
end

function modifier_item_lia_seal_of_power_damage:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
 
	return funcs
end

function modifier_item_lia_seal_of_power_damage:OnCreated(kv)
	self.damageBonus = self:GetAbility():GetSpecialValueFor("bonus_damage")
	self.armorBonus = self:GetAbility():GetSpecialValueFor("bonus_armor")
	self.oneArmorDamage = self:GetAbility():GetSpecialValueFor("armor_needed_for_one_damage")
	self.damageLimit = self:GetAbility():GetSpecialValueFor("damage_limit")
	self.armorLoseFactor = self:GetAbility():GetSpecialValueFor("stats_lose_percent")*0.01
	
	self.damageBonusFromArmor = 0
	self.armorLose = 0
	
	self:StartIntervalThink(0.1)
	self:OnIntervalThink()
end

function modifier_item_lia_seal_of_power_damage:OnIntervalThink()
	local armor = self:GetCaster():GetPhysicalArmorValue() - self.armorLose --броню отнятую самим скиллом не учитываем
	
	self.damageBonusFromArmor = armor/self.oneArmorDamage
	
	if self.damageBonusFromArmor > self.damageLimit then
		self.damageBonusFromArmor = self.damageLimit
	end

	self.armorLose = -(self.damageBonusFromArmor*self.oneArmorDamage*self.armorLoseFactor)
	
	if IsServer() then
		self:SetStackCount(math.floor(self.damageBonusFromArmor+0.5))
	end
end

function modifier_item_lia_seal_of_power_damage:GetModifierPreAttack_BonusDamage(params)
	return self.damageBonus + self.damageBonusFromArmor
end

function modifier_item_lia_seal_of_power_damage:GetModifierPhysicalArmorBonus(params)
	return self.armorBonus + self.armorLose
end



---------------------------------------------------------------------------------------

