package ;


import pixi.core.graphics.Graphics;
import nape.constraint.Constraint;
import nape.constraint.PivotJoint;
import nape.constraint.PivotJoint;
import nape.constraint.PulleyJoint;
import nape.geom.Geom;
import nape.shape.Circle;
import nape.phys.Body;
import nape.geom.Vec2;
import pixi.core.math.Point;
import nape.space.Space;
import js.Browser;
import components.Orb;
import pixi.core.display.Container;
class View extends Container {


	private var _orbs:Array<Orb>;
	private var _space:Space;
	private var _connectionsContainer:Container;


	public function new(stage:Container) {
		super();
		stage.addChild(this);

		// add connections container
		_connectionsContainer = new Container();
		this.addChild(_connectionsContainer);

		setupPhysics();

		//todo: debug code below this point, only for component development.
		var startOrb:Orb = new Orb("25NCgMOtjNshJoOdoxYpea");
		addOrb(startOrb);
		startOrb.forcePosition(new Point(500 ,300));
	}

	private function setupPhysics(){
		_space = new Space();
	}

	private function addOrb(orb:Orb){

		if(_orbs == null){
			_orbs = new Array<Orb>();
		}

		//call back functions
		orb.resquestAdditionalOrbs = resquestAdditionalOrbs;

		//physics
		orb.assignToPhysicsSpace(_space);

		// register orb
		_orbs.push(orb);
		this.addChild(orb);
	}

	private function resquestAdditionalOrbs(artistIds:Array<String>, sourceOrb:Orb):Array<Orb>{
		var duplicate:Bool;

		var newOrbs:Array<Orb> = new Array<Orb>();


		for(artistId in artistIds){
			duplicate = false;

			for(orb in _orbs){//todo:this should be a for each children, so we can not stor this array any more
				if(orb.artistId == artistId){
					duplicate = true;
				}
			}

			if(duplicate == false){
				var newOrb:Orb = new Orb(artistId);
				newOrbs.push(newOrb);
				addOrb(newOrb);
				newOrb.forcePosition(new Point(sourceOrb.x ,sourceOrb.y));
			}
		}


		return newOrbs;

	}

	public function onUpdate(elapsedTime:Float){
		updateComponentAnimations(elapsedTime);
		updateForceOnAllOrbs(elapsedTime);
		drawConnections();
	}

	private function updateForceOnAllOrbs(elapsedTime:Float){
		_space.step(1 / 60);

		for (orb in _orbs){
			for (body in _space.liveBodies) {
				if(body != orb.pBall){
					orb.applyMyForceToBody(body, elapsedTime);
				}
			}
			orb.updatePosition();
		}
	}

	private function drawConnections(){

		for(child in _connectionsContainer.children){
			_connectionsContainer.removeChild(child);
		}

		for(orb in _orbs){
			orb.drawConnection(_connectionsContainer);
		}
	}

	private function updateComponentAnimations(elapsedTime:Float){
		for(child in this.children){
			var childObject:Dynamic = child;

			if(childObject.onAnimationUpdate != null){
				childObject.onAnimationUpdate(elapsedTime);
			}
		}
	}
}
