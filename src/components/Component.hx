package components;
import pixi.core.display.Container;
class Component extends Container {

	public var shortAnimationUpdate:Float->Void;
	private var updateFunction:Float->Void;

	public function new() {
		super();
		updateFunction = updateFunctionStub;
	}

	public function updateComponent(elapsedTime:Float){
		if(shortAnimationUpdate != null){
			shortAnimationUpdate(elapsedTime);
		}
		updateFunction(elapsedTime);
	}

	private function updateFunctionStub(elapsedTime:Float){
		trace("please set updateFunction:Float->Void");
	}


}
