package components;
import nape.geom.Geom;
import nape.geom.Geom;
import nape.geom.Vec2;
import nape.space.Space;
import nape.shape.Circle;
import nape.phys.Body;
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

	@:isVar public var pBall(get, null):Body;


	public var artistId:String;

	private var _base:Graphics;
	private var _artistImage:Sprite;

	public var onAnimationUpdate:Float->Void;
	public var resquestAdditionalOrbs:Dynamic;//Array<String> -> Body -> Void;
	private var _originalPosition:Point;


	public function new(artistId:String) {
		super();
		this.artistId = artistId;

		setupGraphics();
		setupComms();
		setupInteractivity();
		setupPhysics();


		//Todo:Remove this aesthetic delays
		Timer.delay(function(){
			startLoadingAnim();

		},100);


		Timer.delay(function(){
			getArtistPictureUrl();
		},500);
	}

	public function assignToPhysicsSpace(space:Space){
		pBall.space = space;
	}

	private function setupInteractivity(){
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
		resquestAdditionalOrbs(artistIds, this);
	}


	//Physics functions
	public function forcePosition(pos:Point){
		pBall.position.x = pos.x;
		pBall.position.y = pos.y;
	}

	private function setupPhysics(){
		pBall = new Body();
		pBall.shapes.add(new Circle(GlobalSettings.ORB_RADIUS));
		pBall.position.setxy(this.x, this.y);
		pBall.angularVel = 5;
		pBall.allowRotation = false;
		pBall.mass = .1;
	}

	public function updatePosition(){
		this.position.x = pBall.position.x;
		this.position.y = pBall.position.y;
	}


	//Anim functions
	private function loadingAnimation(time:Float){
		var high:Float = .5;
		var low:Float = high*-1;
		this.position.x += Math.floor(Math.random()*(1+high-low))+low;
		this.position.y += Math.floor(Math.random()*(1+high-low))+low;
	}

	public function applyMyForceToBody(body:Body, elapsedTime:Float){

		if(body != pBall){ // Dont force yorself now!

			var closestA = Vec2.get();
			var closestB = Vec2.get();
			var distance = Geom.distanceBody(pBall, body, closestA, closestB);

			if (distance < 100) {
				var force = closestA.sub(body.position, true);
				force.length = (body.mass * 1e6 / (distance*distance));
				force.muleq(-1);// make them replse rather than attract
				force.muleq(elapsedTime/10000);//todo: examine this /10000

				body.applyImpulse(force,null,true);
			}

			closestA.dispose();
			closestB.dispose();
		}
	}

	function get_pBall():Body {
		return pBall;
	}
}
