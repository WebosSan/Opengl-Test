package wgl.math;

@:forward
abstract Vector2(BaseVector2) to BaseVector2 {
    public function new(?x:Float = 0, ?y:Float = 0) {
        this = new BaseVector2(x, y);
    }

	@:to
    public function toArray():Array<Float> {
        return [this.x, this.y];
    }
}

// Vector 2 Class, It will be used on Vector2 Abstract
class BaseVector2 {
	public var x:Float = 0;
	public var y:Float = 0;

	public function new(?x:Float = 0, ?y:Float = 0) {
		this.x = x;
		this.y = y;
	}

	// Mathematical Operators

	public function add(vector:BaseVector2):BaseVector2 {
		this.x += vector.x;
		this.y += vector.y;
		return this;
	}

	public function substract(vector:BaseVector2):BaseVector2 {
		this.x -= vector.x;
		this.y -= vector.y;
		return this;
	}

	public function multiply(vector:BaseVector2):BaseVector2 {
		this.x *= vector.x;
		this.y *= vector.y;
		return this;
	}

	public function divide(vector:BaseVector2):BaseVector2 {
		this.x /= vector.x;
		this.y /= vector.y;
		return this;
	}

	// Utility

	public function clone():BaseVector2 {
		return new BaseVector2(x, y);
	}

	/**
	 * Rotate the vector 2
	 * @param angle The angle in grades
	 * @return BaseVector2
	 */
	public function rotate(angle:Float):BaseVector2 {
		var cos_theta:Float = Math.cos(angle * (Math.PI / 180));
		var sin_theta:Float = Math.sin(angle * (Math.PI / 180));

		this.x = this.x * cos_theta - this.y * sin_theta;
		this.y = this.x * sin_theta + this.y * cos_theta;

		trace(this.x, this.y);

		return this;
	}

	public function set(x:Float, y:Float):BaseVector2 {
		this.x = x;
		this.y = y;
		return this;
	}
}
