package wgl.math;

#if cpp
import cpp.RawPointer;
#end
@:forward
abstract Matrix4x4(BaseMatrix4x4) to BaseMatrix4x4 from BaseMatrix4x4 {
    public inline function new(val:Float = 1.0) {
        this = new BaseMatrix4x4(val);
    }

    @:op(A * B)
    public static inline function multiplyOp(a:Matrix4x4, b:Matrix4x4):Matrix4x4 {
        return a.clone().multiply(b);
    }

    public static function ortho(left:Float, right:Float, bottom:Float, top:Float, near:Float, far:Float):BaseMatrix4x4 {
        return BaseMatrix4x4.ortho(left, right, bottom, top, near, far);
    }
    
    public static function perspective(fov:Float, aspect:Float, near:Float, far:Float):BaseMatrix4x4 {
        return BaseMatrix4x4.perspective(fov, aspect, near, far);
    }
    
    public static function lookAt(eye:Vector3, center:Vector3, up:Vector3):BaseMatrix4x4 {
        return BaseMatrix4x4.lookAt(eye, center, up);
    }
}

class BaseMatrix4x4 {
    public var vecs:Array<Vector4>;

    public function new(val:Float = 1.0) {
        vecs = [
            new Vector4(val, 0.0, 0.0, 0.0),
            new Vector4(0.0, val, 0.0, 0.0),
            new Vector4(0.0, 0.0, val, 0.0),
            new Vector4(0.0, 0.0, 0.0, val)
        ];
    }

    public function clone():BaseMatrix4x4 {
        var m = new BaseMatrix4x4();
        for (i in 0...4) m.vecs[i].copyFrom(this.vecs[i]);
        return m;
    }

    public function copyFrom(other:BaseMatrix4x4):BaseMatrix4x4 {
        for (i in 0...4) this.vecs[i].copyFrom(other.vecs[i]);
        return this;
    }

    public function multiply(other:BaseMatrix4x4):BaseMatrix4x4 {
        var result = new BaseMatrix4x4(0);
        
        for (i in 0...4) {
            for (j in 0...4) {
                var sum = 0.0;
                for (k in 0...4) {
                    var a = switch(k) {
                        case 0: this.vecs[i].x;
                        case 1: this.vecs[i].y;
                        case 2: this.vecs[i].z;
                        case 3: this.vecs[i].w;
                        default: 0.0;
                    }
                    
                    var b = switch(j) {
                        case 0: other.vecs[k].x;
                        case 1: other.vecs[k].y;
                        case 2: other.vecs[k].z;
                        case 3: other.vecs[k].w;
                        default: 0.0;
                    }
                    
                    sum += a * b;
                }
                
                switch(j) {
                    case 0: result.vecs[i].x = sum;
                    case 1: result.vecs[i].y = sum;
                    case 2: result.vecs[i].z = sum;
                    case 3: result.vecs[i].w = sum;
                    default:
                }
            }
        }
        
        return this.copyFrom(result);
    }

    public function rotateX(angle:Float):BaseMatrix4x4 {
        var c = Math.cos(angle);
        var s = Math.sin(angle);
        
        var rotMat = new BaseMatrix4x4(1);
        rotMat.vecs[1].y = c;
        rotMat.vecs[1].z = -s;
        rotMat.vecs[2].y = s;
        rotMat.vecs[2].z = c;
        
        return this.multiply(rotMat);
    }
    
    public function rotateY(angle:Float):BaseMatrix4x4 {
        var c = Math.cos(angle);
        var s = Math.sin(angle);
        
        var rotMat = new BaseMatrix4x4(1);
        rotMat.vecs[0].x = c;
        rotMat.vecs[0].z = s;
        rotMat.vecs[2].x = -s;
        rotMat.vecs[2].z = c;
        
        return this.multiply(rotMat);
    }
    
    public function rotateZ(angle:Float):BaseMatrix4x4 {
        var c = Math.cos(angle);
        var s = Math.sin(angle);
        
        var rotMat = new BaseMatrix4x4(1);
        rotMat.vecs[0].x = c;
        rotMat.vecs[0].y = -s;
        rotMat.vecs[1].x = s;
        rotMat.vecs[1].y = c;
        
        return this.multiply(rotMat);
    }

