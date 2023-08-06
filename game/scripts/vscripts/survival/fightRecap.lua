FightRecap = FightRecap or {
	data = { 
		players = {},
		isMegaboss = 0
	}
}

--[[PlayerEntry = {
	CreepsKilled = 25,
	BossesKilled = 2,
	Damage = 100,
	RecievedDamage = 100,
	Healed = 56,
	GoldRecieved = 264,
	UsedAbilities = { abi_name1 = 1, }
	UsedItems = { item_name1 = 1,}
}]]


function FightRecap:Init()
	for i = 0, DOTA_MAX_PLAYERS-1 do
        if PlayerResource:IsValidPlayerID(i) then
            self.data.players[i] = {
            	CreepsKilled = 0,
				BossesKilled = 0,
				Damage = 0,
				RecievedDamage = 0,
				Healed = 0,
				GoldRecieved = 0,
				UsedAbilities = {},
				UsedItems = {}
        }
        end
    end
end

function FightRecap:IncrementCreepKills(pID)
	self.data.players[pID].CreepsKilled = self.data.players[pID].CreepsKilled + 1
end

function FightRecap:IncrementBossKills(pID)
	self.data.players[pID].BossesKilled = self.data.players[pID].BossesKilled + 1
end

function FightRecap:AddDamage(pID,damage)
	self.data.players[pID].Damage = self.data.players[pID].Damage + damage
end

function FightRecap:AddRecievedDamage(pID,damage)
	self.data.players[pID].RecievedDamage = self.data.players[pID].RecievedDamage + damage
end

function FightRecap:AddHeal(pID,heal)
	self.data.players[pID].Healed = self.data.players[pID].Healed + heal
end

function FightRecap:AbilityUsed(pID,abiName)
	self.data.players[pID].UsedAbilities[abiName] = (self.data.players[pID].UsedAbilities[abiName] or 0) + 1
end

function FightRecap:ItemUsed(pID,abiName)
	self.data.players[pID].UsedItems[abiName] = (self.data.players[pID].UsedItems[abiName] or 0) + 1
end


function FightRecap:UpdateClientInfo(isMegaboss)
	self.data.isMegaboss = isMegaboss
	CustomNetTables:SetTableValue("lia_player_table","FightRecap",self.data)
end
 