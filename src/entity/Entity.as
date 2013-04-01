package entity
{
	import flare.core.Pivot3D;

	public class Entity extends Pivot3D
	{
		public var model:Pivot3D;
		public var id:String

		public function Entity(id:String)
		{
			super();
			this.id = id;
			model = addChild((VirtualCinema.assetManager.library.getItem("player") as Pivot3D).clone());
		}
	}
}