    public function scale(scale:Vector3):BaseMatrix4x4 {
        var scaleMat = new BaseMatrix4x4(1);
        scaleMat.vecs[0].x = scale.x;
        scaleMat.vecs[1].y = scale.y;
        scaleMat.vecs[2].z = scale.z;
        return this.multiply(scaleMat);
    }

    public function translate(move:Vector3):BaseMatrix4x4 {
        var translateMat = new BaseMatrix4x4(1);
        translateMat.vecs[0].w = move.x;
        translateMat.vecs[1].w = move.y;
        translateMat.vecs[2].w = move.z;
        return this.multiply(translateMat);
    }

	public static function ortho(left:Float, right:Float, bottom:Float, top:Float, zNear:Float, zFar:Float):BaseMatrix4x4 {
		var toReturn = new BaseMatrix4x4(1.0);

		toReturn.vecs[0].x = 2.0 / (right - left);
		toReturn.vecs[1].y = 2.0 / (top - bottom);
		toReturn.vecs[0].w = -(right + left) / (right - left);
		toReturn.vecs[1].w = -(top + bottom) / (top - bottom);

		toReturn.vecs[2].z = -2.0 / (zFar - zNear);
		toReturn.vecs[2].w = -(zFar + zNear) / (zFar - zNear);

		return toReturn;
	}

    public static function perspective(fov:Float, aspect:Float, near:Float, far:Float):BaseMatrix4x4 {
        var f = 1.0 / Math.tan(fov * 0.5);
        var rangeInv = 1.0 / (near - far);
        
        var result = new BaseMatrix4x4(0.0);
        
        result.vecs[0].x = f / aspect;
        result.vecs[1].y = f;
        result.vecs[2].z = (far + near) * rangeInv;
        result.vecs[2].w = -1.0;
        result.vecs[3].z = 2.0 * far * near * rangeInv;
        result.vecs[3].w = 0.0;
        
        return result;
    }
    
    public static function lookAt(eye:Vector3, center:Vector3, up:Vector3):BaseMatrix4x4 {
        var f = center.substract(eye).normalize();
        var s = f.cross(up.normalize()).normalize();
        var u = s.cross(f);
        
        var result = new BaseMatrix4x4(1.0);
        
        result.vecs[0].x = s.x;
        result.vecs[0].y = u.x;
        result.vecs[0].z = -f.x;
        result.vecs[0].w = 0.0;
        
        result.vecs[1].x = s.y;
        result.vecs[1].y = u.y;
        result.vecs[1].z = -f.y;
        result.vecs[1].w = 0.0;
        
        result.vecs[2].x = s.z;
        result.vecs[2].y = u.z;
        result.vecs[2].z = -f.z;
        result.vecs[2].w = 0.0;
        
        result.vecs[3].x = -s.dot(eye);
        result.vecs[3].y = -u.dot(eye);
        result.vecs[3].z = f.dot(eye);
        result.vecs[3].w = 1.0;
        
        return result;
    }

    public function toStar():cpp.Star<cpp.Float32> {
        var ptr:RawPointer<cpp.Float32> = cast cpp.Native.nativeMalloc(16 * cpp.Native.sizeof(cpp.Float32));
        ptr[0] = vecs[0].x;  ptr[4] = vecs[0].y;  ptr[8]  = vecs[0].z;  ptr[12] = vecs[0].w;
        ptr[1] = vecs[1].x;  ptr[5] = vecs[1].y;  ptr[9]  = vecs[1].z;  ptr[13] = vecs[1].w;
        ptr[2] = vecs[2].x;  ptr[6] = vecs[2].y;  ptr[10] = vecs[2].z;  ptr[14] = vecs[2].w;
        ptr[3] = vecs[3].x;  ptr[7] = vecs[3].y;  ptr[11] = vecs[3].z;  ptr[15] = vecs[3].w;
        return untyped __cpp__("{0}", ptr);
    }

    public function toString():String {
        return 'mat4(\n  ${vecs[0]},\n  ${vecs[1]},\n  ${vecs[2]},\n  ${vecs[3]}\n)';
    }
    
}