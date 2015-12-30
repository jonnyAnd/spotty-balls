package ;

import js.html.MouseScrollEvent;
import js.html.MouseEvent;
import js.Lib;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import pixi.plugins.app.Application;


class Main extends Application {

    var _controller:Controller;
    var _view:View;


    public function new() {
        super();

        backgroundColor = 0xFFFFFF;
        antialias = true;
        onUpdate = _onUpdate;
        super.start();
        stage.interactive = true;

        _view = new View(stage);
        _controller = new Controller(_view, new Model());

        addZoomAndScroll();
    }

    function addZoomAndScroll(){

        //scroll wheel zoom
        untyped(document).body.addEventListener("mousewheel", function (e) {
            _view.scale.x += (e.wheelDelta/1000);
            _view.scale.y += (e.wheelDelta/1000);
        }, false);
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