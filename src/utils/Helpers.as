package utils
{
	import entity.Entity;

	public class Helpers
	{
		public static function getEntityByID(id:String):Entity
		{
			var players = VirtualCinema.remotePlayers;
			for(var i = 0; i < players.length; i++)
			{
				if(players[i].id == id)
				{
					return players[i];
				}
			}
			return null;
		}

		public static function extractYoutubeVideoID(url:String):String
		{
			var vIndex:Number = url.lastIndexOf("=");
			if (vIndex == -1)
			{
				trace("Incorrect youtube URL");
				return "";
			}
			else
			{
				return url.substr(vIndex + 1,url.length);
			}
		}
	}
}
