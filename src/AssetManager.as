package
{
	import flare.loaders.Flare3DLoader;
	import flare.system.ILibraryExternalItem;
	import flare.system.Library3D;
	import flash.display.Loader;
	import flash.events.Event;

	public class AssetManager extends Loader
	{
		private var _library:Library3D;

		[Embed(source = "/../assets/player.zf3d", mimeType = "application/octet-stream")] private var model0:Class;
		[Embed(source = "/../assets/cinemaAisle.zf3d", mimeType = "application/octet-stream")] private var model1:Class;
		[Embed(source = "/../assets/beano_env.zf3d", mimeType = "application/octet-stream")] private var model2:Class;
		[Embed(source = "/../assets/cinemaScreen.zf3d", mimeType = "application/octet-stream")] private var model3:Class;

		public function AssetManager()
		{
			_library = new Library3D(10, false);
			libraryPushItem( new Flare3DLoader( new model0 ), "player" );
			libraryPushItem( new Flare3DLoader( new model1 ), "cinema" );
			libraryPushItem( new Flare3DLoader( new model2 ), "level" );
			libraryPushItem( new Flare3DLoader( new model3 ), "level2" );

			_library.addEventListener("progress", progressEvent);
			_library.addEventListener("complete", completeEvent);

			_library.load();
		}

		private function completeEvent(event:Event):void
		{
			dispatchEvent(event);
		}

		private function progressEvent(event:Event):void
		{
			trace( "progress", _library.progress );
		}

		private function libraryPushItem( item:ILibraryExternalItem, name:String ):void
		{
			if ( !_library.getItem( name ) ) {
				_library.push( item );
				_library.addItem( name, item );
			}
		}

		public function get library():Library3D
		{
			return _library;
		}
	}
}
