"use strict";  

/*
toastTypes
1 - Hero Kill = killerPlayer | killedPlayer | [gold] | [lumber] 
2 - Boss Kill = killerPlayer | gold | lumber
3 - Duel Draw = firstPlayer | secondPlayer | gold | lumber
4 - Resource transfer = from | to | [gold] | [lumber]

*/

function CreateToast(data) {
	var toastManager = $("#ToastManager")

 	var localPlayerID = Game.GetLocalPlayerID()

	var newToast = $.CreatePanel("Panel", toastManager,"")
	newToast.BLoadLayoutSnippet("CombatEventRow")
	newToast.AddClass("ToastVisible")

	var label = newToast.FindChildTraverse("EventLabel")

	if (data.eventType == 1) { //Hero Kill

		if ( (data.killerPlayer == localPlayerID) || (data.killedPlayer == localPlayerID) )
			newToast.AddClass("LocalPlayerInvolved")

		if (data.killerPlayer == localPlayerID) {
			newToast.AddClass("AllyEvent")
		}
		else if (data.killedPlayer == localPlayerID) {
			newToast.AddClass("EnemyEvent")
		}
		else {
			newToast.AddClass("NeutralEvent")
		}

		var heroKillerIcon = " <child id='heroKiller' > " 
		var playerKillerName = Players.GetPlayerName(data.killerPlayer)
		var killIcon = " <child id='killIcon' > "
		var heroKilledIcon = "<child id='heroKilled' > " 
		var playerKilledName = Players.GetPlayerName(data.killedPlayer)

		var killerColor = "<font color='"+GameUI.CustomUIConfig().players_color[data.killerPlayer]+"'>"
		var killedColor = "<font color='"+GameUI.CustomUIConfig().players_color[data.killedPlayer]+"'>"
		var colorEnd = "</font>"

		
		var icon = $.CreatePanel("Panel",label,"killIcon")
		icon.AddClass("CombatEventKillIcon")

		icon = $.CreatePanel("Image",label,"heroKiller")
		icon.AddClass("CombatEventHeroIcon")
		icon.SetImage("file://{images}/heroes/icons/"+Players.GetPlayerSelectedHero(data.killerPlayer)+".png")

		icon = $.CreatePanel("Image",label,"heroKilled")
		icon.AddClass("CombatEventHeroIcon")
		icon.SetImage("file://{images}/heroes/icons/"+Players.GetPlayerSelectedHero(data.killedPlayer)+".png")

		if (data.killerPlayer == -1) 
		var text = $.Localize("#Monsters") + colorEnd 
			+ killIcon 
			+ heroKilledIcon + killedColor + playerKilledName
		else
		var text = heroKillerIcon + killerColor + playerKillerName + colorEnd 
			+ killIcon 
			+ heroKilledIcon + killedColor + playerKilledName

		if (data.gold != null) {
			text = text + "  <font color='#ffd700'> " + data.gold + "<child id='goldIcon' > "

			icon = $.CreatePanel("Panel",label,"goldIcon")
			icon.AddClass("CombatEventGoldIcon")
		}

		if (data.lumber != null) {
			text = text + " <font color='#229B22'>" + data.lumber + "<child id='lumberIcon' > "

			icon = $.CreatePanel("Panel",label,"lumberIcon")
			icon.AddClass("CombatEventLumberIcon")
		}

		label.text = text
	}

	if (data.eventType == 2) {
		
		if (data.killerPlayer == localPlayerID) 
			newToast.AddClass("LocalPlayerInvolved")

		if (data.killerPlayer == localPlayerID) 
			newToast.AddClass("AllyEvent")
		else
			newToast.AddClass("NeutralEvent")
		
		var heroKillerIcon = " <child id='heroKiller' > " 
		var playerKillerName = Players.GetPlayerName(data.killerPlayer)
		var killIcon = " <child id='killIcon' > "

		var killerColor = "<font color='"+GameUI.CustomUIConfig().players_color[data.killerPlayer]+"'>"
		var colorEnd = "</font>"

		var icon = $.CreatePanel("Panel",label,"killIcon")
		icon.AddClass("CombatEventKillIcon")

		icon = $.CreatePanel("Image",label,"heroKiller")
		icon.AddClass("CombatEventHeroIcon")
		icon.SetImage("file://{images}/heroes/icons/"+Players.GetPlayerSelectedHero(data.killerPlayer)+".png")

		var text = heroKillerIcon + killerColor + playerKillerName + colorEnd 
			+ killIcon 
			+ $.Localize("#Boss")

		if (data.gold != null) {
			text = text + "  <font color='#ffd700'> " + data.gold + "<child id='goldIcon' > "

			icon = $.CreatePanel("Panel",label,"goldIcon")
			icon.AddClass("CombatEventGoldIcon")
		}

		if (data.lumber != null) {
			text = text + " <font color='#229B22'>" + data.lumber + "<child id='lumberIcon' > "

			icon = $.CreatePanel("Panel",label,"lumberIcon")
			icon.AddClass("CombatEventLumberIcon")
		}

		label.text = text
	}

	if (data.eventType == 3) {
		newToast.AddClass("DuelDrawEvent")

		var firstPlayerIcon = " <child id='firstPlayer' > " 
		var firstPlayerName = Players.GetPlayerName(data.firstPlayer)
		var Icon = " <child id='Icon' > "
		var secondPlayerIcon = "<child id='secondPlayer' > " 
		var secondPlayerName = Players.GetPlayerName(data.secondPlayer)

		var firstColor = "<font color='"+GameUI.CustomUIConfig().players_color[data.firstPlayer]+"'>"
		var secondColor = "<font color='"+GameUI.CustomUIConfig().players_color[data.secondPlayer]+"'>"
		var colorEnd = "</font>"

		
		var icon = $.CreatePanel("Panel",label,"Icon")
		icon.AddClass("DuelDrawIcon")

		icon = $.CreatePanel("Image",label,"firstPlayer")
		icon.AddClass("CombatEventHeroIcon")
		icon.SetImage("file://{images}/heroes/icons/"+Players.GetPlayerSelectedHero(data.firstPlayer)+".png")

		icon = $.CreatePanel("Image",label,"secondPlayer")
		icon.AddClass("CombatEventHeroIcon")
		icon.SetImage("file://{images}/heroes/icons/"+Players.GetPlayerSelectedHero(data.secondPlayer)+".png")

		var text = firstPlayerIcon + firstColor + firstPlayerName + colorEnd 
			+ Icon 
			+ secondPlayerIcon + secondColor + secondPlayerName

		if (data.gold != null) {
			text = text + "  <font color='#ffd700'> " + data.gold + "<child id='goldIcon' > "

			icon = $.CreatePanel("Panel",label,"goldIcon")
			icon.AddClass("CombatEventGoldIcon")
		}

		if (data.lumber != null) {
			text = text + " <font color='#229B22'>" + data.lumber + "<child id='lumberIcon' > "

			icon = $.CreatePanel("Panel",label,"lumberIcon")
			icon.AddClass("CombatEventLumberIcon")
		}

		label.text = text
	}

	if (data.eventType == 4) {
		newToast.AddClass("TradeEvent")

		var fromIcon = " <child id='firstPlayer' > " 
		var fromPlayerName = Players.GetPlayerName(data.from)
		var Icon = " <child id='Icon' > "
		var toPlayerIcon = "<child id='secondPlayer' > " 
		var toPlayerName = Players.GetPlayerName(data.to)

		var firstColor = "<font color='"+GameUI.CustomUIConfig().players_color[data.from]+"'>"
		var secondColor = "<font color='"+GameUI.CustomUIConfig().players_color[data.to]+"'>"
		var colorEnd = "</font>"

		
		var icon = $.CreatePanel("Panel",label,"Icon")
		icon.AddClass("TradeIcon")

		icon = $.CreatePanel("Image",label,"firstPlayer")
		icon.AddClass("CombatEventHeroIcon")
		icon.SetImage("file://{images}/heroes/icons/"+Players.GetPlayerSelectedHero(data.from)+".png")

		icon = $.CreatePanel("Image",label,"secondPlayer")
		icon.AddClass("CombatEventHeroIcon")
		icon.SetImage("file://{images}/heroes/icons/"+Players.GetPlayerSelectedHero(data.to)+".png")

		var text = fromIcon + firstColor + fromPlayerName + colorEnd 
			+ Icon 
			+ toPlayerIcon + secondColor + toPlayerName

		if (data.gold != null) {
			text = text + "  <font color='#ffd700'> " + data.gold + "<child id='goldIcon' > "

			icon = $.CreatePanel("Panel",label,"goldIcon")
			icon.AddClass("CombatEventGoldIcon")
		}

		if (data.lumber != null) {
			text = text + " <font color='#229B22'>" + data.lumber + "<child id='lumberIcon' > "

			icon = $.CreatePanel("Panel",label,"lumberIcon")
			icon.AddClass("CombatEventLumberIcon")
		}

		label.text = text
	}

	
	$.Schedule(10,function() { newToast.RemoveClass("ToastVisible"); newToast.AddClass("Collapse")})

}


