package wgl.opengl.buffers;

import cpp.UInt32;
import cpp.Float32;
import cpp.Pointer;
import glad.Glad;

class EBO implements IBO {
	public var id:GlUInt = 0;

	public function new(?indices:Array<UInt32>) {
        Glad.genBuffers(1, Pointer.addressOf(id));
        activate();
        generateData(indices ?? []);
    }

    public function generateData(indices:Array<UInt32>) {
        Glad.bufferIntArray(Glad.ELEMENT_ARRAY_BUFFER, indices, Glad.STATIC_DRAW);
    }

	public function activate() {
        Glad.bindBuffer(Glad.ELEMENT_ARRAY_BUFFER, id);
    }

	public function deactivate() {
        Glad.bindBuffer(Glad.ELEMENT_ARRAY_BUFFER, 0);
    }

	public function destroy() {
        Glad.deleteBuffers(1, Pointer.addressOf(id));
    }
}
