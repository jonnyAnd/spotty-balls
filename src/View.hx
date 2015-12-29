package ;
import components.Orb;
import pixi.core.display.Container;
class View extends Container {
	public function new(stage:Container) {
		super();
		stage.addChild(this);
	}

	public function onUpdate(elapsedTime:Float){

		trace("mooo");
		var test:Orb = new Orb();

		test.position.x = elapsedTime/100;
		test.position.y = elapsedTime/100;

		this.addChild(test);


	}
}