(function()
{
	var dotaHud = $.GetContextPanel().GetParent().GetParent().GetParent()
	var dotaCombatEvents = dotaHud.FindChildTraverse("combat_events")
	dotaCombatEvents.style.visibility = "collapse"

	GameEvents.Subscribe( "lia_create_toast", CreateToast );

	var toastManager = $("#ToastManager")
	
	function Reveal() {
		$.GetContextPanel().SetHasClass("RevealCollapsed", dotaCombatEvents.BHasClass("RevealCollapsed"))
		$.GetContextPanel().hittest = dotaCombatEvents.BHasClass("RevealCollapsed")

		toastManager.SetHasClass("RevealCollapsed", dotaCombatEvents.BHasClass("RevealCollapsed"))
		toastManager.SetHasClass("SkipTransition", dotaCombatEvents.BHasClass("RevealCollapsed"))
		
		$.Schedule(0.03,Reveal)
	}
	Reveal()

})();


/*
CreateToast({
	eventType: 1,
	killerPlayer: Game.GetLocalPlayerID(),
	killedPlayer: 1,
	gold: 200,
	lumber: 8
})

CreateToast({
	eventType: 1,
	killerPlayer: 1,
	killedPlayer: Game.GetLocalPlayerID(),
	gold: 200,
	lumber: 8
})

CreateToast({
	eventType: 1,
	killerPlayer: -1,
	killedPlayer: 2
})

CreateToast({
	eventType: 1,
	killerPlayer: -1,
	killedPlayer: 0
})

CreateToast({
	eventType: 2,
	killerPlayer: 0,
	gold: 24,
	lumber: 3
})

CreateToast({
	eventType: 2,
	killerPlayer: 1,
	gold: 25,
	lumber: 3
})

CreateToast({
	eventType: 3,
	firstPlayer: 0,
	secondPlayer: 1,
	gold: 100,
	lumber: 4
})

CreateToast({
	eventType: 4,
	from: 0,
	to: 1,
	gold: 123,
	lumber: 13
})

CreateToast({
	eventType: 4,
	from: 0,
	to: 1,
	lumber: 13
})
*/