function RuneOfStrength(event)
	event.caster:ModifyStrength(1)
	event.caster:CalculateStatBonus()
end

function RuneOfAgility(event)
	event.caster:ModifyAgility(1)
	event.caster:CalculateStatBonus()
end

function RuneOfIntellect(event)
	event.caster:ModifyIntellect(1)
	event.caster:CalculateStatBonus()
end

function RuneGold(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	hero:ModifyGold(100, false, DOTA_ModifyGold_Unspecified)
	SendOverheadEventMessage(hero:GetPlayerOwner(), OVERHEAD_ALERT_GOLD, hero, 100, nil )
end

function RuneLumber(event)
	local hero = PlayerResource:GetSelectedHeroEntity(event.caster:GetPlayerOwnerID())
	hero.lumber = hero.lumber + 2
	PopupNumbers(hero:GetPlayerOwner() ,hero, "gold", Vector(0,180,0), 3, 2, POPUP_SYMBOL_PRE_PLUS, nil)
end