package src.wgl.macro;

import sys.FileSystem;
import sys.io.File;
import haxe.macro.Compiler;
import haxe.macro.Expr.Field;
import haxe.macro.Context;
import haxe.Json;

class CompilerMacro {
    public static var data:Dynamic;
    public static macro function build():Array<Field> {
        if (!FileSystem.exists('./Project.json')) {
            throw 'Cant Make a Project without Project.json';
        }
        data = Json.parse(File.getContent('./Project.json'));
        Compiler.addClassPath(data.project.classPath);

        Compiler.setOutput(data.project.output + "/cpp");
        AssetsMacro.build(data.project.assetsPaths, data.project.output + "/cpp");

        Compiler.define("SDL_PREFIX");
        Compiler.allowPackage("hxsdl");
        Compiler.include("hxglad");

        return Context.getBuildFields();
    }

    public static macro function postBuild():Array<Field> {
        data = Json.parse(File.getContent('./Project.json'));
        if (!FileSystem.exists("./" + data.project.output + "/bin")){
            FileSystem.createDirectory("./" + data.project.output + "/bin");
        }

        AssetsMacro.build(data.project.assetsPaths, data.project.output + "/bin");

        if (FileSystem.exists('./${data.project.output}/cpp/Main.exe')) File.copy('./${data.project.output}/cpp/Main.exe', './${data.project.output}/bin/Main.exe');
        if (FileSystem.exists('./${data.project.output}/cpp/SDL2.dll'))File.copy('./${data.project.output}/cpp/SDL2.dll', './${data.project.output}/bin/SDL2.dll');
        return Context.getBuildFields();
    }
}