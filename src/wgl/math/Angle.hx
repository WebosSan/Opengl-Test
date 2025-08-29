package wgl.math;

class Angle {
    public static function toRadians(degrees:Float) {
        return degrees * (Math.PI / 180);
    }

    public static function toDegrees(radians:Float) {
        return radians * (180 / Math.PI);
    }
}