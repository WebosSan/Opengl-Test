package wgl.math;

@:forward
abstract Vector3(BaseVector3) to BaseVector3 {
	public function new(?x:Float = 0, ?y:Float = 0, ?z:Float = 0) {
		this = new BaseVector3(x, y, z);
	}

	@:from
	public static function fromFArray(f:Array<Float>) {
		return new Vector3(f[0], f[1], f[2]);
	}

	@:to
	public function toArray():Array<Float> {
		return [this.x, this.y, this.z];
	}
}

class BaseVector3 {
	public var x:Float = 0;
	public var y:Float = 0;
	public var z:Float = 0;

	public function new(?x:Float = 0, ?y:Float = 0, ?z:Float = 0) {
		this.x = x;
		this.y = y;
		this.z = z;
	}

	public function add(vector:BaseVector3):BaseVector3 {
		this.x += vector.x;
		this.y += vector.y;
		this.z += vector.z;
		return this;
	}

	public function substract(vector:BaseVector3):BaseVector3 {
		this.x -= vector.x;
		this.y -= vector.y;
		this.z -= vector.z;
		return this;
	}

	public function multiply(vector:BaseVector3):BaseVector3 {
		this.x *= vector.x;
		this.y *= vector.y;
		this.z *= vector.z;
		return this;
	}

	public function divide(vector:BaseVector3):BaseVector3 {
		this.x /= vector.x;
		this.y /= vector.y;
		this.z /= vector.z;
		return this;
	}

	// Utility

	public function clone():BaseVector3 {
		return new BaseVector3(x, y, z);
	}

	public function rotateX(angle:Float):BaseVector3 {
		var radians = angle * (Math.PI / 180);
		var cos = Math.cos(radians);
		var sin = Math.sin(radians);

		var newY = y * cos - z * sin;
		var newZ = y * sin + z * cos;

		y = newY;
		z = newZ;

		return this;
	}

	public function normalize():Vector3 {
		var length = Math.sqrt(x * x + y * y + z * z);
		if (length > 0) {
			return new Vector3(x / length, y / length, z / length);
		}
		return new Vector3(0, 0, 0);
	}

	public function cross(other:Vector3):Vector3 {
		return new Vector3(y * other.z - z * other.y, z * other.x - x * other.z, x * other.y - y * other.x);
	}

	public function dot(other:Vector3):Float {
		return x * other.x + y * other.y + z * other.z;
	}


	public function rotateY(angle:Float):BaseVector3 {
		var radians = angle * (Math.PI / 180);
		var cos = Math.cos(radians);
		var sin = Math.sin(radians);

		var newX = x * cos + z * sin;
		var newZ = -x * sin + z * cos;

		x = newX;
		z = newZ;

		return this;
	}

	public function rotateZ(angle:Float):BaseVector3 {
		var radians = angle * (Math.PI / 180);
		var cos = Math.cos(radians);
		var sin = Math.sin(radians);

		var newX = x * cos - y * sin;
		var newY = x * sin + y * cos;

		x = newX;
		y = newY;

		return this;
	}

	public function rotate(angles:BaseVector3):BaseVector3 {
		if (angles.z != 0)
			rotateZ(angles.z);
		if (angles.y != 0)
			rotateY(angles.y);
		if (angles.x != 0)
			rotateX(angles.x);
		return this;
	}
}
