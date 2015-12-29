package ;

import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import pixi.plugins.app.Application;


class Main extends Application {

    var _visual:Container;


    public function new() {
        super();

        backgroundColor = 0x000000;
        antialias = true;
        onUpdate = _onUpdate;
        super.start();
        stage.interactive = true;

        _visual = new Container();
        stage.addChild(_visual);


        init();
    }

    function init(){

        var _:Graphics = new Graphics();
        _.beginFill(0xCCCCCC);
        _.drawRect(0,0,100,100);
        _.endFill();
        _.cacheAsBitmap = true;

        _visual.addChild(_);
    }

    function _onUpdate(elapsedTime:Float) {

    }

    static function main() {
        new Main();
    }
}