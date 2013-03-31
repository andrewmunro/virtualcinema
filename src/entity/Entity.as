package entity
{
	import flare.core.Pivot3D;

	public class Entity extends Pivot3D
	{
		public var model:Pivot3D;

		public function Entity()
		{
			super();
			model = addChild((VirtualCinema.assetManager.library.getItem("player") as Pivot3D).clone());
		}
	}
}
