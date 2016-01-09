package components;
import js.Browser;
import pixi.core.graphics.Graphics;
import components.core.UIElement;
class ArtistInfo extends UIElement {

    public function new() {
        super();
        updateFunction = update;
        updateProbability = 80;

        create();
    }

    private function create(){

        var t:Graphics = new Graphics();
        t.beginFill(0xf1f1f1);
        t.drawRect(100,0,50,Browser.window.innerHeight);

        addChild(t);


    }

    private function update(elapsedTime:Float){


            trace("UPDATE");
    }
}
