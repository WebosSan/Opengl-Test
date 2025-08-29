package wgl.opengl.buffers;

import glad.Glad.GlUInt;

interface IBO {
    public var id:GlUInt;

    public function activate():Void;
    public function deactivate():Void;
    public function destroy():Void;
}