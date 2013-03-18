package
{
	import flare.basic.Scene3D;
	import flare.loaders.Flare3DLoader;

	import flash.display.Loader;

	import flash.events.Event;

	public class AssetManager extends Loader
	{
		private var _assets:Vector.<Flare3DLoader> = new Vector.<Flare3DLoader>();
		private var _loadProgress:Number = 0;

		public function AssetManager()
		{
			_assets.push(new Flare3DLoader("./assets/player.zf3d"));
			_assets.push(new Flare3DLoader("./assets/cinemaAisle.zf3d"));
			_assets.push(new Flare3DLoader("./assets/beano_env.zf3d"));
		}

		public function loadAssets():void
		{
			for(var loader in assets)
			{
				assets[loader].load();
				assets[loader].addEventListener(Scene3D.COMPLETE_EVENT, onAssetLoaded)
			}
		}

		private function onAssetLoaded(event:Event):void
		{
			_loadProgress += 100 / _assets.length;
			if(isLoaded())
			{
				for(var loader in assets)
				{
					assets[loader].removeEventListener(Scene3D.COMPLETE_EVENT, onAssetLoaded)
				}
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}

		private function isLoaded():Boolean
		{
			for(var loader in assets)
			{
				if(!assets[loader].loaded) return false
			}
			return true;
		}

		public function get assets():Vector.<Flare3DLoader>
		{
			return _assets;
		}

		public function get loadProgress():Number
		{
			return _loadProgress;
		}

	}
}
