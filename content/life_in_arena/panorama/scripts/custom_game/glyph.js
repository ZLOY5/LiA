"use strict";

var glyphButton

function GlyphClick()
{
	if (!Players.IsReadyToRound(Game.GetLocalPlayerID()))
		GameEvents.SendCustomGameEventToServer( "glyph_clicked", {} )
}

function GlyphTooltip() 
{
	if (glyphButton.enabled) {
		glyphButton.SetDialogVariableInt("readyPlayers", Players.GetNumPlayersReadyToRound());
		glyphButton.SetDialogVariableInt("numPlayers", Players.GetNumPlayers());
		$.DispatchEvent( 'DOTAShowTitleTextTooltip', glyphButton, "#GlyphTooltipTitle", "#GlyphTooltip");
	}
}

function GlyphEnabled(event)
{
	glyphButton.enabled = event.enabled
}

function OnPlayerStateChanged(table, key, data)
{
	//$.Msg( "Table '", table, "' changed: '", key, "' = ", data );
	if (key == Game.GetLocalPlayerID()) {
		if (data.readyToRound)
			glyphButton.AddClass("ReadyToRound")
		else
			glyphButton.RemoveClass("ReadyToRound");
	}	
}


(function()
{
	glyphButton = $.FindChildInContext("#GlyphButton");

	CustomNetTables.SubscribeNetTableListener("lia_player_table",OnPlayerStateChanged);
	GameEvents.Subscribe("round_force_enabled", GlyphEnabled);
})();