package videoScreen
{
	import flare.core.Pivot3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flash.events.Event;

	public class Screen extends Pivot3D
	{
		//TODO Create interface for video handlers.
		private var _content;

		public function Screen(videoURL:String)
		{

			if(videoURL.indexOf("youtube") != -1)
			{
				_content = new YoutubeVideo(videoURL, 512, 512);
				_content.addEventListener("videoReady", onVideoReady);
			}
			else
			{
				_content = new FLVVideo(videoURL, 512, 512);
				_content.addEventListener("videoReady", onVideoReady);
				_content.startConnection();
			}
		}

		private function onVideoReady(event:Event):void
		{
			var texture:VideoTexture3D = new VideoTexture3D(_content.video, 512, 512 );
			var shader:Shader3D = new Shader3D( "material", [new TextureMapFilter(texture)] );
			shader.cullFace = "front";

			VirtualCinema.scene.getChildByName("screen").setMaterial(shader);
		}
	}
}
