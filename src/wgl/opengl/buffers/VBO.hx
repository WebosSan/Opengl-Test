package wgl.opengl.buffers;

import cpp.Float32;
import cpp.Pointer;
import glad.Glad;

class VBO implements IBO {
	public var id:GlUInt = 0;

	public function new(?vertices:Array<Float32>) {
        Glad.genBuffers(1, Pointer.addressOf(id));
        activate();
        generateData(vertices ?? []);
    }

    public function generateData(vertices:Array<Float32>) {
        Glad.bufferFloatArray(Glad.ARRAY_BUFFER, vertices, Glad.STATIC_DRAW);
    }

	public function activate() {
        Glad.bindBuffer(Glad.ARRAY_BUFFER, id);
    }

	public function deactivate() {
        Glad.bindBuffer(Glad.ARRAY_BUFFER, 0);
    }

	public function destroy() {
        Glad.deleteBuffers(1, Pointer.addressOf(id));
    }
}
