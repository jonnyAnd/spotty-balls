package components;
import nape.constraint.PivotJoint;
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

class Orb extends Component{

	private var _spotify:SpotifyCommsController;
	private var _pBall:Body;
	private var _mySpace:Space;
	public var artistId:String;
	private var _base:Graphics;
	private var _artistImage:Sprite;
	private var _originalPosition:Point;
	private var _myChildOrbs:Array<Orb>;
	private var _myConnectionLines:Array<Graphics>;

	public function new(artistId:String) {
		super();
		this.artistId = artistId;

		updateFunction = update;

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
		_mySpace = space;
		_pBall.space = space;
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

        if(GlobalSettings.OFFLINE_DEBUG_MODE){
            onGetArtistPictureUrl(GlobalSettings.OFFLINE_DEBUG_IMAGE);
        }else{
            _spotify.getArtistPictureUrl(artistId, onGetArtistPictureUrl);
        }
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
		shortAnimationUpdate = loadingAnimation;
	}

	private function stopLoadingAnim(){
		shortAnimationUpdate = null;
		this.x = _originalPosition.x;
		this.y = _originalPosition.y;
	}

	private function onOrbClick(target:EventTarget){
		startLoadingAnim();
        if(GlobalSettings.OFFLINE_DEBUG_MODE){
            onRelatedArtistsResponse(GlobalSettings.OFFLINE_DEBUG_RELATED());
        }else{
            _spotify.getRelatedArtists(artistId, onRelatedArtistsResponse);
        }
	}

	private function onRelatedArtistsResponse(artistIds:Array<String>){
		stopLoadingAnim();
		addChildOrbs(artistIds);
		addPhysicsConnectionToChildOrbs();
	}

	private function addChildOrbs(artistIds:Array<String>){

		var duplicate = false;

		if(_myChildOrbs == null){
			_myChildOrbs = new Array<Orb>();
		}

		for(newArtistId in artistIds){
			for(child in this.parent.children){
				if (Std.is(child, Orb)){

					var dynamicOrb:Dynamic = child;
					if(dynamicOrb.artistId == newArtistId){
						duplicate = true;
					}
				}
			}

			if(duplicate == false){
				var newOrb:Orb = new Orb(newArtistId);
				_myChildOrbs.push(newOrb);

				newOrb.assignToPhysicsSpace(_mySpace);
				this.parent.addChild(newOrb);

				newOrb.forcePosition(new Point(this.position.x ,this.position.y));
			}
		}
	}

	private function addPhysicsConnectionToChildOrbs(){
		for(orb in _myChildOrbs){
			var pj:PivotJoint = new PivotJoint(_pBall, orb._pBall, Vec2.weak(), Vec2.weak());
			pj.space = _mySpace;
			pj.active = true;
			pj.stiff = false;
			pj.damping = 5;
			pj.breakUnderError = false;
			pj.breakUnderForce = false;
			pj.frequency = 3;
		}
	}

	private function clearOldConnection(){
		if(_myConnectionLines != null){
			for(line in _myConnectionLines){
				this.parent.removeChild(_myConnectionLines.shift());
			}
		}
	}

	public function drawConnection(){
		if(_myChildOrbs != null){

			if(_myConnectionLines == null){
				_myConnectionLines = new Array<Graphics>();
			}


			for(childOrb in _myChildOrbs){
				var line:Graphics = new Graphics().lineStyle(1, 0xf3a33f);
				line.moveTo(this.position.x, this.position.y);
				line.lineTo(childOrb.position.x, childOrb.position.y);
				this.parent.addChild(line);
				_myConnectionLines.push(line);
			}
		}
	}

	function update(elapsedTime:Float){

		for (body in _mySpace.liveBodies) {
			if(body != _pBall){
				applyMyForceToBody(body, elapsedTime);
			}
		}


		updatePosition();
		clearOldConnection();
		drawConnection();

	}

	//Physics functions
	public function forcePosition(pos:Point){
		_pBall.position.x = pos.x;
		_pBall.position.y = pos.y;
	}

	private function setupPhysics(){
		_pBall = new Body();
		_pBall.shapes.add(new Circle(GlobalSettings.ORB_RADIUS));
		_pBall.position.setxy(this.x, this.y);
		_pBall.angularVel = 5;
		_pBall.allowRotation = false;
		_pBall.mass = .1;
	}

	public function updatePosition(){
		this.position.x = _pBall.position.x;
		this.position.y = _pBall.position.y;
	}

	//Anim functions
	private function loadingAnimation(time:Float){
		var high:Float = .5;
		var low:Float = high*-1;
		this.position.x += Math.floor(Math.random()*(1+high-low))+low;
		this.position.y += Math.floor(Math.random()*(1+high-low))+low;
	}

	public function applyMyForceToBody(body:Body, elapsedTime:Float){

		if(body != _pBall){ // Dont force yorself now!

			var closestA = Vec2.get();
			var closestB = Vec2.get();
			var distance = Geom.distanceBody(_pBall, body, closestA, closestB);

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
}
