package components;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;

class Orb extends Container{
	public function new() {
		super();

		var _:Graphics = new Graphics();
		_.beginFill(0xCCCCCC);
		_.drawCircle(0,0,50);
		this.addChild(_);

	}
}
