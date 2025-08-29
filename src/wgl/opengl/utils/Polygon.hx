package wgl.opengl.utils;

import wgl.math.Vector4;
import wgl.utils.Color;
import wgl.math.Vector3;
import wgl.math.Matrix4x4;
import glad.Glad;
import wgl.opengl.utils.VectorsData;
import cpp.UInt32;
import wgl.opengl.Shader;
import wgl.opengl.buffers.VBO;
import wgl.opengl.buffers.EBO;
import wgl.opengl.buffers.VAO;

class Polygon {
    private var _vao:VAO;
    private var _vbo:VBO;
    private var _ebo:EBO;

    private var _indices:Array<UInt32>;

    public var width:Float = 0;
    public var height:Float = 0;

    public var color:Color = 0xFFFFFFFF;

    public var shader:Shader;

    public var x:Float = 0;
    public var y:Float = 0;

    public var rotationX:Float = 0;
    public var rotationY:Float = 0;
    public var rotationZ:Float = 0;

    public function new(vectors:VectorsData, indices:Array<UInt32>) {
        _indices = indices;

        var minX = Math.POSITIVE_INFINITY;
        var maxX = Math.NEGATIVE_INFINITY;
        var minY = Math.POSITIVE_INFINITY;
        var maxY = Math.NEGATIVE_INFINITY;
        
        var i = 0;
        while (i < vectors.length) {
            var x = vectors[i];
            var y = vectors[i + 1];
            
            if (x < minX) minX = x;
            if (x > maxX) maxX = x;
            if (y < minY) minY = y;
            if (y > maxY) maxY = y;
            
            i += 3;
        }
        
        width = maxX - minX;
        height = maxY - minY;

        shader = new Shader();

        _vao = new VAO();
        _vao.activate();
        
        _vbo = new VBO(vectors);
        _vbo.activate();

        _ebo = new EBO(indices);
        _ebo.activate();

        _vao.linkVBO(_vbo, 0, 3, 3 * 4, 0);

        _vao.deactivate();
        _vbo.deactivate();
        _ebo.deactivate();
    }

    public function draw() {
        shader.activate();
    
        var matrix:Matrix4x4 = new Matrix4x4(1);
        
        matrix.translate(new Vector3(x, y, 0));
        matrix.translate(new Vector3(width / 2, height / 2, 0));
        matrix.rotateX(rotationX);
        matrix.rotateY(rotationY);
        matrix.rotateZ(rotationZ);
        matrix.translate(new Vector3(-width / 2, -height / 2, 0));
        
        shader.setVariable("transform", matrix);
        shader.setVariable("color", new Vector4(color.redFloat, color.greenFloat, color.blueFloat, color.alphaFloat));
    
        _vao.activate();
        Glad.drawElements(Glad.TRIANGLES, _indices.length, Glad.UNSIGNED_INT, 0);
        _vao.deactivate();
        shader.deactivate();
    }

    public function destroy() {
        _vao.destroy();
        _vbo.destroy();
        _ebo.destroy();
        shader.destroy();
    }

    public static function createRectangle(width:Int, height:Int) {
        return new Polygon(
            [
                new Vector3(0, 0, 1),   
                new Vector3(width, 0, 1),
                new Vector3(width, height, 1),  
                new Vector3(0, height, 1)
            ],
            [0, 1, 2, 2, 3, 0]
        );
    }
}