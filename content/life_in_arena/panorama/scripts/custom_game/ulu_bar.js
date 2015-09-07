"use strict";

var curr_lumber_need =-1;
var curr_lumber =-1;
var curr_proc =-1;
var curr_finish = false;
var statePanelUlu = false;
//var hideInProcess = false;
var idHideInProcess = -1;
var staticStatusText = false;
var showHint = true;
var mig = false;

/*
9 lvls all


attack 10,20,30...
need lumber 2,3,4...

armor
2,4,6,8...
2,3,4,5... lumber



att speed %
5, 15, 25, 35, 
lumber 1, 2, 3, 4...

mana regen %
10, 25, 40, 55
1,2,3,4... lumber

regen hp %
20,45, 70, 95...
1,2,3,4...
(mb replace on regen hp points, example 1.5, 3, 4.5 ...)

mana points
25, 75, 125, 175,
1,2,3,4

hp
50, 125, 200, 275,
1,2,3,4




*/


function ClickArmor()
{
	/*var abilityListPanel = $( "#ability_list" );
	if ( !abilityListPanel )
		return;*/

	var name = "armor"
	//var queryUnit = Players.GetLocalPlayerPortraitUnit();

	// see if we can level up
	//var nRemainingPoints = Entities.GetAbilityPoints( queryUnit );
	//var bPointsToSpend = ( nRemainingPoints > 0 );
	//var bControlsUnit = Entities.IsControllableByPlayer( queryUnit, Game.GetLocalPlayerID() );
	//$.GetContextPanel().SetHasClass( "could_level_up", ( bControlsUnit && bPointsToSpend ) );
	
	
	// send to server main command
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command", { "idPlayer" : Game.GetLocalPlayerID(), "nameUlu" : name } ); //, "Y" : GamePos[1], "Z" : GamePos[2]

}

function ClickAttack()
{
	var name = "attack"
	// send to server main command
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command", { "idPlayer" : Game.GetLocalPlayerID(), "nameUlu" : name } );
}

function ClickAttackSpeed()
{
	var name = "attackSpeed"
	// send to server main command
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command", { "idPlayer" : Game.GetLocalPlayerID(), "nameUlu" : name } );
}

function ClickhpPoints()
{
	var name = "hpPoints"
	// send to server main command
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command", { "idPlayer" : Game.GetLocalPlayerID(), "nameUlu" : name } );
}

function ClickmpPoints()
{
	var name = "mpPoints"
	// send to server main command
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command", { "idPlayer" : Game.GetLocalPlayerID(), "nameUlu" : name } );
}

function ClickhpRegen()
{
	var name = "hpRegen"
	// send to server main command
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command", { "idPlayer" : Game.GetLocalPlayerID(), "nameUlu" : name } );
}

function ClickmpRegen()
{
	var name = "mpRegen"
	// send to server main command
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command", { "idPlayer" : Game.GetLocalPlayerID(), "nameUlu" : name } );
}



function ClickHide()
{
	if (statePanelUlu === true)
		statePanelUlu = false;
	else
		statePanelUlu = true;
	$.GetContextPanel().SetHasClass("could_vis", statePanelUlu);
	showHint = false;
}

function StaticText()
{
	var childPanel1 = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu_Text" );
	if (curr_finish)
		childPanel1.text = $.Localize( "#LiaUluFinish" );
	else
		childPanel1.text = $.Localize( "#LiaUluPrice" ) + curr_lumber_need + $.Localize( "#LiaUluPrice2" );
	staticStatusText = true;
	//$.Msg( "		StaticText name = ", name);
}

function StaticText2()
{
	var childPanel1 = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu_Text" );
	childPanel1.text = $.Localize( "#LiaUluInLum" ) ; // + curr_lumber
	staticStatusText = true;
	//$.Msg( "		StaticText name = ", name);
}

function StaticText3()
{
	var childPanel1 = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu_Text" );
	childPanel1.text = $.Localize( "#LiaUluInProc" ) ; // + curr_proc
	staticStatusText = true;
	//$.Msg( "		StaticText name = ", name);
}

