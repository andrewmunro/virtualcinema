package entity
{
	import flare.core.Pivot3D;

	public class Entity extends Pivot3D
	{
		public var model:Pivot3D;

		public function Entity(stage:VirtualCinema)
		{
			super();
			model = addChild((stage.assetManager.library.getItem("player") as Pivot3D).clone());
			stage.scene.addChild(this);
		}
	}
}
