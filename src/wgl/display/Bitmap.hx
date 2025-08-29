package wgl.display;

import wgl.math.Matrix4x4;
import glad.Glad;
import haxe.ds.Vector;
import wgl.utils.Color;
import wgl.math.Vector4;
import wgl.math.Vector2;
import wgl.math.Vector3;
import wgl.opengl.utils.VectorsData;
import wgl.opengl.buffers.VAO;
import wgl.opengl.buffers.EBO;
import wgl.opengl.buffers.VBO;
import wgl.opengl.Shader;

import wgl.display.BitmapData;

class Bitmap {
    public var bitmapData:BitmapData;

    public var x:Float = 0;
    public var y:Float = 0;

    public var shader:Shader;
    
    private var _vao:VAO;
    private var _vbo:VBO;
    private var _ebo:EBO;

    public function new(?bitmapData:BitmapData) {
        this.bitmapData = bitmapData ?? new BitmapData(100, 100);
        
        var vertex:VectorsData = [
            new Vector4(0, this.bitmapData.height, 0, 0),
            new Vector4(this.bitmapData.width, this.bitmapData.height, 1, 0),
            new Vector4(this.bitmapData.width, 0, 1, 1),
            new Vector4(0, 0, 0, 1) 
        ];

        shader = new Shader(ShaderDefaults.textureVertexShader, ShaderDefaults.textureFragmentShader);

        _vao = new VAO();
        _vao.activate();

        _vbo = new VBO(vertex);
        _vbo.activate();

        _ebo = new EBO([0, 1, 2, 2, 3, 0]);
        _ebo.activate();

        _vao.linkVBO(_vbo, 0, 4, 4 * 4, 0);      

        _vao.deactivate();
        _vbo.deactivate();
        _ebo.deactivate();
    }

    public function draw() {
        shader.activate();
        bitmapData.activate();

        shader.setVariable("image", 0);
        var m:Matrix4x4 = new Matrix4x4();
        m.translate(new Vector3(x, y, 0));
        shader.setVariable("model", m);
        shader.setVariable("spriteColor", Vector3.fromFArray(Color.WHITE.toFloatArray()));

        _vao.activate();
        Glad.drawElements(Glad.TRIANGLES, 6, Glad.UNSIGNED_INT, 0);
        
        _vao.deactivate();
        shader.deactivate();
        bitmapData.deactivate();
    }

    public function destroy() {
        _vao.destroy();
        _vbo.destroy();
        _ebo.destroy();
        shader.destroy();
        bitmapData.destroy();
    }
}