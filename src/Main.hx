package ;

import haxe.Timer;
import js.html.MouseScrollEvent;
import js.html.MouseEvent;
import js.Lib;
import pixi.core.graphics.Graphics;
import pixi.core.display.Container;
import pixi.plugins.app.Application;
import pixi.core.math.Point;


class Main extends Application {


    /*Todo
         - full performance review
            - Should we really mae a spotify object in each orb.... probably not.
            - are we making more lines than we need to?
            - Are graphics really that naughty?
            - points over 2*floats? is the point object just a bit bloated? //Dunno?
            -


     */





    var _controller:Controller;
    var _view:View;


    public function new() {
        super();
        backgroundColor = 0x1a3300;
        antialias = true;
        onUpdate = _onUpdate;
        onResize = _onResize;
        super.start();
        stage.interactive = true;

        //DEBUGGING PERFOMANCE, JUST TO GET THE RECORDING GOING
        //Timer.delay(function(){


        _view = new View(stage);
        _controller = new Controller(_view, new Model());

        addZoomAndScroll();

       // }, 3000);
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

    function _onResize(){
        if(_view != null){
            _view.onResize();
        }
    }

    static function main() {
        new Main();
    }
}