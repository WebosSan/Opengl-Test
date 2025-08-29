package wgl.macro;

import haxe.macro.Expr.Error;
import haxe.macro.Expr.Function;
import sys.io.File;
import haxe.Json;
import sys.FileSystem;
import haxe.macro.Context;
import haxe.macro.Expr.Field;
import haxe.macro.Compiler;

class ApplicationMacro {
	public static var data(default, null):ApplicationData;

	public static macro function build():Array<Field> {
		final fields = Context.getBuildFields();

		if (!FileSystem.exists('./Project.json')) {
			throw new Error("Cant build a project without a Project.json", Context.currentPos());
		}

		data = Json.parse(File.getContent('./Project.json'));

		var dataField:Field = {
			name: "projectData",
			access: [APrivate, AStatic],
			kind: FVar(macro :wgl.macro.ApplicationMacro.ApplicationData, macro $v{data}),
			pos: Context.currentPos(),
			doc: null,
			meta: []
		};

		fields.push(dataField);

		var func:Function = {
			ret: TPath({name: "Void", params: [], pack: []}),
			params: [],
			expr: macro {
				Type.createInstance(Type.resolveClass(projectData.project.main), [
					projectData.window.title,
					projectData.window.width,
					projectData.window.height,
					projectData.project.fps
				]);
                wgl.core.Window.changeViewportType(projectData.window.viewportType);
				wgl.core.Window.backgroundColor = projectData.window.backgroundColor;
                wgl.core.Window.resizable = projectData.window.resizable ?? false;
				wgl.core.Engine.run();
			},
			args: []
		};

		var mainField:Field = {
			name: "main",
			access: [AStatic],
			kind: FFun(func),
			pos: Context.currentPos(),
			doc: null,
			meta: []
		};
		fields.push(mainField);

		return fields;
	}
}

typedef ApplicationData = {
	window:WindowData,
	project:ProjectData
}

typedef WindowData = {
	width:Int,
	height:Int,
	title:String,
	?backgroundColor:String,
	?aspectRatio:String,
	?viewportType:String,
    ?resizable:Bool
}

typedef ProjectData = {
	main:String,
	assetsPaths:Array<String>,
	classPath:String,
	output:String,
	?fps:Int,
	?target:String // Optional target platform
}
