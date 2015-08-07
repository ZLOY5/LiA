"use strict";

function OnRoundStart( msg )
{

	$.GetContextPanel().SetHasClass( "round_start", true );
	
	$( "#LiaRound_Number" ).SetDialogVariableInt( "round_number", msg.round_number );
	$( "#LiaRound_Name" ).SetDialogVariable( "round_name", $.Localize( "#round_name_"+msg.round_number ) );

	$.Schedule( 5, ClearRoundStartMessage );
}
		
function ClearRoundStartMessage()
{
	$.GetContextPanel().SetHasClass( "round_start", false );
}

function OnDuelStart( msg )
{

	$.GetContextPanel().SetHasClass( "duel_start", true );
	
	$( "#LiaDuel_Number" ).SetDialogVariable( "duel_num", $.Localize( "#Duel"+msg.duel_number ) );
	
	var hero_image_name = "file://{images}/heroes/" + msg.hero1 + ".png";
	$( "#LiaDuel_Hero1" ).SetImage( hero_image_name );

	var hero_image_name = "file://{images}/heroes/" + msg.hero2 + ".png";
	$( "#LiaDuel_Hero2" ).SetImage( hero_image_name );

	//$( "#LiaDuel_Text" ).SetDialogVariable( "hero1", $.Localize( "#"+msg.hero1 ) );
	//$( "#LiaDuel_Text" ).SetDialogVariable( "hero2", $.Localize( "#"+msg.hero2 ) );

	$.Schedule( 5, ClearDuelStartMessage );
}
		
function ClearDuelStartMessage()
{
	$.GetContextPanel().SetHasClass( "duel_start", false );
}

(function () {
	GameEvents.Subscribe( "round_start", OnRoundStart );
	GameEvents.Subscribe( "duel_start", OnDuelStart );
})();

