"use strict";

//var time_tick = -1;
var t;

var curr_data;
var curr_time_tick;
var idHideInProcess1 = -1;
var idHideInProcess2 = -1;



function OnHintKillBoss(data)
{
var arrayR = [ 52, 61, 140, 243, 255, 197, 199, 27 ];
var arrayG = [ 85, 210, 42, 201, 108, 77, 228, 192 ];
var arrayB = [ 255, 150, 244, 9, 0, 168, 13, 216 ];

	var del = 12;
	var del2 = 0;
	var playerInfo;
	var playerPortrait;
	var textCont;
	var textCont2;
	var colorStr;
	// replace curr note in up
	if (curr_data)
	{
		//
		$.GetContextPanel().SetHasClass( "kill_start2", true );
		playerInfo = Game.GetPlayerInfo( curr_data.Pid );
		playerPortrait = $( "#LiaKillBoss2" ).FindChildInLayoutFile( "HeroIcon" );
		playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
		textCont = $( "#LiaKillBoss2" ).FindChildInLayoutFile( "LiaKillBoss_Text" );
		textCont.text = playerInfo.player_name; 
		colorStr = "#" + arrayR[data.Pid].toString(16) + arrayG[data.Pid].toString(16) + arrayB[data.Pid].toString(16) + "ff";
		textCont.style.color = colorStr;//color;
		textCont2 = $( "#LiaKillBoss2" ).FindChildInLayoutFile( "LiaKillBoss_Text2" );
		textCont2.text = $.Localize( "#LiaKillBoss" ); 
		//
		del2 = del -(Game.Time()-curr_time_tick);
		if (del2 < 0)
			del2 = 0;
		idHideInProcess2 = idHideInProcess2 +1;
		var locIn2 = idHideInProcess2;
		$.Schedule( del2, function() { ClearKillStart2Message(locIn2) }  );
	}
	curr_data = data;
	curr_time_tick = Game.Time();

	//
	//
	$.GetContextPanel().SetHasClass( "kill_start1", true );
	//
	playerInfo = Game.GetPlayerInfo( data.Pid );
	playerPortrait = $( "#LiaKillBoss1" ).FindChildInLayoutFile( "HeroIcon" );
	playerPortrait.SetImage( "file://{images}/heroes/" + playerInfo.player_selected_hero + ".png" );
	textCont = $( "#LiaKillBoss1" ).FindChildInLayoutFile( "LiaKillBoss_Text" );
	//$.Msg( "		textCont = ", textCont);
	/*var color = Players.GetPlayerColor( data.Pid ); 
	var r = Math.floor(color % 0x100);
	var g = Math.floor((color % 0x10000) / 0x100);
	var b = Math.floor((color % 0x1000000) / 0x10000);*/
	colorStr = "#" + arrayR[data.Pid].toString(16) + arrayG[data.Pid].toString(16) + arrayB[data.Pid].toString(16) + "ff";
	textCont.style.color = colorStr;//color;
	//$.Msg( "		colorStr = ", colorStr);
	textCont.text = playerInfo.player_name;
	textCont2 = $( "#LiaKillBoss1" ).FindChildInLayoutFile( "LiaKillBoss_Text2" );
	textCont2.text = $.Localize( "#LiaKillBoss" ); 
	
	//
	idHideInProcess1 = idHideInProcess1 +1;
	var locIn1 = idHideInProcess1;
	$.Schedule( del, function() { ClearKillStart1Message(locIn1) } );
	//$.Msg( "		del2 = ", del2);
	//$.Msg( "		del = ", del);
	//$.Msg( "		show_hint = ", show_hint);
}

function ClearKillStart1Message(idHideInProc) 
{
	if (idHideInProc !== idHideInProcess1)
		return;
	$.GetContextPanel().SetHasClass( "kill_start1", false );
	idHideInProcess1 = -1;
}

function ClearKillStart2Message(idHideInProc) 
{
	if (idHideInProc !== idHideInProcess2)
		return;
	$.GetContextPanel().SetHasClass( "kill_start2", false );
	idHideInProcess2 = -1;
}

/*function timedCount() 
{ 
	
	time_tick=time_tick+1; 
	t=setTimeout(function() {timedCount();} ,1000); 
} */
		
(function () { 

	GameEvents.Subscribe( "upd_action_killboss", OnHintKillBoss );
	//timedCount;
	//setInterval(function () {time_tick=time_tick+1}, 1000);
})();

