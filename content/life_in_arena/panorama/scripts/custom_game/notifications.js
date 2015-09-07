"use strict";

var hint_scoreboard = false;
var show_hint = true;

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

/*function SetFlyoutScoreboardVisible( bVisible )
{
	visible = bVisible;
	$.GetContextPanel().SetHasClass( "flyout_scoreboard_visible", visible );
	show_hint = false;
}*/
 
function OnHintGet(dat)
{
	show_hint = !dat.hide;
	//$.Msg( "		show_hint = ", show_hint);
}

        
(function () { 
	GameEvents.Subscribe( "round_start", OnRoundStart );
	GameEvents.Subscribe( "duel_start", OnDuelStart ); 
	//
	//var childPanel = $.GetContextPanel().FindChildInLayoutFile( "LiANotification" );
	//var childPanel2 = childPanel.FindChildInLayoutFile( "LiaScoreboard" ) 
	//$.GetContextPanel().SetHasClass( "hint_active", false );
	//$.GetContextPanel().SetHasClass( "round_start", false );
	var delay;
	for (var i = 0; i < 10; ++i)
	{
		$.Schedule( 1.*i, function() 
						{
							if (show_hint)
							{
								if (hint_scoreboard)
									hint_scoreboard = false
								else
									hint_scoreboard = true;
								//childPanel.SetHasClass( "hint_active", hint_scoreboard );
								$.GetContextPanel().SetHasClass( "hint_active", hint_scoreboard );
								//$.GetContextPanel().SetHasClass( "hint_active", false );
								//$.GetContextPanel().SetHasClass( "hint_active", true );
								//$( "#LiaScoreboard_Text" ).SetDialogVariable( "nam", "dwqewqeq" );
							}
							else
								$.GetContextPanel().SetHasClass( "hint_active", false );

						}
		 );
	}
	//$.RegisterEventHandler( "DOTACustomUI_SetFlyoutScoreboardVisible", $.GetContextPanel(), SetFlyoutScoreboardVisible );
	GameEvents.Subscribe( "CustomUI_Set_forHint_Scoreboard", OnHintGet ); 
})();

