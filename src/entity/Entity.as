package entity
{
	import flare.collisions.SphereCollision;
	import flare.core.Pivot3D;

	public class Entity extends Pivot3D
	{
		private var _collisions:SphereCollision;
		public var model:Pivot3D;

		public function Entity(stage:VirtualCinema)
		{
			super();
			model = addChild(stage.assetManager.assets[0].clone());
			stage.scene.addChild(this);

			_collisions = new SphereCollision(this);
			_collisions.addCollisionWith(stage.level, false);
		}

		public function get collisions():SphereCollision
		{
			return _collisions;
		}
	}
}
