package entity
{
	import flare.basic.Scene3D;
	import flare.collisions.CollisionInfo;
	import flare.collisions.SphereCollision;
	import flare.core.Camera3D;
	import flare.core.Lines3D;
	import flare.core.Surface3D;
	import flare.system.Input3D;
	import flare.utils.Pivot3DUtils;

	import flash.events.Event;
	import flash.geom.Vector3D;

	public class Player extends Entity
	{
		private var velocity:Vector3D = new Vector3D();
		private var friction:Vector3D = new Vector3D(0.6, 1, 0.6);
		private var jump:Boolean = false;
		private var oldPosition:Vector3D = new Vector3D();
		private var collisions:SphereCollision;

		public function Player()
		{
			super();
			VirtualCinema.scene.addEventListener(Scene3D.UPDATE_EVENT, updateEvent);
			oldPosition.copyFrom(getPosition());

			collisions = new SphereCollision( this, 25 );
			collisions.addCollisionWith(VirtualCinema.scene.getChildByName("floor"));
		}

		public function updateEvent(e:Event)
		{
			if ( Input3D.mouseDown )
			{
				// rotate the player over the y/up axis.
				rotateY( Input3D.mouseXSpeed );
			}

			var playerVel:Number = 10;

			// if shift key is pressed, duplicate the player velocity.
			if ( Input3D.keyDown( Input3D.SHIFT ) ) playerVel *= 2;

			// basic player translations.
			if ( Input3D.keyDown( Input3D.A ) ) translateX( -playerVel );
			if ( Input3D.keyDown( Input3D.D ) ) translateX( playerVel );
			if ( Input3D.keyDown( Input3D.S ) ) translateZ( -playerVel );
			if ( Input3D.keyDown( Input3D.W ) ) translateZ( playerVel );
/*			if ( Input3D.keyDown( Input3D.CONTROL ) ) translateY( -playerVel );
			if ( Input3D.keyDown( Input3D.SPACE ) ) translateY( playerVel );*/

			// if we are not jumping.....jump!
			if ( !jump && Input3D.keyHit( Input3D.SPACE ) )
			{
				// we'll use the current and old position to calculate the player velocity,
				// so, it looks like we are just translating the player,
				// but we are really increasing the speed.
				translateY( 10 );
				jump = true;
			}

			x += velocity.x;
			y += velocity.y - 0.75;
			z += velocity.z;

			// once, we move the player, test if it is colliding with something.
			if ( collisions.slider() )
			{
				// if it collided with something, get the firt collision data.
				var info:CollisionInfo = collisions.data[0];

				// if the y/up axis of the normal is greater than the 'x' and 'z', so
				// we problably collided with the floor. set the jump flag to false again.
				if ( info.normal.y > 0.8 ) jump = false;
			}

			 // update the player velocity and apply some friction.
			 velocity.x = ( x - oldPosition.x ) * friction.x;
			 velocity.y = ( y - oldPosition.y ) * friction.y;
			 velocity.z = ( z - oldPosition.z ) * friction.z;

			// store the las position.
			oldPosition.copyFrom(getPosition());
		}
	}
}
