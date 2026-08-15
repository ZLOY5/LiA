-- Seal of Power — переключаемый предмет-конвертер статов.
-- OFF (по умолчанию) = режим Урона: броня -> урон, штраф к броне.
-- ON               = режим Брони: урон  -> броня, штраф к урону.
-- Числа и формулы сохранены от старой реализации; убраны 3 предмета + подмена через SwapItems.

item_lia_seal_of_power_shop = class({})
LinkLuaModifier("modifier_item_lia_seal_of_power_shop", "items/SealOfPower.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_seal_of_power_shop:GetIntrinsicModifierName()
	return "modifier_item_lia_seal_of_power_shop"
end

-- Мгновенный пересчёт при переключении режима (без ожидания тика).
function item_lia_seal_of_power_shop:OnToggle()
	local mod = self:GetCaster():FindModifierByName("modifier_item_lia_seal_of_power_shop")
	if mod then mod:OnIntervalThink() end
end

---------------------------------------------------------------------------------------

modifier_item_lia_seal_of_power_shop = class({})

function modifier_item_lia_seal_of_power_shop:GetAttributes() return MODIFIER_ATTRIBUTE_PERMANENT end
function modifier_item_lia_seal_of_power_shop:IsHidden()      return false end
function modifier_item_lia_seal_of_power_shop:IsPurgable()    return false end

function modifier_item_lia_seal_of_power_shop:OnCreated()
	local a = self:GetAbility()

	self.bonusDamage          = a:GetSpecialValueFor("bonus_damage")
	self.bonusArmor           = a:GetSpecialValueFor("bonus_armor")
	self.armorNeededForDamage = a:GetSpecialValueFor("armor_needed_for_one_damage") -- 0.5 (режим Урона)
	self.damageNeededForArmor = a:GetSpecialValueFor("damage_needed_for_one_armor") -- 20  (режим Брони)
	self.damageLimit          = a:GetSpecialValueFor("damage_limit")
	self.armorLimit           = a:GetSpecialValueFor("armor_limit")
	self.loseFactor           = a:GetSpecialValueFor("stats_lose_percent") * 0.01

	-- Активна всегда только одна пара (по режиму), вторая обнулена.
	self.damageFromArmor = 0 -- прибавка к урону в режиме Урона
	self.armorLose       = 0 -- штраф к броне  в режиме Урона (<=0)
	self.armorFromDamage = 0 -- прибавка к броне в режиме Брони
	self.damageLose      = 0 -- штраф к урону   в режиме Брони (<=0)

	self.abilityID = a:entindex()

	self:StartIntervalThink(0.1)
	self:OnIntervalThink()
end

function modifier_item_lia_seal_of_power_shop:OnIntervalThink()
	local a = self:GetAbility()
	if not a or a:IsNull() then return end
	local parent = self:GetParent()

	if IsServer() then
		if a:GetToggleState() then
			-- Режим Брони: урон -> броня
			local damage = math.floor(parent:GetAverageTrueAttackDamage(nil) - self.damageLose + 0.5)
			local armorFromDamage = damage / self.damageNeededForArmor
			if armorFromDamage > self.armorLimit then armorFromDamage = self.armorLimit end

			self.armorFromDamage = armorFromDamage
			self.damageLose      = math.floor(-(armorFromDamage * self.damageNeededForArmor * self.loseFactor) + 0.5)
			self.damageFromArmor = 0
			self.armorLose       = 0

			self:SetStackCount(math.floor(armorFromDamage + 0.5))
		else
			-- Режим Урона: броня -> урон (учитываем броню до штрафа самого предмета)
			local armor = parent:GetPhysicalArmorValue(false) - self.armorLose
			local damageFromArmor = armor / self.armorNeededForDamage
			if damageFromArmor > self.damageLimit then damageFromArmor = self.damageLimit end

			self.damageFromArmor = damageFromArmor
			self.armorLose       = -(damageFromArmor * self.armorNeededForDamage * self.loseFactor)
			self.armorFromDamage = 0
			self.damageLose      = 0

			self:SetStackCount(math.floor(damageFromArmor + 0.5))
		end

		CustomNetTables:SetTableValue("custom_modifier_state", tostring(self.abilityID), {
			damageFromArmor = self.damageFromArmor,
			armorLose       = self.armorLose,
			armorFromDamage = self.armorFromDamage,
			damageLose      = self.damageLose,
		})
	else
		local nt = CustomNetTables:GetTableValue("custom_modifier_state", tostring(self.abilityID))
		if nt then
			self.damageFromArmor = nt.damageFromArmor or 0
			self.armorLose       = nt.armorLose or 0
			self.armorFromDamage = nt.armorFromDamage or 0
			self.damageLose      = nt.damageLose or 0
		end
	end
end

function modifier_item_lia_seal_of_power_shop:DeclareFunctions()
	return {
		MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS,
	}
end

function modifier_item_lia_seal_of_power_shop:GetModifierPreAttack_BonusDamage()
	return self.bonusDamage + self.damageFromArmor + self.damageLose
end

function modifier_item_lia_seal_of_power_shop:GetModifierPhysicalArmorBonus()
	return self.bonusArmor + self.armorLose + self.armorFromDamage
end

function modifier_item_lia_seal_of_power_shop:OnDestroy()
	if IsServer() then
		CustomNetTables:SetTableValue("custom_modifier_state", tostring(self.abilityID), {})
	end
end
