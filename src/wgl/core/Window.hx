package wgl.core;

import stb.Image;
import wgl.core.Engine;
import wgl.math.Matrix4x4;
import wgl.utils.Color;
import sdl.Types.SDLWindowEventID;
import sdl.Types.SDLWindowEvent;
import glad.Glad;
import sdl.Types.SDLGlContext;
import sdl.Types.SDLWindowInitFlags;
import sdl.Types.SDLWindowPos;
import sdl.Types.SDLWindow;
import sdl.SDL;

class Window {
	public static var width(get, set):Int;
	public static var height(get, set):Int;

	public static var native:SDLWindow;
	public static var context:SDLGlContext;

	public static var title(get, set):String;
	@:isVar public static var resizable(get, set):Bool;


	public static var windowClosed:Bool;
	public static var backgroundColor:Color = 0xFF546396;

	public static var projection:Matrix4x4;

	private static var viewportType:String = "default";

	public static function init(title:String, width:Int, height:Int) {
		native = SDL.createWindow(title, SDLWindowPos.CENTERED, SDLWindowPos.CENTERED, width, height,
			SDLWindowInitFlags.ALLOW_HIGHDPI | SDLWindowInitFlags.OPENGL | SDLWindowInitFlags.RESIZABLE);
		context = SDL.glCreateContext(native);
		SDL.glMakeCurrent(native, context);
		SDL.glSetSwapInterval(0);

		windowClosed = false;

		Glad.loadGLLoader(untyped __cpp__("(GLADloadproc)SDL_GL_GetProcAddress"));

		Glad.enable(Glad.BLEND);
        Glad.blendFunc(Glad.SRC_ALPHA, Glad.ONE_MINUS_SRC_ALPHA);

		Glad.viewport(0, 0, width, height);

		projection = Matrix4x4.ortho(0, width, height, 0, -1, 1);
	}

	public static function onWindowEvent(ev:SDLWindowEvent) {
		if (ev.event == SDLWindowEventID.RESIZED) {
			setViewport(width, height);
			Engine.application.onResize(width, height);
		}
	}

	public static function loop() {
		switch (viewportType) {
			case "default":
				Glad.clearColor(Window.backgroundColor.redFloat, Window.backgroundColor.greenFloat, Window.backgroundColor.blueFloat, Window.backgroundColor.alphaFloat);
				Glad.clear(Glad.COLOR_BUFFER_BIT);
				
			default:
				var appWidth:Float = Engine.application.width;
				var appHeight:Float = Engine.application.height;

				var scale:Float = Math.min(width / appWidth, height / appHeight);
				
				Glad.clearColor(0.0, 0.0, 0.0, 1.0);
				Glad.clear(Glad.COLOR_BUFFER_BIT);
				
				Glad.scissor(Std.int((width - appWidth * scale) / 2), Std.int((height - appHeight * scale) / 2), Std.int(appWidth * scale), Std.int(appHeight * scale));
				Glad.enable(Glad.SCISSOR_TEST);
				Glad.clearColor(Window.backgroundColor.redFloat, Window.backgroundColor.greenFloat, Window.backgroundColor.blueFloat, Window.backgroundColor.alphaFloat);
				Glad.clear(Glad.COLOR_BUFFER_BIT);
				Glad.disable(Glad.SCISSOR_TEST);
		}
	}

	public static function changeViewportType(vType:String) {
		viewportType = vType;
	}

	public static dynamic function setViewport(width:Int, height:Int) {
		switch (viewportType) {
			case "default":
				Glad.viewport(0, 0, width, height);
				projection = Matrix4x4.ortho(0, width, height, 0, -1, 1);
				
			default:
				var appWidth:Float = Engine.application.width;
				var appHeight:Float = Engine.application.height;

				var scale:Float = Math.min(width / appWidth, height / appHeight);
				var viewportWidth:Int = Std.int(appWidth * scale);
				var viewportHeight:Int = Std.int(appHeight * scale);
				var viewportX:Int = Std.int((width - viewportWidth) / 2);
				var viewportY:Int = Std.int((height - viewportHeight) / 2);
				
				Glad.viewport(viewportX, viewportY, viewportWidth, viewportHeight);
				projection = Matrix4x4.ortho(0, appWidth, appHeight, 0, -1, 1);
		}
	}

	private static function get_width():Int {
		var size = SDL.getWindowSize(native);
		return size.x;
	}

	private static function set_width(v:Int):Int {
		SDL.setWindowSize(native, v, height);
		return v;
	}

	private static function get_height():Int {
		var size = SDL.getWindowSize(native);
		return size.y;
	}

	private static function set_height(v:Int):Int {
		SDL.setWindowSize(native, width, v);
		return v;
	}

	private static function get_title():String {
		return SDL.getWindowTitle(native);
	}

	private static function set_title(v:String):String {
		SDL.setWindowTitle(native, v);
		return v;
	}

	private static function get_resizable():Bool {
		return (SDL.getWindowFlags(native) & SDLWindowInitFlags.RESIZABLE) != 0;
	}

	private static function set_resizable(value:Bool):Bool {
		if (value) {
			SDL.setWindowResizable(native, true);
		} else {
			SDL.setWindowResizable(native, false);
		}
		return value;
	}

	public static function destroy() {
		SDL.destroyWindow(native);
		SDL.glDeleteContext(context);
	}
}