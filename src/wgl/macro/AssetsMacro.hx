package src.wgl.macro;

import sys.io.File;
import sys.FileSystem;
import haxe.macro.Context;
import haxe.macro.Expr.Field;

class AssetsMacro {
    public static function build(paths:Array<String>, output:String) {
        for (path in paths){
            copyFolder(path, './' + output);
        }
    }
    
    public static function copyFolder(source:String, dst:String) {
        if (!FileSystem.exists(source)) return;
        
        var targetPath = dst + "/" + source.split("/").pop();
        
        if (FileSystem.isDirectory(source)) {
            if (!FileSystem.exists(targetPath)) {
                FileSystem.createDirectory(targetPath);
            }
            
            for (file in FileSystem.readDirectory(source)) {
                var srcFile = source + "/" + file;
                copyFolder(srcFile, targetPath);
            }
        } else {
            File.copy(source, targetPath);
        }
    }
}