package network
{
	import com.pnwrain.flashsocket.FlashSocket;
	import com.pnwrain.flashsocket.events.FlashSocketEvent;

	import entity.Entity;

	import flash.geom.Vector3D;

	import flash.system.Security;

	import utils.Helpers;

	public class NetworkManager
	{
		public static var socket:FlashSocket;

		public function NetworkManager()
		{
			Security.loadPolicyFile("xmlsocket://www.nomtrees.com:10843");
			socket = new FlashSocket("www.nomtrees.com:8000");
			socket.addEventListener(FlashSocketEvent.CONNECT, onConnect);
			socket.addEventListener(FlashSocketEvent.MESSAGE, onMessage);
			socket.addEventListener(OPCODES.PLAYER_NEW, onPlayerNew);
			socket.addEventListener(OPCODES.PLAYER_MOVE, onPlayerMove);
		}

		private function onConnect(event:FlashSocketEvent):void
		{
			trace("We connected!");
			VirtualCinema.onNetworkConnected(event.currentTarget.sessionID);
		}

		private function onPlayerNew(event:FlashSocketEvent):void
		{
			var data:Object = event.data[0];
			var newPlayer:Entity = VirtualCinema.scene.scene.addChild(new Entity(data.id)) as Entity;
			newPlayer.setPosition(data.x, data.y, data.z, data.r);
			VirtualCinema.remotePlayers.push(newPlayer);
		}

		private function onPlayerMove(event:FlashSocketEvent):void
		{
			var data:Object = event.data[0];
			var player:Entity = Helpers.getEntityByID(data.id);
			player.setPosition(data.x, data.y, data.z);
			var oldRotation:Vector3D = player.getRotation(false);
			trace(data.r);
			player.setRotation(oldRotation.x, data.r, oldRotation.z);
		}

		private function onMessage(event:FlashSocketEvent):void
		{
			trace("Message: " + event.type);
		}

		public static function sendMessage(opcode:String, data:Object)
		{
			socket.send(data, opcode);
		}
	}
}
