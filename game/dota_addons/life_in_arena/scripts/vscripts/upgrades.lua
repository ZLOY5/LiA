if not Upgrades then
	Upgrades = {}
	Upgrades.info = LoadKeyValues("scripts/kv/upgrades.kv")

	LinkLuaModifier("modifier_upgrades","upgrades.lua",LUA_MODIFIER_MOTION_NONE)

	if IsServer() then 
		Upgrades.playersData = {}
	end
end

if IsServer() then

	function Upgrades:GetPlayerCurrentBonus(playerID,upgradeName)
		local level = Upgrades:GetPlayerUpgradeLevel(playerID,upgradeName)

		if level > 0 then
			return Upgrades:GetBonus(upgradeName,level)
		end
		return 0
	end

	function Upgrades:GetPlayerUpgradeLevel(playerID,upgradeName)
		return Upgrades.playersData[playerID] and Upgrades.playersData[playerID][upgradeName] or 0
	end

	function Upgrades:UpgradeRequest(data)
		local playerID = data.PlayerID
		local upgradeName = data.upgradeName
		--print("UpgradeRequest",playerID,upgradeName)

		local plUpgradeLevel = Upgrades:GetPlayerUpgradeLevel(playerID,upgradeName)

		local lumberCost = Upgrades:GetLumberCost(upgradeName,plUpgradeLevel)
		--print(playerID,upgradeName,plUpgradeLevel)
		if plUpgradeLevel < Upgrades:GetMaxLevel(upgradeName) then

			if PlayerResource:GetLumber(playerID) >= lumberCost then
				PlayerResource:ModifyLumber(playerID,-lumberCost)
				CustomPlayerResource.data[playerID].lumberSpent = CustomPlayerResource.data[playerID].lumberSpent + lumberCost

				Upgrades.playersData[playerID][upgradeName] = Upgrades.playersData[playerID][upgradeName] + 1

				CustomNetTables:SetTableValue("lia_player_table","UpgradesPlayer"..playerID,Upgrades.playersData[playerID])	
				PlayerResource:GetSelectedHeroEntity(playerID):AddNewModifier(nil,nil,"modifier_upgrades",nil)
			end
		end

	end

	function Upgrades:InitPlayer(playerID)
		Upgrades.playersData[playerID] = {}
		for upgradeName,_ in pairs(Upgrades.info) do
			Upgrades.playersData[playerID][upgradeName] = 0 --уровень улучшения
		end
		CustomNetTables:SetTableValue("lia_player_table","UpgradesPlayer"..playerID,Upgrades.playersData[playerID])	
	    --DeepPrintTable(Upgrades)
	end

	function Upgrades:Init()
		CustomNetTables:SetTableValue("upgrades","info",Upgrades.info) --Panorama
		CustomGameEventManager:RegisterListener("upgrade_request", Dynamic_Wrap(Upgrades,'UpgradeRequest') )
	end

end

-------------------------------

if IsClient() then

	function Upgrades:GetPlayerCurrentBonus(playerID,upgradeName)
		local level = Upgrades:GetPlayerUpgradeLevel(playerID,upgradeName)

		if level > 0 then
			return Upgrades:GetBonus(upgradeName,level)
		end
		return 0
	end

	function Upgrades:GetPlayerUpgradeLevel(playerID,upgradeName)
		local playerUpgrades = CustomNetTables:GetTableValue("lia_player_table","UpgradesPlayer"..playerID)
		return playerUpgrades and playerUpgrades[upgradeName] or 0
	end

end

----------------------------------

function Upgrades:GetMaxLevel(upgradeName)
	return Upgrades.info[upgradeName]["MaxLevel"]
end

function Upgrades:GetLumberCost(upgradeName,level)
	return Upgrades.info[upgradeName]["InitialLumberCost"]+ Upgrades.info[upgradeName]["LumberCostPerLevel"]*level
end

function Upgrades:GetBonus(upgradeName,level)
	return Upgrades.info[upgradeName]["BonusPerLevel"]*level
end


------------------------------------------------------------------------------------------------

modifier_upgrades = class({})

function modifier_upgrades:IsHidden()
	return true
end

function modifier_upgrades:IsPurgable()
	return false
end

function modifier_upgrades:RemoveOnDeath()
	return false
end

function modifier_upgrades:DeclareFunctions()
	local funcs = {
		MODIFIER_PROPERTY_BASEATTACK_BONUSDAMAGE,
		MODIFIER_PROPERTY_ATTACKSPEED_BONUS_CONSTANT,
		MODIFIER_PROPERTY_HEALTH_BONUS,
		MODIFIER_PROPERTY_HEALTH_REGEN_CONSTANT,
		MODIFIER_PROPERTY_MANA_BONUS,
		MODIFIER_PROPERTY_MANA_REGEN_PERCENTAGE,
		MODIFIER_PROPERTY_PHYSICAL_ARMOR_BONUS_ILLUSIONS
	}
	return funcs
end

function modifier_upgrades:GetModifierBaseAttack_BonusDamage()
	return self.attackBonus
end

function modifier_upgrades:GetModifierAttackSpeedBonus_Constant()
	return self.attackSpeedBonus
end

function modifier_upgrades:GetModifierHealthBonus()
	return self.healthBonus
end

function modifier_upgrades:GetModifierConstantHealthRegen()
	return self.healthRegenBonus
end

function modifier_upgrades:GetModifierManaBonus()
	return self.manaBonus
end

function modifier_upgrades:GetModifierPercentageManaRegen()
	return self.manaRegenBonus
end

function modifier_upgrades:GetModifierPhysicalArmorBonusIllusions()
	return self.armorBonus
end

function modifier_upgrades:OnCreated(kv)
	local playerID = self:GetParent():GetPlayerOwnerID()

	self.attackBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_attack_damage")
	self.attackSpeedBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_attack_speed")
	self.healthBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_health")
	self.healthRegenBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_health_regen")
	self.manaBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_mana")
	self.manaRegenBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_mana_regen")
	self.armorBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_armor")
end

function modifier_upgrades:OnRefresh(kv)
	local playerID = self:GetParent():GetPlayerOwnerID()

	self.attackBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_attack_damage")
	self.attackSpeedBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_attack_speed")
	self.healthBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_health")
	self.healthRegenBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_health_regen")
	self.manaBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_mana")
	self.manaRegenBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_mana_regen")
	self.armorBonus = Upgrades:GetPlayerCurrentBonus(playerID,"upgrade_armor")
end