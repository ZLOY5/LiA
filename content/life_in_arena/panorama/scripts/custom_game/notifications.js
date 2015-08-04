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

(function () {
	GameEvents.Subscribe( "round_start", OnRoundStart );
})();

