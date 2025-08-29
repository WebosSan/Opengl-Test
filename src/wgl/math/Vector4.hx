package wgl.math;

@:forward
abstract Vector4(BaseVector4) to BaseVector4 {
	public function new(?x:Float = 0, ?y:Float = 0, ?z:Float = 0, ?w:Float = 0) {
		this = new BaseVector4(x, y, z, w);
	}

	@:noCompletion
	@:op(-A)
	private static inline function invert(a:Vector4) {
		return new Vector4(-a.x, -a.y, -a.z, -a.w);
	}

	@:noCompletion
	@:op(A + B)
	private static inline function addOp(a:Vector4, b:Vector4) {
		return new Vector4(a.x + b.x, a.y + b.y, a.z + b.z, a.w + b.w);
	}

	@:noCompletion
	@:op(A + B)
	private static inline function addFloatOp(a:Vector4, b:Float) {
		return new Vector4(a.x + b, a.y + b, a.z + b, a.w + b);
	}

	@:noCompletion
	@:op(A += B)
	private static inline function addEqualOp(a:Vector4, b:Vector4) {
		return a.add(b);
	}

	@:noCompletion
	@:op(A += B)
	private static inline function addEqualFloatOp(a:Vector4, b:Float) {
		return a.add(new Vector4(b, b, b, b));
	}

	@:noCompletion
	@:op(A - B)
	private static inline function subtractOp(a:Vector4, b:Vector4) {
		return new Vector4(a.x - b.x, a.y - b.y, a.z - b.z, a.w - b.w);
	}

	@:noCompletion
	@:op(A - B)
	private static inline function subtractFloatOp(a:Vector4, b:Float) {
		return new Vector4(a.x - b, a.y - b, a.z - b, a.w - b);
	}

	@:noCompletion
	@:op(A -= B)
	private static inline function subtractEqualOp(a:Vector4, b:Vector4) {
		return a.substract(b);
	}

	@:noCompletion
	@:op(A -= B)
	private static inline function subtractEqualFloatOp(a:Vector4, b:Float) {
		return a.substract(new Vector4(b, b, b, b));
	}

	@:noCompletion
	@:op(A * B)
	private static inline function multiplyOp(a:Vector4, b:Vector4) {
		return new Vector4(a.x * b.x, a.y * b.y, a.z * b.z, a.w * b.w);
	}

	@:noCompletion
	@:op(A * B)
	private static inline function addMultiplyOp(a:Vector4, b:Float) {
		return new Vector4(a.x * b, a.y * b, a.z * b, a.w * b);
	}

	@:noCompletion
	@:op(A *= B)
	private static inline function multiplyEqualOp(a:Vector4, b:Vector4) {
		return a.multiply(b);
	}

	@:noCompletion
	@:op(A *= B)
	private static inline function multiplyEqualFloatOp(a:Vector4, b:Float) {
		return a.multiply(new Vector4(b, b, b, b));
	}

	@:noCompletion
	@:op(A / B)
	private static inline function divideOp(a:Vector4, b:Vector4) {
		return a.clone().divide(b);
	}

	@:noCompletion
	@:op(A / B)
	private static inline function addDivideOp(a:Vector4, b:Float) {
		return new Vector4(a.x / b, a.y / b, a.z / b, a.w / b);
	}

	@:noCompletion
	@:op(A /= B)
	private static inline function divideEqualOp(a:Vector4, b:Vector4) {
		return a.divide(b);
	}

	@:noCompletion
	@:op(A /= B)
	private static inline function divideEqualFloatOp(a:Vector4, b:Float) {
		return a.divide(new Vector4(b, b, b, b));
	}

	@:to
    public function toArray():Array<Float> {
        return [this.x, this.y, this.z, this.w];
    }
}

class BaseVector4 {
	public var x:Float = 0;
	public var y:Float = 0;
	public var z:Float = 0;
	public var w:Float = 0;

	public function new(?x:Float = 0, ?y:Float = 0, ?z:Float = 0, ?w:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public function set(?x:Float = 0, ?y:Float = 0, ?z:Float = 0, ?w:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
		this.w = w;
	}

	public function copyFrom(vec4:Vector4) {
		set(vec4.x, vec4.y, vec4.z, vec4.w);
	}

	public function add(vector:BaseVector4):BaseVector4 {
		this.x += vector.x;
		this.y += vector.y;
		this.z += vector.z;
		this.w += vector.w;
		return this;
	}

	public function substract(vector:BaseVector4):BaseVector4 {
		this.x -= vector.x;
		this.y -= vector.y;
		this.z -= vector.z;
		this.w -= vector.w;
		return this;
	}

	public function multiply(vector:BaseVector4):BaseVector4 {
		this.x *= vector.x;
		this.y *= vector.y;
		this.z *= vector.z;
		this.w *= vector.w;
		return this;
	}

	public function divide(vector:BaseVector4):BaseVector4 {
		this.x /= vector.x;
		this.y /= vector.y;
		this.z /= vector.z;
		this.w /= vector.w;
		return this;
	}


	public function toString() {
		return ('Vector4($x, $y, $z, $w)');
	}

	public function clone():BaseVector4 {
		return new BaseVector4(x, y, z, w);
	}
}
