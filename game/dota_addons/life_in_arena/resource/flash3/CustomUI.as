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
			this.gameAPI.SubscribeToGameEvent("show_center_message_fix",  this.onCenterMessage);
			
			var newObjectClass = getDefinitionByName("s_RoshanPopup");
			timerPopup = new newObjectClass();
			this.addChild(timerPopup);
			timerPopup.visible = false;
			timerPopup.height = 50;
			timerPopup.width = 200;
			timerPopup.x = Globals.instance.resizeManager.ScreenWidth-5;
			timerPopup.y = Globals.instance.resizeManager.ScreenHeight-(Globals.instance.resizeManager.ScreenHeight-50);
			timerPopup.itemImage.visible = false;

			Globals.instance.resizeManager.AddListener(this);

			var oldShopOpened:Function = globals.Loader_shop.movieClip.gameAPI.OnShopOpened;
			globals.Loader_shop.movieClip.gameAPI.OnShopOpened = function() {
				trace("Shop width",globals.Loader_shop.movieClip.shop.MainShop.MainShopContents.width)
				trace("Screen width",Globals.instance.resizeManager.ScreenWidth)
				trace("Timer width",timerPopup.width)
				trace("Timer XY",timerPopup.x,timerPopup.y)
				var xTween = Globals.instance.resizeManager.ScreenWidth-5-globals.Loader_shop.movieClip.shop.MainShop.MainShopContents.width;
				TweenLite.to(timerPopup, 0.3, {x:xTween});
				oldShopOpened();
			};
			/*var oldShopCollapsed:Function = globals.Loader_shop.movieClip.gameAPI.OnShopCollapsed;
			globals.Loader_shop.movieClip.gameAPI.OnShopCollapsed = function() {
				var xTween = Globals.instance.resizeManager.ScreenWidth-5;
				TweenLite.to(timerPopup, 0.1, {x:xTween});
				oldShopCollapsed();
			};*/

			globals.Loader_inventory.movieClip.gameAPI.OnGlyphButtonPress = function() {};	
			
			trace("Custom UI loaded!");
		}

	
		public function onResize(re:ResizeManager) : * {
            //Calculate scale ratio
			//var scaleRatioY:Number = re.ScreenHeight/900;
			if (globals.Loader_shop.movieClip.shopOpen)
				timerPopup.x = re.ScreenWidth-globals.Loader_shop.movieClip.shop.MainShop.MainShopContents.width-5;
			else
				timerPopup.x = re.ScreenWidth-5;
			
			/*//If the screen is bigger than our stage, keep elements the same size (you can remove this)
			if (re.ScreenHeight > 900){
				scaleRatioY = 1;*/
		}

		public function onCenterMessage(args:Object) : void {
			var s:String = globals.GameInterface.Translate("#lia_wave_num");
			s = s + String(args.wave)+"\n";
			s = s + globals.GameInterface.Translate("#"+String(args.wave)+"_wave_creeps")
			trace("Center message set to :",s);
			globals.Loader_overlay.movieClip.center_message.title.text = s;
		}

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