package videoscreen
{
	import flare.core.*;
	import flash.display.*;
	import flash.events.*;
	import flash.media.*;
	import flash.net.*;
	import flash.system.Security;

	public class VideoTexture3D extends Texture3D
	{
		private var _forceClear:Boolean;
		private var _content:DisplayObject;

		public function VideoTexture3D( content:DisplayObject, transparent:Boolean = false, forceClear:Boolean = false )
		{
			super( new BitmapData( content.width, content.height, transparent, 0x0 ), true );

			super.mipMode = Texture3D.MIP_NONE;
			super.loaded = true;

			_forceClear = forceClear;
			_content = content;

			_content.addEventListener( "enterFrame", updateVideoEvent );
		}

		/**
		 * Here we update the texture bitmapData and upload the texture to the graphics card.
		 */
		private function updateVideoEvent(e:Event):void
		{
			if ( !scene ) return;
			if ( _forceClear ) bitmapData.fillRect( bitmapData.rect, 0x0 );
			bitmapData.draw( _content, _content.transform.matrix, _content.transform.colorTransform );
			uploadTexture();
		}
	}
}