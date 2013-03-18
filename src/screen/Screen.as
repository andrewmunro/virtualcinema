package screen
{
	import flare.core.Pivot3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flare.primitives.Sphere;

	public class Screen extends Pivot3D
	{
		private var sphere:Sphere;

		public function Screen(videoURL:String)
		{
			var texture:VideoTexture3D = new VideoTexture3D( videoURL, 512, 512 );

			var shader:Shader3D = new Shader3D( "material", [new TextureMapFilter(texture)] );

			sphere = new Sphere( "sphere", 150, 100, shader );
			sphere.z = 500;
			sphere.y = 150;
			addChild( sphere );
		}
	}
}
