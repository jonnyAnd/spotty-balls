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
	private var _samplePoint:Body;
	private var _connections:Array<Array<Orb>>;

	private var _connectionsContainer:Container;


	public function new(stage:Container) {
		super();
		stage.addChild(this);

		// add connections container
		_connections = new Array<Array<Orb>>();
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

		_samplePoint = new Body();
		_samplePoint.shapes.add(new Circle(0.001));
	}

	private function addOrb(orb:Orb){

		if(_orbs == null){
			_orbs = new Array<Orb>();
		}

		//call back functions
		orb.resquestAdditionalOrbs = resquestAdditionalOrbs;

		//physics
		orb.assignToPhysicsSpace(_space);


		_orbs.push(orb);
		this.addChild(orb);
	}

	private function resquestAdditionalOrbs(artistIds:Array<String>, sourceOrb:Orb){
		var duplicate:Bool;
		for(artistId in artistIds){
			duplicate = false;

			for(orb in _orbs){
				if(orb.artistId == artistId){
					duplicate = true;
				}
			}

			if(duplicate == false){
				var newOrb:Orb = new Orb(artistId);

				addPhysicsConnection(sourceOrb, newOrb);
				addOrb(newOrb);
				newOrb.forcePosition(new Point(sourceOrb.x ,sourceOrb.y));

				var pair:Array<Orb> = [sourceOrb,newOrb];
				_connections.push(pair);

				trace("_connections-->"+_connections.length);
			}
		}
	}

	private function addPhysicsConnection(coreOrb:Orb, newOrb:Orb){

		var pj:PivotJoint = new PivotJoint(coreOrb.pBall, newOrb.pBall, Vec2.weak(), Vec2.weak());
		pj.space = _space;
		pj.active = true;

		pj.stiff = false;

		pj.damping = 5;

		pj.breakUnderError = false;

		pj.breakUnderForce = false;


		pj.frequency = 3;



		//trace("DAMP "+pj.damping);


	}

	public function onUpdate(elapsedTime:Float){
		updateComponentAnimations(elapsedTime);

		//orb physics
		_space.step(1 / 60);

		for (orb in _orbs){

			var closestA = Vec2.get();
			var closestB = Vec2.get();

			for (body in _space.liveBodies) {

				// to stop it looking at its self
				if(body != orb.pBall){

					_samplePoint.position.set(body.position);


					var distance = Geom.distanceBody(orb.pBall, _samplePoint, closestA, closestB);

					if (distance < 100) {


						var force = closestA.sub(body.position, true);




						force.length = (body.mass * 1e6 / (distance*distance));





						force.muleq(-1);// make them replse rather than attract



						body.applyImpulse(
							force.muleq(elapsedTime/10000),//todo: examine this /10000
							null, true
												);

					}
				}
			}


			closestA.dispose();
			closestB.dispose();


			//orb.updateForces();
			orb.updatePosition();

		}



		drawConnections();

	}

	private function drawConnections(){
		//deleteAll connections

	//	trace("_connectionsContainer.children--->"+_connectionsContainer.children.length);


		for(child in _connectionsContainer.children){
			_connectionsContainer.removeChild(child);
		}

		//redraw
		for(pairs in _connections){

			var line:Graphics = new Graphics().lineStyle(1, 0xf3a33f);
			line.moveTo(pairs[0].position.x, pairs[0].position.y);
			line.lineTo(pairs[1].position.x, pairs[1].position.y);
			_connectionsContainer.addChild(line);
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
