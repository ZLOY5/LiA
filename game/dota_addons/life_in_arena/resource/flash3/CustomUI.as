package {
	import flash.display.MovieClip;

	//import some stuff from the valve lib
	import ValveLib.Globals;
	import ValveLib.ResizeManager;

	import flash.utils.getDefinitionByName;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.utils.Timer;
    import flash.events.TimerEvent;
    import flash.events.Event;
    import com.greensock.*;
	//import com.greensock.easing.*;
		
	public class CustomUI extends MovieClip{
		
		//these three variables are required by the engine
		public var gameAPI:Object;
		public var globals:Object;
		public var elementName:String;

		public var timerPopup;
		//constructor, you usually will use onLoaded() instead
		public function CustomUI() : void {
		}
		
		//this function is called when the UI is loaded
		public function onLoaded() : void {			
			//make this UI visible
			visible = true;

			this.gameAPI.SubscribeToGameEvent("lia_timer_popup_start", this.onTimerPopupStart);
			this.gameAPI.SubscribeToGameEvent("lia_timer_popup_tick",  this.onTimerPopupTick);
			this.gameAPI.SubscribeToGameEvent("lia_timer_popup_end",  this.onTimerPopupEnd);
			
			var newObjectClass = getDefinitionByName("s_RoshanPopup");
			timerPopup = new newObjectClass();
			this.addChild(timerPopup);
			timerPopup.visible = false;
			timerPopup.x = Globals.instance.resizeManager.ScreenWidth-(timerPopup.width/2)-5;
			timerPopup.y = Globals.instance.resizeManager.ScreenHeight-(Globals.instance.resizeManager.ScreenHeight-50);
			timerPopup.setup
			timerPopup.height = 50;
			//timerPopup.title.text = "#lia_wave_num";
			timerPopup.itemImage.visible = false;
			//let the client rescale the UI
			Globals.instance.resizeManager.AddListener(this);
			trace(globals.Loader_shop.movieClip.width)
			var oldShopOpened:Function = globals.Loader_shop.movieClip.gameAPI.OnShopOpened;
			globals.Loader_shop.movieClip.gameAPI.OnShopOpened = function() {
				trace(globals.Loader_shop.movieClip.shop.MainShop.MainShopContents.width);
				var xTween = Globals.instance.resizeManager.ScreenWidth-10-globals.Loader_shop.movieClip.shop.MainShop.MainShopContents.width-(timerPopup.width/2);
				TweenLite.to(timerPopup, 0.3, {x:xTween});
				oldShopOpened();
			};

			var oldShopCollapsed:Function = globals.Loader_shop.movieClip.gameAPI.OnShopCollapsed;
			globals.Loader_shop.movieClip.gameAPI.OnShopCollapsed = function() {
				trace(globals.Loader_shop.movieClip.width,"COLLAPSED");
				var xTween = Globals.instance.resizeManager.ScreenWidth-(timerPopup.width/2)-5;
				TweenLite.to(timerPopup, 0.1, {x:xTween});
				oldShopCollapsed();
			};
			//this is not needed, but it shows you your UI has loaded (needs 'scaleform_spew 1' in console)
			trace("Custom UI loaded!");
		}

		/*public function onResize(re:ResizeManager) : * {
            //Calculate scale ratio
			var scaleRatioY:Number = re.ScreenHeight/900;
			
			//If the screen is bigger than our stage, keep elements the same size (you can remove this)
			if (re.ScreenHeight > 900){
				scaleRatioY = 1;
		}*/

		public function onTimerPopupStart(args:Object) : void {
			timerPopup.visible = true;
			timerPopup.timer.text = convertToMMSS(args.time);
			timerPopup.title.text = args.title;
			if (args.waveNum > 0)
				timerPopup.title.text = timerPopup.title.text + args.waveNum;
		}

		private function onTimerPopupTick(args:Object) : void {
            timerPopup.timer.text = convertToMMSS(args.time);
        }

        private function onTimerPopupEnd(args:Object) : void {
            timerPopup.visible = false;
        }


        function convertToMMSS($seconds:Number):String
		{
		    var s:Number = $seconds % 60;
		    var m:Number = Math.floor(($seconds % 3600 ) / 60);
		    //var h:Number = Math.floor($seconds / (60 * 60));
		     
		    //var hourStr:String = (h == 0) ? "" : doubleDigitFormat(h) + ":";
		    var minuteStr:String = doubleDigitFormat(m) + ":";
		    var secondsStr:String = doubleDigitFormat(s);
		     
		    return /*hourStr + */minuteStr + secondsStr;
		}
		 
		function doubleDigitFormat($num:uint):String
		{
		    if ($num < 10) 
		    	return ("0" + $num);
		    return String($num);
		}

	}
}