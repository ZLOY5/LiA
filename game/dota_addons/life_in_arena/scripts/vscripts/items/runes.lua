function RuneOfStrength(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	hero:ModifyStrength(1)
	hero:CalculateStatBonus()
end

function RuneOfAgility(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	hero:ModifyAgility(1)
	hero:CalculateStatBonus()
end

function RuneOfIntellect(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	hero:ModifyIntellect(1)
	hero:CalculateStatBonus()
end

function RuneGold(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	hero:ModifyGold(100, false, DOTA_ModifyGold_Unspecified)
	SendOverheadEventMessage(hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, event.caster, 100, nil )
end

function RuneLumber(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	PlayerResource:ModifyLumber(hero:GetPlayerOwnerID(),2)
	PopupNumbers(hero:GetPlayerOwner() ,hero, "gold", Vector(0,180,0), 3, 2, POPUP_SYMBOL_PRE_PLUS, nil)
end

function _G.RuneOfProtection(event)
	local caster = event.caster

	local radius = event.ability:GetSpecialValueFor("radius")

	local targets = FindUnitsInRadius(caster:GetTeam(),caster:GetAbsOrigin(),nil,radius,DOTA_UNIT_TARGET_TEAM_FRIENDLY,DOTA_UNIT_TARGET_HERO,DOTA_UNIT_TARGET_FLAG_NONE,FIND_ANY_ORDER,false)

	--для работы модификатора обязательно нужна абилка
	local dummyItem = CreateItem("item_lia_rune_of_protection",nil,nil) 

	for _,unit in pairs(targets) do
		if not unit:HasModifier("modifier_item_sphere_target") then
			unit:AddNewModifier(unit, dummyItem, "modifier_item_sphere_target", {duration = -1})
			unit.current_spellblock_is_passive = nil
			unit:EmitSound("DOTA_Item.LinkensSphere.Target")
		end
	end

	Timers:CreateTimer(1,
		function() 
			for _,unit in pairs(targets) do
				local modifier = unit:FindModifierByName("modifier_item_sphere_target")
				if modifier and modifier:GetAbility() == dummyItem then 
					--print("Continue")
					return 1 
				end
			end
			--print("Destroy")
			dummyItem:RemoveSelf() --если модификатора больше нет ни на ком из героев, то уничтожаем абилку
		end)
end

-----------------------------------------------------------------------------------------------------------

runeOfLuck_itemList = {
    "item_lia_health_stone_potion",
	"item_lia_mana_stone_potion",
	"item_lia_health_elixir",
	"item_lia_mana_elixir",
    "item_lia_healing_ward",
    "item_lia_dust_of_appearance",
	"item_lia_anti_magic_potion",
	"item_lia_potion_of_invulnerability",
	"item_lia_potion_of_invisibility",
	"item_lia_scroll_of_restoration",
	"item_lia_scroll_of_secret_knowledge", 
	"item_lia_book_of_the_dead",
    "item_lia_boar",
	"item_lia_troll_defender",
    "item_lia_troll_healer",
	"item_lia_demonic_figurine",
}

function RuneOfLuck(event)
	local itemName = runeOfLuck_itemList[RandomInt(1,#runeOfLuck_itemList)]
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	hero:AddItemByName(itemName):SetPurchaseTime(0)
end

----------------------------------------------------------------------------------------------------------

item_lia_rune_of_lifesteal = class({})
LinkLuaModifier("modifier_item_lia_rune_of_lifesteal", "items/runes.lua", LUA_MODIFIER_MOTION_NONE)

function item_lia_rune_of_lifesteal:OnSpellStart()
	local modifierParam = {
		duration = self:GetSpecialValueFor("duration"),
	}
	self:GetCaster():AddNewModifier(self:GetCaster(), self, "modifier_item_lia_rune_of_lifesteal", modifierParam)
	Timers:CreateTimer(1, function() self:GetCaster():RemoveItem(self) end) 
	--если удалять сразу, то клиент не успевает правильно создать модификатор
	
end

----------------------------------------------------------------------------------------------------------

modifier_item_lia_rune_of_lifesteal = class({})

function modifier_item_lia_rune_of_lifesteal:GetAttributes()
	return MODIFIER_ATTRIBUTE_PERMANENT + MODIFIER_ATTRIBUTE_IGNORE_INVULNERABLE 
end

function modifier_item_lia_rune_of_lifesteal:GetTexture()
	return "rune_haste"
end

function modifier_item_lia_rune_of_lifesteal:GetEffectName()
	return "particles/econ/items/bloodseeker/bloodseeker_eztzhok_weapon/bloodseeker_bloodrage_ground_eztzhok.vpcf"
end

function modifier_item_lia_rune_of_lifesteal:GetEffectAttachType()
	return PATTACH_CUSTOMORIGIN_FOLLOW
end

function modifier_item_lia_rune_of_lifesteal:IsHidden()
	return false
end

function modifier_item_lia_rune_of_lifesteal:IsBuff()
	return true
end

function modifier_item_lia_rune_of_lifesteal:IsPurgable()
	return true
end

function modifier_item_lia_rune_of_lifesteal:DeclareFunctions()
	local funcs = {
					MODIFIER_EVENT_ON_ATTACK_LANDED,
					MODIFIER_EVENT_ON_TAKEDAMAGE,
					MODIFIER_PROPERTY_PREATTACK_BONUS_DAMAGE,
	}
	return funcs
end

function modifier_item_lia_rune_of_lifesteal:OnCreated(kv)
	self.lifestealPercent = self:GetAbility():GetSpecialValueFor("lifesteal_percent")
	self.bonusDamage = self:GetAbility():GetSpecialValueFor("bonus_damage")	
end

function modifier_item_lia_rune_of_lifesteal:GetModifierPreAttack_BonusDamage(params)
	return self.bonusDamage
end

function modifier_item_lia_rune_of_lifesteal:OnAttackLanded(params)
	if params.attacker == self:GetParent() and not params.target:IsBuilding() and params.target:GetTeam() ~= self:GetParent():GetTeam() then 
		self.lifesteal_record = params.record
	end
end

function modifier_item_lia_rune_of_lifesteal:OnTakeDamage(params)
	if params.record == self.lifesteal_record then
		local parent = self:GetParent()
		local heal = params.damage*self.lifestealPercent*0.01
		parent:Heal(heal, parent)
		SendOverheadEventMessage(parent:GetPlayerOwner(), OVERHEAD_ALERT_HEAL, parent, heal, nil)
	end
end

