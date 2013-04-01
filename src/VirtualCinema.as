package
{
	import entity.Entity;
	import entity.Player;
	import flare.basic.Scene3D;
	import flare.core.Camera3D;
	import flare.core.Pivot3D;
	import flare.utils.Matrix3DUtils;
	import flare.utils.Pivot3DUtils;

	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	import network.NetworkManager;
	import network.OPCODES;

	import videoScreen.Screen;

	[SWF(frameRate = 60, width = 800, height = 450, backgroundColor = 0x000000)]

	public class VirtualCinema extends Sprite
	{
		public static var scene:Scene3D;
		public static var remotePlayers:Vector.<Entity> = new Vector.<Entity>();
		public static var player:Player;
		public static var assetManager:AssetManager;

		private static var _level:Pivot3D;
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

		public function onAssetsLoaded(event:Event):void
		{
			assetManager.removeEventListener(Event.COMPLETE, onAssetsLoaded);

			_level = scene.addChild(assetManager.library.getItem("level2") as Pivot3D);
			scene.getChildByName("cinemaScreen.zf3d").setScale(3,3,3);
			_screen = scene.addChild(new Screen("http://www.nomtrees.com/virtualcinema/assets/DOG.flv")); //"http://10.0.1.195/virtualcinema/assets/DOG.flv"

			scene.camera = new Camera3D("playerCam");
			scene.camera.setPosition(0, 135, -130);
			scene.camera.setRotation(10, 0, 0);

			scene.addEventListener( Scene3D.UPDATE_EVENT, updateEvent );
		}

		public static function onNetworkConnected(id:String)
		{
			player = scene.addChild(new Player(id)) as Player;
			NetworkManager.sendMessage(OPCODES.PLAYER_NEW,
				{
					x: player.x,
					y: player.y,
					z: player.z,
					r: player.rotation
				});
		}

		private function updateEvent(e:Event):void
		{
			if(player)
			{
				Pivot3DUtils.setPositionWithReference(scene.camera, 0, 135, -130, player);
				Pivot3DUtils.lookAtWithReference(scene.camera, 10, 100, 0, player);
			}
		}
	}
}
