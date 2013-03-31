package videoScreen
{
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.system.Security;

	public class YoutubeVideo extends Sprite
	{
		private var _url:String;
		private var _player:Object;
		private var _width:int;
		private var _height:int;

		public function YoutubeVideo(url:String, width:int, height:int)
		{
			_url = url;
			_width = width;
			_height = height;

			var loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, onLoaderInit);
			loader.load(new URLRequest("http://www.youtube.com/apiplayer?version=3"));
		}

		private function onLoaderInit(event:Event):void
		{
			_player = event.target.loader.content;
			_player.addEventListener("onReady", onPlayerReady);
		}

		private function onPlayerReady(event:Event):void
		{
			_player.setSize(_width, _height);
			_player.loadVideoById(extractVideoId(_url), 0);
			dispatchEvent(new Event("videoReady"));
		}

		private function extractVideoId(url:String):String {
			var vIndex:Number = url.lastIndexOf("=");
			if (vIndex == -1)
			{
				trace("Incorrect youtube URL");
				return "";
			}
			else
			{
				return url.substr(vIndex + 1,url.length);
			}
		}

		public function get video():DisplayObject
		{
			return _player as DisplayObject;
		}
	}
}