function ShowTooltipLumber()
{
	//var localNeed = -1;
	//
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	//
	//GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "armor" } );
	$.Schedule( 0.0, StaticText2);
	//StaticText2;
}

function ShowTooltipProc()
{
	//var localNeed = -1;
	//
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	//
	//GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "armor" } );
	$.Schedule( 0.0, StaticText3);
	//StaticText3;
}

function AbilityShowTooltipArmor()
{
	//var localNeed = -1;
	//
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);				//GetPlayerHeroEntityIndex( nPlayerID )
	var abilityButton = $( "#defButton" );
	var abilityName = "ulu_hero_armor";//Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, heroEntId );
	//
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "armor" } );
	$.Schedule( 0.05, StaticText);
	
}

function AbilityHideTooltipArmor()
{
	var abilityButton = $( "#defButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}

function AbilityShowTooltipAttack()
{
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);				//GetPlayerHeroEntityIndex( nPlayerID )
	var abilityButton = $( "#attButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
	var abilityName = "ulu_hero_attack";//Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, heroEntId );
	//
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "attack" } );
	$.Schedule( 0.05, StaticText);
}

function AbilityHideTooltipAttack()
{
	var abilityButton = $( "#attButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}

function AbilityShowTooltipAttackSpeed()
{
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);				//GetPlayerHeroEntityIndex( nPlayerID )
	var abilityButton = $( "#attSpeedButton" );
	var abilityName = "ulu_hero_attack_speed";//Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, heroEntId );
	//
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "attackSpeed" } );
	$.Schedule( 0.05, StaticText);
}

function AbilityHideTooltipAttackSpeed()
{
	var abilityButton = $( "#attSpeedButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}

function AbilityShowTooltiphpPoints()
{
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);				//GetPlayerHeroEntityIndex( nPlayerID )
	var abilityButton = $( "#hpPointsButton" );
	var abilityName = "ulu_hero_hp_points";//Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, heroEntId );
	//
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "hpPoints" } );
	$.Schedule( 0.05, StaticText);
}

function AbilityHideTooltiphpPoints()
{
	var abilityButton = $( "#hpPointsButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}


function AbilityShowTooltipmpPoints()
{
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);				//GetPlayerHeroEntityIndex( nPlayerID )
	var abilityButton = $( "#mpPointsButton" );
	var abilityName = "ulu_hero_mana_points";//Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, heroEntId );
	//
	//$.Msg( "		AbilityShowTooltipmpPoints name = mpPoints");
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "mpPoints" } );
	$.Schedule( 0.05, StaticText);
}

function AbilityHideTooltipmpPoints()
{
	var abilityButton = $( "#mpPointsButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}


function AbilityShowTooltiphpRegen()
{
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);				//GetPlayerHeroEntityIndex( nPlayerID )
	var abilityButton = $( "#hpRegenButton" );
	var abilityName = "ulu_hero_hp_regen";//Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, heroEntId );
	//
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "hpRegen" } );
	$.Schedule( 0.05, StaticText);
}

