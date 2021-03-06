package comms.spotify;
import Std;
import haxe.format.JsonParser;
import haxe.Http;
class SpotifyCommsController {
	public function new() {
	}


	public function getArtistPictureUrl(artistId:String, followOn){

		// Todo: make this a parameter small large extra large etc.
		// This is the index of the images array to use, 0 is the the largest
		var indexOfImageToUse:Int = 2;
		var _:Http = new Http("https://api.spotify.com/v1/artists/"+artistId);

		_.onData = function(data) {
			var dataObj:Dynamic = JsonParser.parse(data);
			var imageUrl:String = dataObj.images[indexOfImageToUse].url;
			followOn(imageUrl);
		}
		_.request();
	}

	public function getRelatedArtists(artistId:String, followOn){
		var _:Http = new Http("https://api.spotify.com/v1/artists/"+artistId+"/related-artists");

		_.onData = function(data) {

			var relatedArtists:Array<String> = new Array<String>();
			var dataObj:Dynamic = JsonParser.parse(data);

			for (i in 0...Std.int(dataObj.artists.length-1)){
				var artist:Dynamic = dataObj.artists[i];
				relatedArtists.push(artist.id);
			}

			followOn(relatedArtists);
		}
		_.request();
	}

}
