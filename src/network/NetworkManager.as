package network
{
	import com.pnwrain.flashsocket.FlashSocket;
	import com.pnwrain.flashsocket.events.FlashSocketEvent;
	import entity.Entity;
	import flash.system.Security;
	import utils.Helpers;

	public class NetworkManager
	{
		public static var socket:FlashSocket;

		public function NetworkManager()
		{
			Security.loadPolicyFile("xmlsocket://localhost:10843");
			socket = new FlashSocket("localhost:8000");
			//Security.loadPolicyFile("xmlsocket://176.56.235.72:10843");
			//socket = new FlashSocket("176.56.235.72:8000");
			socket.addEventListener(FlashSocketEvent.CONNECT, onConnect);
			socket.addEventListener(FlashSocketEvent.MESSAGE, onMessage);
			socket.addEventListener(OPCODES.PLAYER_NEW, onPlayerNew);
			socket.addEventListener(OPCODES.PLAYER_MOVE, onPlayerMove);
			socket.addEventListener(OPCODES.PLAYER_DISCONNECT, onPlayerDisconnect);
		}

		private function onConnect(event:FlashSocketEvent):void
		{
			trace("We connected!");
			VirtualCinema.onNetworkConnected(event.currentTarget.sessionID);
		}

		private function onPlayerNew(event:FlashSocketEvent):void
		{
			var data:Object = event.data[0];
			var newPlayer:Entity = VirtualCinema.scene.addChild(new Entity(data.id)) as Entity;
			newPlayer.setPosition(data.x, data.y, data.z);
			VirtualCinema.remotePlayers.push(newPlayer);
		}

		private function onPlayerMove(event:FlashSocketEvent):void
		{
			var data:Object = event.data[0];
			var player:Entity = Helpers.getEntityByID(data.id);
			player.setPosition(data.x, data.y, data.z);
			player.setRotation(0,0,0);
			player.rotateY(data.r);
		}

		private function onPlayerDisconnect(event:FlashSocketEvent):void
		{
			trace("Another player disconnected!");
			var data:Object = event.data[0];
			var player:Entity = Helpers.getEntityByID(data.id);

			VirtualCinema.scene.removeChild(player);
			VirtualCinema.remotePlayers.splice(VirtualCinema.remotePlayers.indexOf(player), 1);
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
