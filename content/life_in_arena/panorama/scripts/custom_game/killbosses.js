"use strict";

//var time_tick = -1;
var t;

var curr_data = {};
var curr_time_tick;
var idHideInProcess1 = -1;
var idHideInProcess2 = -1;
var del = 8;

//var playerColor = [ "#3455FF","#3DD296","#8C2AF4","#F3C909","#FF6C00","#C54DA8","#C7E40D","#1BC0D8"]

function UpdateLiaKillBoss1(data)
{		
		curr_time_tick = Game.Time();
		curr_data[1] = data
		
		$.GetContextPanel().SetHasClass( "kill_start1", true );
		
		var playerInfo = Game.GetPlayerInfo( curr_data[1].pID );
		
		var playerPortrait = $( "#LiaKillBoss1" ).FindChildInLayoutFile( "HeroIcon" );
		playerPortrait.heroname = playerInfo.player_selected_hero;

		var textCont = $( "#LiaKillBoss1" ).FindChildInLayoutFile( "LiaKillBoss_Text" );
		textCont.text = playerInfo.player_name; 
		textCont.style.color = GameUI.CustomUIConfig().players_color[curr_data[1].pID];

		//textCont2 = $( "#LiaKillBoss2" ).FindChildInLayoutFile( "LiaKillBoss_Text2" );
		//textCont2.text = $.Localize( "#LiaKillBoss" ); 
		var delay = del - (curr_time_tick - data.create_time)
		idHideInProcess1 = idHideInProcess1 + 1;
		var locIn1 = idHideInProcess1
		$.Schedule( delay, function() { ClearKillStart1Message(locIn1) }  );
}

function UpdateLiaKillBoss2(data)
{		
		curr_data[2] = data
		
		$.GetContextPanel().SetHasClass( "kill_start2", true );
		
		var playerInfo = Game.GetPlayerInfo( curr_data[2].pID );
		
		var playerPortrait = $( "#LiaKillBoss2" ).FindChildInLayoutFile( "HeroIcon" );
		playerPortrait.heroname = playerInfo.player_selected_hero;

		var textCont = $( "#LiaKillBoss2" ).FindChildInLayoutFile( "LiaKillBoss_Text" );
		textCont.text = playerInfo.player_name; 
		textCont.style.color = GameUI.CustomUIConfig().players_color[curr_data[2].pID];

		//textCont2 = $( "#LiaKillBoss2" ).FindChildInLayoutFile( "LiaKillBoss_Text2" );
		//textCont2.text = $.Localize( "#LiaKillBoss" ); 
		
		//idHideInProcess2 = idHideInProcess2 + 1;
		//var locIn2 = idHideInProcess2
		//$.Schedule( del, function() { ClearKillStart2Message(locIn2) }  );
}

function OnHintKillBoss(data)
{
	data.create_time = Game.Time();

	if (curr_data[1] == null) {
		
		UpdateLiaKillBoss1(data)

	} else if (curr_data[2] == null) {

		UpdateLiaKillBoss2(data)

	} else {

		// если обе записи заняты, то самую старую просто убираем
		UpdateLiaKillBoss1(curr_data[2]) 
		UpdateLiaKillBoss2(data)

	}

	
}

function ClearKillStart1Message(idHideInProc) 
{
	//$.Msg("ClearKillStart1Message")
	if (idHideInProc !== idHideInProcess1)
		return;

	if (curr_data[2] != null) {
	
		var data = curr_data[1]
		UpdateLiaKillBoss1(curr_data[2])
		UpdateLiaKillBoss2(data)
		ClearKillStart2Message(idHideInProcess2)
	
	} else {
		
		$.GetContextPanel().SetHasClass( "kill_start1", false );
		idHideInProcess1 = -1;
		curr_data[1] = null;
	}
}

function ClearKillStart2Message(idHideInProc) 
{
	//$.Msg("ClearKillStart2Message")
	curr_data[2] = null;
	$.GetContextPanel().SetHasClass( "kill_start2", false );
}


(function () { 
	GameEvents.Subscribe( "upd_action_killboss", OnHintKillBoss );
})();
