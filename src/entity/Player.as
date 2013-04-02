package entity
{
	import flare.basic.Scene3D;
	import flare.collisions.CollisionInfo;
	import flare.collisions.SphereCollision;
	import flare.core.Camera3D;
	import flare.core.Lines3D;
	import flare.core.Pivot3D;
	import flare.core.Surface3D;
	import flare.system.Input3D;
	import flare.utils.Matrix3DUtils;
	import flare.utils.Pivot3DUtils;
	import flare.utils.Vector3DUtils;

	import flash.events.Event;
	import flash.geom.Vector3D;

	import flashx.textLayout.formats.Float;

	import network.NetworkManager;
	import network.OPCODES;

	public class Player extends Entity
	{
		private var velocity:Vector3D = new Vector3D();
		private var friction:Vector3D = new Vector3D(0.6, 1, 0.6);
		private var jump:Boolean = false;
		private var oldPosition:Vector3D = new Vector3D();
		private var collisions:SphereCollision;
		private var _rotation:Number;
		private var oldRotation:Number;

		public function Player(id:String)
		{
			super(id);
			VirtualCinema.scene.addEventListener(Scene3D.UPDATE_EVENT, updateEvent);
			oldPosition.copyFrom(getPosition());

			var dir:Vector3D = Matrix3DUtils.getDir(world);
			_rotation = oldRotation = Math.atan2( dir.x, dir.z ) * 180 / Math.PI + 180;

			collisions = new SphereCollision( this, 25 );
			//collisions.addCollisionWith(VirtualCinema.scene.getChildByName("floor"));
		}

		public function updateEvent(e:Event)
		{
			if ( Input3D.mouseDown )
			{
				rotateY( Input3D.mouseXSpeed );
			}

			var playerVel:Number = 10;

			if ( Input3D.keyDown( Input3D.SHIFT ) ) playerVel *= 2;
			if ( Input3D.keyDown( Input3D.A ) ) translateX( -playerVel );
			if ( Input3D.keyDown( Input3D.D ) ) translateX( playerVel );
			if ( Input3D.keyDown( Input3D.S ) ) translateZ( -playerVel );
			if ( Input3D.keyDown( Input3D.W ) ) translateZ( playerVel );
			if ( Input3D.keyDown( Input3D.CONTROL ) ) translateY( -playerVel );
			if ( Input3D.keyDown( Input3D.SPACE ) ) translateY( playerVel );

			if ( !jump && Input3D.keyHit( Input3D.SPACE ) )
			{
				translateY( 10 );
				jump = true;
			}

/*			x += velocity.x;
			y += velocity.y - 0.75;
			z += velocity.z;*/

			if ( collisions.slider() )
			{
				var info:CollisionInfo = collisions.data[0];
				if ( info.normal.y > 0.8 ) jump = false;
			}

			 velocity.x = ( x - oldPosition.x ) * friction.x;
			 velocity.y = ( y - oldPosition.y ) * friction.y;
			 velocity.z = ( z - oldPosition.z ) * friction.z;

			var dir:Vector3D = Matrix3DUtils.getDir(world);
			_rotation = Math.atan2( dir.x, dir.z ) * 180 / Math.PI + 180;

			//If position or rotation has changed
			if(Vector3DUtils.length(oldPosition, getPosition()) || oldRotation != rotation)
			{
				NetworkManager.sendMessage(OPCODES.PLAYER_MOVE,
					{
						x: x,
						y: y,
						z: z,
						r: rotation
					});

				oldPosition.copyFrom(getPosition());
				oldRotation = rotation;
			}

		}

		public function get rotation():Number
		{
			return _rotation;
		}
	}
}
