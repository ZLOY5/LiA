function Tick() 
{
    var gameTime = Game.GetDOTATime( true, false )
    
    var minuts = Math.floor(gameTime/60)
    var seconds = Math.floor(gameTime-minuts*60)
    
    var sTime = ( (minuts < 10) && "0" + minuts || minuts ) + ":" + ( (seconds < 10) && "0" + seconds || seconds )
    
    $("#Clock").text = sTime

    $("#Clock").SetHasClass("underNetGraph",$.GetContextPanel().GetParent().GetParent().GetParent().FindChildTraverse("NetGraph").BHasClass("Visible"))

    $.Schedule(1,Tick)
}

(function()
{
    $.Schedule(1,Tick)
})();