package wgl.opengl.buffers;

import cpp.Pointer;
import glad.Glad;
import glad.Glad.GlUInt;

class VAO implements IBO {
	public var id:GlUInt;
    
    public function new() {
        Glad.genVertexArrays(1, Pointer.addressOf(id));
    }

    public function linkVBO(vbo:VBO, layout:GlUInt, numComponents:GlUInt, stride:GlSizeI, offset:Int) {
        activate();
        vbo.activate();
        Glad.vertexAttribPointer(layout, numComponents, Glad.FLOAT, Glad.FALSE, stride, cast offset);
        Glad.enableVertexAttribArray(layout);
        vbo.deactivate();
    }

    public function activate() {
        Glad.bindVertexArray(id);
    }
    public function deactivate() {
        Glad.bindVertexArray(0);
    }
    public function destroy() {
        Glad.deleteVertexArrays(1, Pointer.addressOf(id));
    }
}