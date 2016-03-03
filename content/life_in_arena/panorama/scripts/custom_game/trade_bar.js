"use strict";


var statePanelTrade = false;


function ClickHide()
{
	if (statePanelTrade === true)
		statePanelTrade = false;
	else
		statePanelTrade = true;
	$.GetContextPanel().SetHasClass("could_vis", statePanelTrade);
	$.GetContextPanel().SetHasClass("closed", statePanelTrade);
}

function ColorChange()
{
	var dropDown = $.FindChildInContext("#HeroPick");
	var PlayerID = dropDown.GetSelected().GetAttributeInt("player_id", -1)
	var playerColor = GameUI.CustomUIConfig().players_color[PlayerID];
	var backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( ' + playerColor + '00 ), to( ' + playerColor + '50 ) );'
	dropDown.style.backgroundColor = backgroundColor;
}




(function()
{
	var dropDown = $.FindChildInContext("#HeroPick");
	//dropDown.RemoveAllOptions();
	var isFirstPlayer = true
	for (var PlayerID of Game.GetAllPlayerIDs()) {
		
		if (Players.IsValidPlayerID(PlayerID) && Game.GetLocalPlayerID() != PlayerID) {
			var PlayerPanel = $.CreatePanel("Label", dropDown, "player"+PlayerID);
			var playerColor = GameUI.CustomUIConfig().players_color[PlayerID];
			var backgroundColor = 'gradient( linear, 100% 0%, 0% 0%, from( ' + playerColor + '00 ), to( ' + playerColor + '50 ) );'
			var heroName = $.Localize("#"+Entities.GetUnitName(Players.GetPlayerHeroEntityIndex(PlayerID)));
			dropDown.AddOption(PlayerPanel);
			PlayerPanel.SetAttributeInt("player_id", PlayerID);
			PlayerPanel.text = Players.GetPlayerName(PlayerID)+' | '+ heroName +'';
			PlayerPanel.style.backgroundColor = backgroundColor;
			if (isFirstPlayer) {
				dropDown.SetSelected(PlayerPanel);
				dropDown.style.backgroundColor = backgroundColor;
				isFirstPlayer = false;
			}

		}
	}



})();