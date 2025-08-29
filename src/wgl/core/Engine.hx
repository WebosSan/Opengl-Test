package wgl.core;

import wgl.core.Window;
import glad.Glad;
import sdl.Types.SDLEvent;
import sdl.Types.SDLInitFlags;
import sdl.SDL;

class Engine {
	public static var fps:Int;
	public static var deltaTime:Float;

	public static var application:Application;

	public static dynamic function onInit() {}

	public static dynamic function onLoop(dt:Float) {}

	public static dynamic function onQuit() {}

	public static dynamic function onEvent(event:SDLEvent) {}

	public static function init(title:String, width:Int, height:Int, ?fps:Int = 60) {
		Engine.fps = fps;
		SDL.init(SDLInitFlags.EVERYTHING);
		Window.init(title, width, height);
	}

	public static function run() {
		onInit();

		var _previousTime:Int = SDL.getPerformanceCounter().toInt();
		var event:SDLEvent = SDL.makeEvent();

		while (!Window.windowClosed) {
			while (SDL.pollEvent(event) == 1) {
				handleEvent(event);
			}

			Window.loop();

			var currentTime = SDL.getPerformanceCounter().toInt();
			deltaTime = (currentTime - _previousTime) / SDL.getPerformanceFrequency().toInt();
			_previousTime = currentTime;

			onLoop(deltaTime);

			SDL.glSwapWindow(Window.native);
			SDL.delay(Std.int(1000 / fps));
		}

		onQuit();
		Window.destroy();
	}

	private static function handleEvent(ev:SDLEvent) {
		onEvent(ev);
		switch (ev.ref.type) {
			case QUIT:
				Window.windowClosed = true;
			case WINDOWEVENT:
				Window.onWindowEvent(ev.ref.window);
			default:
		}
	}
}
