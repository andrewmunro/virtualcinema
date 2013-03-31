package network
{
	import com.pnwrain.flashsocket.FlashSocket;
	import com.pnwrain.flashsocket.events.FlashSocketEvent;

	public class NetworkManager
	{
		public static var socket:FlashSocket;

		public function NetworkManager()
		{
			socket = new FlashSocket("localhost:8000");
			socket.addEventListener(FlashSocketEvent.CONNECT, onConnect);
			socket.addEventListener(FlashSocketEvent.MESSAGE, onMessage);
		}

		protected function onConnect(event:FlashSocketEvent):void
		{
			trace("We connected!");
		}

		private function onMessage(event:FlashSocketEvent):void
		{
			trace("Message: " + event.data);
		}

		public static function sendMessage(data:Object, opcode:String)
		{
			socket.send(data, opcode);
		}
	}
}
