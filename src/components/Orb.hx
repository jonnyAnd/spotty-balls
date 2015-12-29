package components;
import pixi.interaction.EventTarget;
import haxe.Timer;
import pixi.core.math.Point;
import settings.GlobalSettings;
import pixi.core.textures.Texture;
import pixi.core.sprites.Sprite;
import comms.spotify.SpotifyCommsController;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;

class Orb extends Container{

	private var _spotify:SpotifyCommsController;
	public var artistId:String;

	private var _base:Graphics;
	private var _artistImage:Sprite;

	public var onAnimationUpdate:Float->Void;
	public var resquestAdditionalOrbs:Array<String>->Void;

	private var _originalPosition:Point;


	public function new(artistId:String) {
		super();
		this.artistId = artistId;

		setupGraphics();
		setupComms();


		// aesthetic delays
		Timer.delay(function(){
			startLoadingAnim();

		},100);


		Timer.delay(function(){
			getArtistPictureUrl();
		},500);

		this.interactive = true;
		this.click = onOrbClick;
		this.tap = onOrbClick;

	}

	private function setupGraphics(){
		_base = new Graphics();
		_base.beginFill(0xCCCCCC);
		_base.drawCircle(0,0,GlobalSettings.ORB_RADIUS);
		this.addChild(_base);

		_artistImage = new Sprite(null);
		this.addChild(_artistImage);

		var mask = new Graphics();
		mask.beginFill(0xCCCCCC);
		mask.drawCircle(0,0,GlobalSettings.ORB_RADIUS);
		this.mask = mask;
		this.addChild(mask);
	}

	private function setupComms(){
		_spotify = new SpotifyCommsController();
	}

	private function getArtistPictureUrl(){
		_spotify.getArtistPictureUrl(artistId, onGetArtistPictureUrl);
	}

	private function onGetArtistPictureUrl(url:String){
		setImageToSprite(url);
	}

	private function setImageToSprite(url:String){
		_artistImage.texture = Texture.fromImage(url);

		_artistImage.texture.baseTexture.on('loaded', function(){
			scaleSprite(_artistImage, GlobalSettings.ORB_RADIUS*2);

			_artistImage.position.x -= _artistImage.width/2;
			_artistImage.position.y -= _artistImage.height/2;

			stopLoadingAnim();

		});
	}

	private function scaleSprite(sprite:Sprite, height:Float){
		while(sprite.height>height){
			sprite.scale.x -= 0.01;
			sprite.scale.y -= 0.01;
		}
	}

	private function startLoadingAnim(){
		_originalPosition = new Point(this.x, this.y);
		onAnimationUpdate = loadingAnimation;
	}

	private function stopLoadingAnim(){
		onAnimationUpdate = null;
		this.x = _originalPosition.x;
		this.y = _originalPosition.y;
	}

	private function onOrbClick(target:EventTarget){
		startLoadingAnim();
		_spotify.getRelatedArtists(artistId, onRelatedArtistsResponse);
	}

	private function onRelatedArtistsResponse(artistIds:Array<String>){
		stopLoadingAnim();
		resquestAdditionalOrbs(artistIds);
	}


	//Anim functions
	private function loadingAnimation(time:Float){
		var high:Float = .5;
		var low:Float = high*-1;
		this.position.x += Math.floor(Math.random()*(1+high-low))+low;
		this.position.y += Math.floor(Math.random()*(1+high-low))+low;
	}
}
