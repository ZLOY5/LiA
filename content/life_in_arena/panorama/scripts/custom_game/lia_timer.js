"use strict";

function SetTimer( data ) 
{
	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#TimerPanel_Timer" ).text = timerText;
	$( "#TimerPanel_Text" ).text = $.Localize( data.text ).toUpperCase();
	$( "#TimerPanel_Number" ).text = data.number;

	$( "#TimerPanel_Timer" ).RemoveClass( "timer_hidden" );
}

function UpdateTimer( data )
{
	var timerText = "";
	timerText += data.timer_minute_10;
	timerText += data.timer_minute_01;
	timerText += ":";
	timerText += data.timer_second_10;
	timerText += data.timer_second_01;

	$( "#TimerPanel_Timer" ).text = timerText;
}

function ShowTimer( data )
{
	$( "#TimerPanel_Timer" ).RemoveClass( "timer_hidden" );
}

function AlertTimer( data )
{
	$( "#TimerPanel_Timer" ).AddClass( "timer_alert" );
}

function HideTimer( data )
{
	$( "#TimerPanel_Timer" ).AddClass( "timer_hidden" );
}

(function()
{
	GameEvents.Subscribe( "set_timer", SetTimer );
    GameEvents.Subscribe( "countdown", UpdateTimer );
    GameEvents.Subscribe( "show_timer", ShowTimer );
    GameEvents.Subscribe( "timer_alert", AlertTimer );
    GameEvents.Subscribe( "hide_timer", HideTimer );
})();

