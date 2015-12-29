package ;
import js.Browser;
import components.Orb;
import pixi.core.display.Container;
class View extends Container {


	private var _orbs:Array<Orb>;



	public function new(stage:Container) {
		super();
		stage.addChild(this);

		//debug code below this point, only for component development.
		addOrb(new Orb("25NCgMOtjNshJoOdoxYpea"));


	}

	private function addOrb(orb:Orb){

		if(_orbs == null){
			_orbs = new Array<Orb>();
		}



		/// DEBUG
		var high:Float =  Browser.window.innerWidth;
		var low:Float = 0;

		orb.position.x = Math.floor(Math.random()*(1+high-low))+low;
		orb.position.y = Math.floor(Math.random()*(1+high-low))+low;

		// END DEBUG



		orb.resquestAdditionalOrbs = resquestAdditionalOrbs;

		_orbs.push(orb);
		this.addChild(orb);
	}

	private function resquestAdditionalOrbs(artistIds:Array<String>){

		var duplicate:Bool;

		for(artistId in artistIds){
			duplicate = false;

			for(orb in _orbs){
				if(orb.artistId == artistId){
					duplicate = true;

				}
			}
			if(duplicate == false){
				addOrb(new Orb(artistId));
			}
		}
	}


	public function onUpdate(elapsedTime:Float){
		for(child in this.children){
			var childObject:Dynamic = child;

			if(childObject.onAnimationUpdate != null){
				childObject.onAnimationUpdate(elapsedTime);
			}
		}
	}
}
