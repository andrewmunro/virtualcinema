package
{
	import entity.Player;
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.utils.Pivot3DUtils;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import network.NetworkManager;

	import videoScreen.Screen;

	[SWF(frameRate = 60, width = 800, height = 450, backgroundColor = 0x000000)]

	public class VirtualCinema extends Sprite
	{
		public static var scene:Scene3D;
		private static var assetManager:AssetManager;

		private static var _level:Pivot3D;
		private static var _player:Pivot3D;
		private static var _screen:Pivot3D;

		public function VirtualCinema()
		{
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;

			scene = new Scene3D( this );
			new NetworkManager();

			assetManager = new AssetManager();
			assetManager.addEventListener("complete", onAssetsLoaded);
		}

		private function onAssetsLoaded(event:Event):void
		{
			assetManager.removeEventListener(Event.COMPLETE, onAssetsLoaded);

			_level = scene.addChild(assetManager.library.getItem("level2") as Pivot3D);
			scene.getChildByName("cinemaScreen.zf3d").setScale(3,3,3);
			_player = scene.addChild(new Player());
			_screen = scene.addChild(new Screen("http://www.youtube.com/watch?v=O0ct7vRNn4o")); //"http://10.0.1.195/virtualcinema/assets/DOG.flv"

			scene.camera = new Camera3D("playerCam");
			scene.camera.setPosition(0, 135, -130);
			scene.camera.setRotation(10, 0, 0);

			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}

		private function updateEvent(e:Event):void
		{
			Pivot3DUtils.setPositionWithReference(scene.camera, 0, 135, -130, _player);
			Pivot3DUtils.lookAtWithReference(scene.camera, 10, 100, 0, _player);
		}
	}
}
