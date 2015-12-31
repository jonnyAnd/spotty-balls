package ;

import pixi.core.math.Point;
import nape.space.Space;
import components.Orb;
import pixi.core.display.Container;
class View extends Container {

	private var _space:Space;

	public function new(stage:Container) {
		super();
		stage.addChild(this);
		setupPhysics();

		//todo: debug code below this point, only for component development.
		var startOrb:Orb = new Orb("25NCgMOtjNshJoOdoxYpea");
		startOrb.assignToPhysicsSpace(_space);
		this.addChild(startOrb);
		startOrb.forcePosition(new Point(500 ,300));
	}

	private function setupPhysics(){
		_space = new Space();
	}

	public function onUpdate(elapsedTime:Float){
		_space.step(1 / 60);
		updateComponentAnimations(elapsedTime);
	}

	private function updateComponentAnimations(elapsedTime:Float){
		for(child in this.children){
			var childObject:Dynamic = child;
			if(childObject.updateComponent != null){
				childObject.updateComponent(elapsedTime);
			}
		}
	}
}
