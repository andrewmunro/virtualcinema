package screen
{
	import flare.core.Pivot3D;
	import flare.materials.Shader3D;
	import flare.materials.filters.TextureMapFilter;
	import flare.primitives.Plane;
	import flare.primitives.Sphere;

	public class Screen extends Pivot3D
	{
		private var plane:Plane;

		public function Screen(videoURL:String)
		{
			var texture:VideoTexture3D = new VideoTexture3D( videoURL, 512, 512 );

			var shader:Shader3D = new Shader3D( "material", [new TextureMapFilter(texture)] );
			shader.twoSided = false;

			plane = new Plane( "screen", 150, 100, 1, shader );
			plane.z = 500;
			plane.y = 150;
			addChild( plane );
		}
	}
}
