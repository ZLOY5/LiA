"use strict";

var schedule
var startTime 
var endTime 
var duration
var timerType

function Tick()
{
	//$.Msg("Tick")
	schedule = $.Schedule(0.,Tick)
	//$.Msg(Game.GetDOTATime( false, false ))
	var currTime = Game.GetDOTATime( false, false )
	//var duration = endTime - startTime
	var progressBarValue = ( endTime - currTime ) / duration 
	$("#TimerProgress").value = progressBarValue

	var time = endTime - currTime
	var minuts = Math.floor( time/60 )
	var seconds = Math.floor( time - minuts*60 )	
	var sTime = ( (minuts < 10) && "0" + minuts || minuts ) + ":" + ( (seconds < 10) && "0" + seconds || seconds )
	$("#timer").text = sTime

	if (currTime >= endTime)
		StopTimer()

	var pData = CustomNetTables.GetTableValue("lia_player_table", "Player" + Players.GetLocalPlayer())

	$("#VoteContainer").visible = !pData.readyToRound && timerType == 1
	
}

function StartTimer(data)
{
	//$.Msg("StartTimer")
	//StopTimer()

	startTime = data.startTime
	endTime = data.endTime
	duration = endTime - startTime
	timerType = data.timerType

	if (data.timerType == 1) //Wave 
	{
		$("#waveName").style.visibility = "visible"
		$("#waveName").text = ($.Localize("#round_name_"+data.wave)).toUpperCase()

		$("#timerText").text = $.Localize("#timer_wave")
	}
	else if (data.timerType == 2)//Preduel
	{
		$("#waveName").style.visibility = "collapse"
		
		$("#timerText").text = $.Localize("#timer_preduel")
	}
	else
	{
		$("#waveName").style.visibility = "collapse"
		
		$("#timerText").text = $.Localize("#timer_duel")
	}

	$("#TimerContainer").RemoveClass("Hidden")

	if (schedule == null)
		Tick()
}

function StopTimer()
{
	//$.Msg("StopTimer")
	if (schedule != null)
		$.CancelScheduled(schedule)
	schedule = null
	$("#TimerContainer").AddClass("Hidden")
}

function NewEndTime(data)
{
	endTime = data.endTime
}

function OnTimerChanged(table, key, data)
{
	if (key == "lia_timer")
	{
		if (data.startTime != startTime)
			StartTimer(data)
		else
			endTime = data.endTime
	}
}

function ForceRound() {
	GameEvents.SendCustomGameEventToServer("glyph_clicked", {})
}

(function()
{
	$("#TimerContainer").AddClass("Hidden")

	CustomNetTables.SubscribeNetTableListener("lia_player_table", OnTimerChanged)
	//GameEvents.Subscribe("lia_timer_start", StartTimer);
	GameEvents.Subscribe("lia_timer_stop", StopTimer);
	//GameEvents.Subscribe("lia_timer_time_left", NewEndTime);

	var data = CustomNetTables.GetTableValue("lia_player_table", "lia_timer")
	if (typeof(data) == "object") {
		StartTimer(data)
	} 
})();