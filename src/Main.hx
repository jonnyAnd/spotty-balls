package ;

import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import pixi.plugins.app.Application;


class Main extends Application {

    var _controller:Controller;
    var _view:View;


    public function new() {
        super();

        backgroundColor = 0x000000;
        antialias = true;
        onUpdate = _onUpdate;
        super.start();
        stage.interactive = true;

        _view = new View(stage);
        _controller = new Controller(_view, new Model());
    }

    function _onUpdate(elapsedTime:Float) {

        if(_view != null){
            _view.onUpdate(elapsedTime);
        }
    }

    static function main() {
        new Main();
    }
}