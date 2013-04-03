package videoscreen
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.AsyncErrorEvent;
	import flash.events.Event;
	import flash.events.NetStatusEvent;
	import flash.media.Video;
	import flash.net.NetConnection;
	import flash.net.NetStream;

	public class FLVVideo extends Sprite
	{
		private var _video:Video;
		private var _url:String;
		private var _connection:NetConnection;
		private var _stream:NetStream;

		public function FLVVideo(url:String, width:int, height:int)
		{
			_video = new Video( width, height );
			_video.deblocking = 1;
			_video.smoothing = false;

			_url = url;
			_connection = new NetConnection();
		}

		public function startConnection():void
		{
			_connection.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			_connection.connect(null);
		}

		private function netStatusHandler( e:NetStatusEvent ):void
		{
			switch ( e.info.code )
			{
				case "NetConnection.Connect.Success":

					var videoClient:Object = new Object();
					videoClient.onMetaData = metaDataHandler;

					_stream = new NetStream( _connection );
					_stream.client = videoClient;
					_stream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, function (e:*):void {});
					_stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
					_stream.checkPolicyFile = true;
					_stream.bufferTime = 10;
					_stream.play(_url);
					_video.attachNetStream( _stream );
					dispatchEvent(new Event("videoReady"));

					break;
				case "NetStream.Play.Complete":
				case "NetStream.Play.Stop":

					_stream.play(_url);

					break;
				case "NetStream.Play.StreamNotFound":

					trace( "Unable to locate video: " + _url );

					break;
			}
		}

		private function metaDataHandler(infoObject:Object):void
		{
		}

		public function get video():DisplayObject
		{
			return _video as DisplayObject;
		}
	}
}
