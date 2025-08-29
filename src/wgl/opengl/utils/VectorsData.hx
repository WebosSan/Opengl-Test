package wgl.opengl.utils;

import wgl.math.Vector3;
import cpp.Float32;

@:forward
abstract VectorsData(Array<Float32>) to Array<Float32> {
    public inline function new(data:Array<Float32>) {
        this = data;
    }

    @:to
    public function toArray():Array<Float32> return this;

    @:from
    public static function fromArrays(arr:Array<Array<Float>>):VectorsData {
        var data:Array<Float32> = [];
        for (a in arr){
            for (d in a){
                data.push(d);
            }
        }
        return new VectorsData(data);
    }
}
