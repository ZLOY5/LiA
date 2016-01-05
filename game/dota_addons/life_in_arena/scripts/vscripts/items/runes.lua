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
	hero.lumber = hero.lumber + 2
	PopupNumbers(hero:GetPlayerOwner() ,hero, "gold", Vector(0,180,0), 3, 2, POPUP_SYMBOL_PRE_PLUS, nil)
end