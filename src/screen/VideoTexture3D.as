package screen
{
	import flare.core.*;
	import flare.system.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;

	public class VideoTexture3D extends Texture3D
	{
		private var _connection:NetConnection;
		private var _url:String;
		private var _init:Boolean;

		public var stream:NetStream;
		public var video:Video;

		public function VideoTexture3D( url:String, width:int, height:int, transparent:Boolean = false )
		{
			super( new BitmapData( width, height, transparent ), true );

			// disable the mip mapping to speed up the uploads.
			super.mipMode = Texture3D.MIP_NONE;

			// tells to the texture that doesn't need to load anything.
			// we'll stream the screen by our own.
			super.loaded = true;

			video = new Video( width, height );
			video.deblocking = 1;
			video.smoothing = false;
			video.addEventListener( "enterFrame", updateVideoEvent );

			_url = url;
			_connection = new NetConnection();
			_connection.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
			_connection.connect(null);
		}

		/**
		 * Manages the screen streaming status.
		 */
		private function netStatusHandler( e:NetStatusEvent ):void
		{
			switch ( e.info.code )
			{
				case "NetConnection.Connect.Success":

					stream = new NetStream( _connection );
					stream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, function (e:*):void {});
					stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
					stream.checkPolicyFile = true;
					stream.bufferTime = 10;
					stream.play( _url );

					video.attachNetStream( stream );

					break;
				case "NetStream.Play.Complete":
				case "NetStream.Play.Stop":

					stream.play();

					break;
				case "NetStream.Play.StreamNotFound":

					trace( "Unable to locate screen: " + _url );

					break;
			}
		}

		/**
		 * Here we update the texture bitmapData and upload the texture to the graphics card.
		 */
		private function updateVideoEvent(e:Event):void
		{
			bitmapData.draw( video );

			upload( Device3D.scene );
		}
	}
}