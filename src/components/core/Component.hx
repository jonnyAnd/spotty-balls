package components.core;
import pixi.core.display.Container;
class Component extends Container {

	public var shortAnimationUpdate:Float->Void;
	private var updateFunction:Float->Void;

    public var updateProbability:Float = 100;// will update 100% of the time, this should be set in component




	public function new() {
		super();
		updateFunction = updateFunctionStub;
	}

	public function updateComponent(elapsedTime:Float){
		if(shortAnimationUpdate != null){
			shortAnimationUpdate(elapsedTime);
		}


        if(updateRequired()){
            updateFunction(elapsedTime);
        }
	}

    private function updateRequired():Bool{

        /*
            probability update experiment
            i want things to update with differnt frequencies based on animation requiments.
            But, it would be nice if elements with the smae requiment didnt update on the same frame, so we can spread the load.
            So we are going to try this..
            100 = 100% of the updates it will be called
            50% half the time etc,

            but its based on rand.. so each frame, there is a 50% chance of update.

                Could be rubbish, but we can try :)
         */


        var probability:Float = 100 - updateProbability;
        var rand:Float = Math.floor(Math.random()*(1+probability-1))+1;
        return (rand == 1);
    }

	private function updateFunctionStub(elapsedTime:Float){
		trace("please set updateFunction = updateFunction:Float->Void");
	}
}
