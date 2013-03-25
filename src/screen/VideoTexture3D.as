package screen
{
	import flare.core.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;

	public class VideoTexture3D extends Texture3D
	{
		private var _connection:NetConnection;
		private var _url:String;
		public var stream:NetStream;
		public var video:Video;
		private var _forceClear:Boolean;

		public function VideoTexture3D( url:String, width:int, height:int, transparent:Boolean = false, forceClear:Boolean = false )
		{
			super( new BitmapData( width, height, transparent, 0x0 ), true );

			super.mipMode = Texture3D.MIP_NONE;
			super.loaded = true;

			_forceClear = forceClear;

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

					var videoClient:Object = new Object();
					videoClient.onMetaData = metaDataHandler;

					stream = new NetStream( _connection );
					stream.client = videoClient;
					stream.addEventListener( AsyncErrorEvent.ASYNC_ERROR, function (e:*):void {});
					stream.addEventListener( NetStatusEvent.NET_STATUS, netStatusHandler );
					stream.checkPolicyFile = true;
					stream.bufferTime = 10;
					stream.play( _url );
					video.attachNetStream( stream );

					break;
				case "NetStream.Play.Complete":
				case "NetStream.Play.Stop":

					stream.play(_url);

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
			if ( !scene ) return;
			if ( _forceClear ) bitmapData.fillRect( bitmapData.rect, 0x0 );
			bitmapData.draw( video, video.transform.matrix, video.transform.colorTransform );
			uploadTexture();
		}

		private function metaDataHandler(infoObject:Object):void
		{
/*			video.width = infoObject.width;
			video.height = infoObject.height;*/
			_forceClear = infoObject.forceClear;
		}
	}
}