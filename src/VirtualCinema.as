package
{
	import entity.Entity;
	import entity.Player;
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.utils.Pivot3DUtils;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;

	import screen.Screen;

	[SWF(frameRate = 60, width = 800, height = 450, backgroundColor = 0x000000)]

	public class VirtualCinema extends Sprite
	{
		private var _scene:Scene3D;
		private var _level:Pivot3D;
		private var _player:Pivot3D;

		private var _assetManager:AssetManager;
		private var _screen:Pivot3D;

		public function VirtualCinema()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			_scene = new Scene3D( this );

			_assetManager = new AssetManager();
			_assetManager.addEventListener("complete", onAssetsLoaded);
		}

		private function onAssetsLoaded(event:Event):void
		{
			_assetManager.removeEventListener(Event.COMPLETE, onAssetsLoaded);
			_level = scene.addChild(_assetManager.library.getItem("level") as Pivot3D);
			_level.setScale(100, 100, 100);
			_player = new Player(this);
			_screen = scene.addChild(new Screen("http://10.0.1.195/virtualcinema/assets/DOG.flv"));
			scene.addChild(new Entity(this));

			scene.camera = new Camera3D("playerCam");
			scene.camera.setPosition(0, 135, -130);
			scene.camera.setRotation(10, 0, 0);

			_scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}

		public function get assetManager(): AssetManager
		{
			return _assetManager
		}

		public function get level() : Pivot3D
		{
			return _level;
		}

		public function get scene():Scene3D
		{
			return _scene;
		}

		private function updateEvent(e:Event):void
		{
			Pivot3DUtils.setPositionWithReference(scene.camera, 0, 135, -130, _player);
			Pivot3DUtils.lookAtWithReference(scene.camera, 10, 100, 0, _player);
		}
	}
}
