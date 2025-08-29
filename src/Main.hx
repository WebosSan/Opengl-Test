package;

import wgl.display.Bitmap;
import wgl.display.BitmapData;
import wgl.math.Matrix4x4;
import glad.Glad;
import wgl.opengl.buffers.EBO;
import wgl.opengl.buffers.VAO;
import wgl.opengl.buffers.VBO;
import wgl.opengl.Shader;
import wgl.opengl.utils.VectorsData;
import wgl.utils.Color;
import wgl.math.Vector3;
import wgl.math.Vector2;
import sdl.Types.SDLEvent;
import wgl.core.Application;
import wgl.core.Window;

class Main extends Application {
    var bmp:Bitmap;

    override function onInit() {
        bmp = new Bitmap(BitmapData.fromPath("assets/sprites/mc.png"));
        bmp.x = Window.width / 2 - bmp.bitmapData.width / 2;
        bmp.y = Window.height / 2 - bmp.bitmapData.height / 2;
    }

    override function onLoop(dt:Float) {
        bmp.draw();
    }

    override function onQuit() {
        bmp.destroy();
    }

    override function onResize(width:Int, height:Int) {
        super.onResize(width, height);
        bmp.x = width / 2 - bmp.bitmapData.width / 2;
        bmp.y = height / 2 - bmp.bitmapData.height / 2;
    }
}