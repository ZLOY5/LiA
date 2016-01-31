"use strict";

//var curr_lumber_need =-1;
//var curr_lumber =-1;
//var curr_proc =-1;
//var curr_finish = false;
var statePanelTrade = false;
//var hideInProcess = false;
var idHideInProcess = -1;
var staticStatusText = false;
var showHint = true;
var mig = false;

function ClickHide()
{
	if (statePanelTrade === true)
		statePanelTrade = false;
	else
		statePanelTrade = true;
	$.GetContextPanel().SetHasClass("could_vis", statePanelTrade);
	$.GetContextPanel().SetHasClass("closed", statePanelTrade);
	showHint = false;
}

function ShowH()
{
	var childPanel = $.GetContextPanel().FindChildInLayoutFile( "closedButton" );
	
	if (showHint)
	{
		if (!mig)
			mig = true;
		else
			mig = false;
		childPanel.SetHasClass( "miganie", mig );
		//$.Msg( "		ShowH= ", mig);
			
		//else
		//	childPanel.SetHasClass( "miganie", true );
	}
	else
		childPanel.SetHasClass( "miganie", false );
	
}

(function()
{
    //$.RegisterForUnhandledEvent( "DOTAAbility_LearnModeToggled", OnAbilityLearnModeToggled);

	/*GameEvents.Subscribe( "dota_portrait_ability_layout_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_selected_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_player_update_query_unit", UpdateAbilityList );
	GameEvents.Subscribe( "dota_ability_changed", UpdateAbilityList );
	GameEvents.Subscribe( "dota_hero_ability_points_changed", UpdateAbilityList );*/
	//
	//GameEvents.Subscribe( "upd_action_lumber", OnUpdAction ); 
	//GameEvents.Subscribe( "upd_action_getlumber", OnUpdActionGetLumber ); 
	//GameEvents.Subscribe( "upd_action_hide",  OnUpdActionHide);
	
	//var queryUnit = Players.GetLocalPlayerPortraitUnit();
	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), "dw", queryUnit );
	//$.DispatchEvent( "DOTAHideAbilityTooltip", $( "#attButton" ) );
	$.GetContextPanel().SetHasClass("could_vis", false);
	//
	//
	for (var i = 0; i < 26; ++i)
	{
		$.Schedule( 0.7*i, function()
						{
							ShowH();
						}
		 );
	}
	
	
	//
	//var childPanel1 = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu" );
	
	//childPanel1.SetHasClass( "show", true );
	//$.Msg( "		childPanelStatusUlu= ", childPanel1);
	//UpdateAbilityList(); // initial update
	
})();