package wgl.core;

import stb.Image;
import sdl.Types.SDLEvent;

@:autoBuild(wgl.macro.ApplicationMacro.build())
class Application {
    public var width:Int;
    public var height:Int;

    public function new(title:String, width:Int, height:Int, ?fps:Int = 60) {
        this.width = width;
        this.height = height;
        
        Engine.application = this;
        Engine.init(title, width, height, fps);
        Engine.onInit = onInit;
        Engine.onLoop = onLoop;
        Engine.onQuit = onQuit;
        Engine.onEvent = onEvent;
    }

	public function onInit() {}

	public function onLoop(dt:Float) {}

	public function onQuit() {}

	public function onEvent(event:SDLEvent) {}

    public function onResize(width:Int, height:Int) {
        
    }
}
