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
		$.DispatchEvent("UIShowCustomLayoutTooltip", glyphButton, "GlyphTooltip", 
			"file://{resources}/layout/custom_game/glyph_tooltip.xml"); 
	}
}

function GlyphEnabled(event)
{
	glyphButton.enabled = event.enabled
}

function OnPlayerStateChanged(table, key, data)
{
	//$.Msg( "Table '", table, "' changed: '", key, "' = ", data );
	if (key == "Player"+Game.GetLocalPlayerID()) { 
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