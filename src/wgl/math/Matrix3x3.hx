package wgl.math;

import glad.Glad.GlFloat;
import cpp.RawPointer;
import cpp.Float32;
import cpp.Pointer;
import cpp.Star;
import wgl.math.Vector2;
import wgl.math.Vector3;
import Math;

@:forward
abstract Matrix3x3(BaseMatrix3x3) to BaseMatrix3x3 from BaseMatrix3x3 {
    public inline function new(a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0) {
        this = new BaseMatrix3x3(a, b, c, d, tx, ty);
    }
}

class BaseMatrix3x3 {
    public var tx(get, set):Float;
    public var ty(get, set):Float;
    public var rotation(default, set):Float;
    public var data:Array<Vector3>;
    private var _scale:Vector2;

    public function new(a:Float = 1, b:Float = 0, c:Float = 0, d:Float = 1, tx:Float = 0, ty:Float = 0) {
        data = [
            new Vector3(a, c, tx),  
            new Vector3(b, d, ty),   
            new Vector3(0, 0, 1)    
        ];
        _scale = new Vector2(1, 1);
        rotation = 0;
    }

    public function translate(tx:Float, ty:Float):BaseMatrix3x3 {
        this.tx += tx;
        this.ty += ty;
        return this;
    }

    public function setTranslation(tx:Float, ty:Float):BaseMatrix3x3 {
        this.tx = tx;
        this.ty = ty;
        return this;
    }

    public function transformPoint(x:Float, y:Float):Vector2 {
        var resultX = data[0].x * x + data[0].y * y + data[0].z;
        var resultY = data[1].x * x + data[1].y * y + data[1].z;
        return new Vector2(resultX, resultY);
    }

    public static function identity():BaseMatrix3x3 {
        return new BaseMatrix3x3(1, 0, 0, 1, 0, 0);
    }

    public static function createTranslation(tx:Float, ty:Float):BaseMatrix3x3 {
        return new BaseMatrix3x3(1, 0, 0, 1, tx, ty);
    }

    public function scale(sx:Float, sy:Float):BaseMatrix3x3 {
        data[0].x *= sx;
        data[1].x *= sx;
        
        data[0].y *= sy;
        data[1].y *= sy;
        
        tx *= sx;
        ty *= sy;
        
        _scale.set(sx, sy);
        return this;
    }

    public function toStar():Star<cpp.Float32> {
        var ptr:RawPointer<cpp.Float32> = cast cpp.Native.nativeMalloc(9 * cpp.Native.sizeof(cpp.Float32));

        ptr[0] = data[0].x;  // a
        ptr[1] = data[1].x;  // b  
        ptr[2] = data[2].x;  // 0
        
        ptr[3] = data[0].y;  // c
        ptr[4] = data[1].y;  // d
        ptr[5] = data[2].y;  // 0
        
        ptr[6] = data[0].z;  // tx
        ptr[7] = data[1].z;  // ty
        ptr[8] = data[2].z;  // 1
        
        return untyped __cpp__("{0}", ptr);
    }

    private function set_rotation(v:Float):Float {
        var cos = Math.cos(v);
        var sin = Math.sin(v);
        
        data[0].x = cos * _scale.x;
        data[1].x = sin * _scale.x;
        
        data[0].y = -sin * _scale.y;
        data[1].y = cos * _scale.y;
        
        return rotation = v;
    }

    private function get_tx():Float {
        return data[0].z;
    }

    private function set_tx(v:Float):Float {
        return data[0].z = v;
    }

    private function get_ty():Float {
        return data[1].z;
    }

    private function set_ty(v:Float):Float {
        return data[1].z = v;
    }

    public function toString():String {
        return 'Matrix3x3:\n' +
               '[${data[0].x}, ${data[0].y}, ${data[0].z}]\n' +
               '[${data[1].x}, ${data[1].y}, ${data[1].z}]\n' +
               '[${data[2].x}, ${data[2].y}, ${data[2].z}]';
    }
}