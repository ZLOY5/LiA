function setupTooltip()
{

    if (Players.GetNumPlayers() > 1) {
        
        $.GetContextPanel().SetHasClass("one_player", false)
        $("#description").SetDialogVariableInt("readyPlayers", Players.GetNumPlayersReadyToRound());
        $("#description").SetDialogVariableInt("numPlayers", Players.GetNumPlayers());
        $("#description").SetDialogVariableInt("seconds", 40*(1/Players.GetNumPlayers()));
    }
    else {
        $.GetContextPanel().SetHasClass("one_player", true)
    }
}