function AbilityHideTooltiphpRegen()
{
	var abilityButton = $( "#hpRegenButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}


function AbilityShowTooltipmpRegen()
{
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);				//GetPlayerHeroEntityIndex( nPlayerID )
	var abilityButton = $( "#mpRegenButton" );
	var abilityName = "ulu_hero_mana_regen";//Abilities.GetAbilityName( m_Ability );
	$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", abilityButton, abilityName, heroEntId );
	//
	GameEvents.SendCustomGameEventToServer( "apply_ulu_command_getlumber", { "idPlayer" : localPlayerId, "nameUlu" : "mpRegen" } );
	$.Schedule( 0.05, StaticText);
}

function AbilityHideTooltipmpRegen()
{
	var abilityButton = $( "#mpRegenButton" );
	$.DispatchEvent( "DOTAHideAbilityTooltip", abilityButton );
}


/*function GetResult( res)
{
    $.Msg( "		GetResult res= ", res);
	curr_lumber = res;
	//
	// can we upgrade ?
	//
	var queryUnit = Players.GetLocalPlayerPortraitUnit();
	var ability = Entities.GetAbility( queryUnit, 5 ); // 5 - armor
	
	
	if (curr_lumber >= 1)//+ Abilities.GetLevel(ability) )
	{
		Abilities.SetLevel(ability,Abilities.GetLevel(ability)+1);
		
	}
	$.Msg( "		GetResult Abilities.GetLevel(ability)= ", Abilities.GetLevel(ability));
	 
	
	//$.Msg( "		GetResult = b", b);
    //exec_result = res;
}*/

/*function _SetTextSafe( panel, childName, textValue )
{
	if ( panel === null )
		return;
	var childPanel = panel.FindChildInLayoutFile( childName )
	if ( childPanel === null )
		return;
	
	childPanel.text = textValue;
}*/

function OnUpdAction( dataL )
{
	var locallumber = -1;
	var localpercUlu = -1;
	var localDone = -1;
	var localNeed = -1;
	//
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	//
	if (localPlayerId !== dataL.UluPlayerId)
	{
		return;
	}
	//var tPlayersId = dataL.PlayersId
	//$.Msg( "		tPlayersId= ", tPlayersId.length);
	//for ( var i = 0; i < tPlayersId.length; ++i )
	//for ( var playerId of dataL.PlayersId )
	/*for ( var i = 1; i <= 8; ++i )
	{
		if (dataL.PlayersId[i] === localPlayerId)
		{*/
	locallumber = dataL.Lumber;
	localpercUlu = dataL.PercUlu;
	localDone = dataL.UluDone;
	localNeed = dataL.UluNeed;
	var localUpd = dataL.OnlyUpd;
	var localFinish = dataL.Finish;
	var localName = dataL.Name;
	//	}
	//}
	if (localUpd)
	{
		var childPanel3 = $.GetContextPanel().FindChildInLayoutFile( "valueLumber" );
		//$.Msg( "		childPanel3= ", childPanel3);
		childPanel3.text = locallumber; //"\n"
		var childPanel4 = $.GetContextPanel().FindChildInLayoutFile( "valueProc" );
		childPanel4.text = localpercUlu.toFixed(1)+"%"; //
		return;
	}
	//
	//	$( "#LiaNoUlu" ).SetDialogVariable( "xm", $.Localize( "вцв" ));
	//var childPanelMain = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu" );
	staticStatusText = false;
	var childPanel1 = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu_Text" );
	//
	//localName
	var aButton
	if (localName === "armor")
		aButton = $( "#defButton" );
	if (localName === "attack")
		aButton = $( "#attButton" );
	if (localName === "attackSpeed")
		aButton = $( "#attSpeedButton" );
	if (localName === "hpPoints")
		aButton = $( "#hpPointsButton" );
	if (localName === "mpPoints")
		aButton = $( "#mpPointsButton" );
	if (localName === "hpRegen")
		aButton = $( "#hpRegenButton" );
	if (localName === "mpRegen")
		aButton = $( "#mpRegenButton" );
	//
	var abilityName
	if (localFinish)
	{
		childPanel1.text = $.Localize( "#LiaUluFinish" );
		//
		//aButton.disabled = true;
		aButton.enabled = false;
		aButton.SetHasClass( "enabledButton", true );
		//$.Msg( "	aButton= ", aButton);
		//
	}
	else
	{
		if (!localDone)
			childPanel1.text = $.Localize( "#LiaUluNoName" ) + localNeed;
		else
		{
			childPanel1.text = $.Localize( "#LiaUluUpd" );
			//
		}
			
		//var childPanel1 = $.GetContextPanel().FindChildInLayoutFile( "menu" );
		//var childPanel2 = childPanel1.FindChildInLayoutFile( "mLumber" );
		var childPanel3 = $.GetContextPanel().FindChildInLayoutFile( "valueLumber" );
		//$.Msg( "		childPanel3= ", childPanel3);
		childPanel3.text = locallumber; //"\n"
		var childPanel4 = $.GetContextPanel().FindChildInLayoutFile( "valueProc" );
		childPanel4.text = localpercUlu.toFixed(1)+"%"; //
		//_SetTextSafe($.GetContextPanel(),"value",dataL.Lumber);
		//$.Msg( "		OnUpdAction= ", dataL);
		//aButton.SetHasClass( "defButtonO", true );
	}
	if (localDone)
	{
		if (localName === "armor")
			abilityName = "ulu_hero_armor";
		if (localName === "attack")
			abilityName = "ulu_hero_attack";
		if (localName === "attackSpeed")
			abilityName = "ulu_hero_attack_speed";
		if (localName === "hpPoints")
			abilityName = "ulu_hero_hp_points";
		if (localName === "mpPoints")
			abilityName = "ulu_hero_mana_points";
		if (localName === "hpRegen")
			abilityName = "ulu_hero_hp_regen";
		if (localName === "mpRegen")
			abilityName = "ulu_hero_mana_regen";
		
		//
		var heroEntId = Players.GetPlayerHeroEntityIndex(localPlayerId);
		$.DispatchEvent( "DOTAHideAbilityTooltip", aButton );
		$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", aButton, abilityName, heroEntId );
	}
		


//else
//	childPanel1.text = $.Localize( "#LiaUluNoName" );
	//$.Msg( "		childPanel1= ", childPanel1);
	//childPanelMain.SetHasClass( "unshow", true );
	//var childPanel2 = childPanel1.FindChildInLayoutFile( "StatusUlu_Text" );
	//$.Msg( "		childPanel2= ", childPanel2);
	
	//childPanel2.SetDialogVariable( "uluno", $.Localize( "#dw" ) );
//if (hideInProcess === false)
//{
	//hideInProcess = true;
	idHideInProcess = idHideInProcess +1;
	var locIn = idHideInProcess;
	$.Schedule( 2, function()
					{
						ClearMessage(locIn)
					}
	 );
	 //$.Msg( "	send	locIn= ", locIn);
//}
	

}

/*function ClearMessage(hideInProces)
{
	if (hideInProces)
		return;
	$.Schedule( 1.0, ClearMessage2 );

}*/
function ClearMessage(idHideInProc)
{
	//$.Msg( "		idHideInProc= ", idHideInProc);
	//$.Msg( "		idHideInProcess= ", idHideInProcess);
	if ((idHideInProc !== idHideInProcess) || (staticStatusText))
		return;
	var childPanelMain = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu" );
	var childPanel1 = $.GetContextPanel().FindChildInLayoutFile( "StatusUlu_Text" );
	childPanel1.text = "                  ";
	idHideInProcess = -1;
	//hideInProcess = false;
	//childPanelMain.SetHasClass( "unshow", true );
}

 
//
function OnUpdActionGetLumber( dataGL )
{
	var localPlayer = Game.GetLocalPlayerInfo();
	var localPlayerId = -1;
	if ( localPlayer )
	{
		localPlayerId = localPlayer.player_id;
	}
	//
	/*if (localPlayerId !== dataL.UluPlayerId)
	{
		return;
	}*/
	curr_lumber_need = dataGL.NeedLumber;
	curr_lumber = dataGL.CurrLumber;
	curr_proc = dataGL.CurrProc;
	curr_finish = dataGL.Finish;
	
	//$.Msg( "		childPanelStatusUlu= ", childPanel1);
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
 
function OnUpdActionHide( dataHide )
{
	//$.GetContextPanel().SetHasClass("could_vis", dataHide.visible);
	//aButton = $( "#closedButton" );
	//aButton.enabled = false;
	
	//SetFlyoutScoreboardVisible( dataHide.visible );
	//$.Msg( "                  				OnUpdActionHide    " );
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
	GameEvents.Subscribe( "upd_action_lumber", OnUpdAction ); 
	GameEvents.Subscribe( "upd_action_getlumber", OnUpdActionGetLumber ); 
	//GameEvents.Subscribe( "upd_action_hide",  OnUpdActionHide);
	
	//var queryUnit = Players.GetLocalPlayerPortraitUnit();
	//$.DispatchEvent( "DOTAShowAbilityTooltipForEntityIndex", $.GetContextPanel(), "dw", queryUnit );
	//$.DispatchEvent( "DOTAHideAbilityTooltip", $( "#attButton" ) );
	$.GetContextPanel().SetHasClass("could_vis", false);
	//
	//
	for (var i = 0; i < 16; ++i)
	{
		$.Schedule( 0.5*i, function()
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

