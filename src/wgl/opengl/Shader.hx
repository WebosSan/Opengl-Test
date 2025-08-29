package wgl.opengl;

import cpp.Float32;
import cpp.Star;
import wgl.math.Matrix3x3.BaseMatrix3x3;
import wgl.core.Window;
import wgl.math.Matrix4x4;
import wgl.math.Vector4;
import wgl.math.Vector3;
import wgl.math.Vector2;
import cpp.RawConstPointer;
import cpp.Pointer;
import cpp.RawPointer;
import glad.Glad;
import glad.Glad.GlUInt;
import cpp.ConstCharStar;
import cpp.Helpers;
import sys.io.File;
import sys.FileSystem;

class Shader {
	var program:GlUInt = 0;

	public function new(?vertexContent:String, ?fragmentContent:String) {
		if (FileSystem.exists(vertexContent))
			vertexContent = File.getContent(vertexContent);
		if (FileSystem.exists(fragmentContent))
			fragmentContent = File.getContent(fragmentContent);

		vertexContent = vertexContent ?? ShaderDefaults.defaultVertexShader;
		fragmentContent = fragmentContent ?? ShaderDefaults.defaultFragmentShader;

		var vConst:ConstCharStar = ConstCharStar.fromString(vertexContent);
		var fConst:ConstCharStar = ConstCharStar.fromString(fragmentContent);

		program = Glad.createProgram();

		var vertexShader:GlUInt = 0;
		vertexShader = Glad.createShader(Glad.VERTEX_SHADER);
		Glad.shaderSource(vertexShader, 1, RawPointer.addressOf(vConst), null);
		Glad.compileShader(vertexShader);
		checkCompilation(vertexShader);

		var fragmentShader:GlUInt = 0;
		fragmentShader = Glad.createShader(Glad.FRAGMENT_SHADER);
		Glad.shaderSource(fragmentShader, 1, RawPointer.addressOf(fConst), null);
		Glad.compileShader(fragmentShader);
		checkCompilation(fragmentShader, "Fragment");

		Glad.attachShader(program, vertexShader);
		Glad.attachShader(program, fragmentShader);
		Glad.linkProgram(program);
		checkLinkStatus();

		Glad.deleteShader(vertexShader);
		Glad.deleteShader(fragmentShader);
	}

	public function activate() {
		Glad.useProgram(program);
		setVariable("projection", Window.projection);
	}

	public function deactivate() {
		Glad.useProgram(0);
	}

	public function destroy() {
		Glad.deleteProgram(program);
	}

	public function setVariable(name:String, v:Dynamic) {
		if (v is Float) {
			Glad.uniform1f(Glad.getUniformLocation(program, name), v);
		}

		if (v is Int) {
			Glad.uniform1i(Glad.getUniformLocation(program, name), v);
		}

		if (v is Bool) {
			Glad.uniform1i(Glad.getUniformLocation(program, name), (v ? 1 : 0));
		}

		if (v is BaseMatrix3x3) {
			var s:Star<Float32> = cast(v, BaseMatrix3x3).toStar();
			Glad.uniformMatrix3fv(Glad.getUniformLocation(program, name), 1, Glad.FALSE, s);
			Helpers.free(s);
		}

		if (v is BaseMatrix4x4) {
			var s:Star<Float32> = cast(v, BaseMatrix4x4).toStar();
			Glad.uniformMatrix4fv(Glad.getUniformLocation(program, name), 1, Glad.FALSE, s);
			Helpers.free(s);
		}

		if (v is BaseVector2) {
			var vec:Vector2 = v;
			Glad.uniform2f(Glad.getUniformLocation(program, name), vec.x, vec.y);
		}

		if (v is BaseVector3) {
			var vec:Vector3 = v;
			Glad.uniform3f(Glad.getUniformLocation(program, name), vec.x, vec.y, vec.z);
		}

		if (v is BaseVector4) {
			var vec:Vector4 = v;
			Glad.uniform4f(Glad.getUniformLocation(program, name), vec.x, vec.y, vec.z, vec.w);
		}
	}

	function checkLinkStatus() {
		var success:Int = 0;
		Glad.getProgramiv(program, Glad.LINK_STATUS, Pointer.addressOf(success));
		if (success == 0) {
			var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
			Glad.getProgramInfoLog(program, 1024, null, infoLog);
			Helpers.nativeTrace('Failed to link Shader Program.\n%s\n', infoLog);
			Helpers.free(infoLog);
		}
	}

	public static function checkCompilation(shader:GlUInt, ?type:String = "Vertex") {
		var success:Int = 0;
		Glad.getShaderiv(shader, Glad.COMPILE_STATUS, Pointer.addressOf(success));

		if (success == 0) {
			var infoLog:cpp.Star<cpp.Char> = Helpers.malloc(1024, cpp.Char);
			Glad.getShaderInfoLog(shader, 1024, null, infoLog);
			Helpers.nativeTrace('Failed to load $type Shader.\n%s\n', infoLog);
			Helpers.free(infoLog);
		}
	}
}

class ShaderDefaults {
	public static var defaultVertexShader:String = "#version 330 core
        layout (location = 0) in vec3 aPos;

        uniform mat4 projection;
        uniform mat4 transform;

        void main() {
            gl_Position = projection * transform * vec4(aPos, 1.0);
        }";

	public static var defaultFragmentShader:String = "#version 330 core
        out vec4 FragColor;

		uniform vec4 color;

        void main()
        {
            FragColor = vec4(1.0f, 1.0f, 1.0f, 1.0f) * color;
        } ";

	public static var textureVertexShader:String = "#version 330 core
		layout (location = 0) in vec4 vertex; 

		out vec2 TexCoords;

		uniform mat4 model;
		uniform mat4 projection;

		void main()
		{
			TexCoords = vertex.zw;
			gl_Position = projection * model * vec4(vertex.xy, 0.0, 1.0);
		}";

	public static var textureFragmentShader:String = "
		#version 330 core
		in vec2 TexCoords;
		out vec4 color;

		uniform sampler2D image;
		uniform vec3 spriteColor;

		void main()
		{    
			color = vec4(spriteColor, 1.0) * texture(image, TexCoords);
		}  ";
}
