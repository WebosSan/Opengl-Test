package wgl.display;

import wgl.math.Rectangle;
import wgl.math.Vector2;
import cpp.Native;
import stb.Image;
import cpp.RawPointer;
import cpp.UInt8;
import cpp.CPPArray;
import cpp.Char;
import cpp.UInt32;
import cpp.Star;
import cpp.Pointer;
import glad.Glad;
import wgl.utils.Color;

class BitmapData {
	/**
	 * Gl Texture Id
	 */
	@:noCompletion public var id:GlUInt = 0;

	public var width:Int;
	public var height:Int;

	public var pixels:RawPointer<UInt8>;
	public var transparent:Bool;

    public function new(width:Int, height:Int, ?color:Color = 0xFFFFFFFF, ?transparent:Bool = true) {
        this.width = width;
        this.height = height;
        this.transparent = transparent;
    
        final pixelCount:Int = width * height * 4;
        pixels = untyped __cpp__("new unsigned char[{0}]", pixelCount);
    
        if (color == 0xFFFFFFFF) {
            untyped __cpp__("memset({0}, 255, {1})", pixels, pixelCount);
        } else if (color == 0x00000000) { 
            untyped __cpp__("memset({0}, 0, {1})", pixels, pixelCount);
        } else {
            final colorData:Array<Int> = color;
            for (i in 0...width * height) {
                final offset:Int = i * 4;
                untyped __cpp__("
                    {0}[{1}] = {2};
                    {0}[{3}] = {4};
                    {0}[{5}] = {6};
                    {0}[{7}] = {8};
                ", pixels, offset, colorData[0], offset + 1, colorData[1], 
                    offset + 2, colorData[2], offset + 3, colorData[3]);
            }
        }
    
        setupTexture();
    }
    
    private function setupTexture():Void {
        final p:RawPointer<UInt8> = pixels;
    
        Glad.genTextures(1, Pointer.addressOf(id));
        activate();
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_MIN_FILTER, Glad.LINEAR);
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_MAG_FILTER, Glad.LINEAR);
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_WRAP_S, Glad.CLAMP_TO_EDGE);
        Glad.texParameteri(Glad.TEXTURE_2D, Glad.TEXTURE_WRAP_T, Glad.CLAMP_TO_EDGE);
    
        Glad.texImage2D(Glad.TEXTURE_2D, 0, transparent ? Glad.RGBA : Glad.RGB, 
                       width, height, 0, transparent ? Glad.RGBA : Glad.RGB, 
                       Glad.UNSIGNED_BYTE, p);
    }

	public function getPixel(x:Int, y:Int):Color {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			return Color.TRANSPARENT;
		}

		final invertedY:Int = height - 1 - y;
		final index:Int = (invertedY * width + x) * 4;
		final r:UInt8 = untyped __cpp__("{0}[{1}]", pixels, index);
		final g:UInt8 = untyped __cpp__("{0}[{1}]", pixels, index + 1);
		final b:UInt8 = untyped __cpp__("{0}[{1}]", pixels, index + 2);
		final a:UInt8 = untyped __cpp__("{0}[{1}]", pixels, index + 3);

		return Color.fromRGB(r, g, b, a);
	}

	public function setPixel(x:Int, y:Int, color:Color):Void {
		if (x < 0 || x >= width || y < 0 || y >= height) {
			return;
		}

		final colorData:Array<Int> = color;
		final invertedY:Int = height - 1 - y;
		final index:Int = (invertedY * width + x) * 4;

		untyped __cpp__("
			{0}[{1}] = {2};
			{0}[{3}] = {4};
			{0}[{5}] = {6};
			{0}[{7}] = {8};
		", pixels, index, colorData[0], index
			+ 1, colorData[1],
			index
			+ 2, colorData[2], index
			+ 3, colorData[3]);

		updateTexture();
	}

    public function fillRect(x:Int, y:Int, width:Int, height:Int, color:Color):Void {
        if (width <= 0 || height <= 0) return;
    
        final startX:Int = x < 0 ? 0 : x;
        final startY:Int = y < 0 ? 0 : y;
        final endX:Int = (x + width) > this.width ? this.width : (x + width);
        final endY:Int = (y + height) > this.height ? this.height : (y + height);
    
        final actualWidth:Int = endX - startX;
        final actualHeight:Int = endY - startY;
    
        if (actualWidth <= 0 || actualHeight <= 0) return;
    
        final colorData:Array<Int> = color;
    
        final rowBuffer:RawPointer<UInt8> = untyped __cpp__("new unsigned char[{0}]", actualWidth * 4);
        for (i in 0...actualWidth) {
            final offset:Int = i * 4;
            untyped __cpp__("
                {0}[{1}] = {2};
                {0}[{3}] = {4};
                {0}[{5}] = {6};
                {0}[{7}] = {8};
            ", rowBuffer, offset, colorData[0], offset + 1, colorData[1], 
                offset + 2, colorData[2], offset + 3, colorData[3]);
        }
    
        for (py in startY...endY) {
            final invertedY:Int = this.height - 1 - py;
            final destStartIndex:Int = (invertedY * this.width + startX) * 4;
            
            untyped __cpp__("
                memcpy({0} + {1}, {2}, {3} * 4);
            ", pixels, destStartIndex, rowBuffer, actualWidth);
        }
    
        untyped __cpp__("delete[] {0}", rowBuffer);
        updateTexture();
    }

    public function copyPixels(source:BitmapData, destX:Int = 0, destY:Int = 0, sourceRect:Rectangle = null):Void {
        if (source == null) return;
    
        var srcX:Int = 0;
        var srcY:Int = 0;
        var copyWidth:Int = source.width;
        var copyHeight:Int = source.height;
    
        if (sourceRect != null) {
            srcX = Std.int(sourceRect.x);
            srcY = Std.int(sourceRect.y);
            copyWidth = Std.int(sourceRect.width);
            copyHeight = Std.int(sourceRect.height);
    
            if (srcX < 0) {
                copyWidth += srcX;
                srcX = 0;
            }
            if (srcY < 0) {
                copyHeight += srcY;
                srcY = 0;
            }
            if (srcX + copyWidth > source.width) {
                copyWidth = source.width - srcX;
            }
            if (srcY + copyHeight > source.height) {
                copyHeight = source.height - srcY;
            }
        }
    
        destX = destX < 0 ? 0 : destX;
        destY = destY < 0 ? 0 : destY;
    
        final actualWidth:Int = Std.int(Math.min(copyWidth, width - destX));
        final actualHeight:Int = Std.int(Math.min(copyHeight, height - destY));
    
        if (actualWidth <= 0 || actualHeight <= 0) return;
    
        for (row in 0...actualHeight) {
            final sourceY:Int = srcY + row;
            final destY:Int = destY + row;
            
            final sourceInvertedY:Int = source.height - 1 - sourceY;
            final destInvertedY:Int = height - 1 - destY;
            
            final sourceStartIndex:Int = (sourceInvertedY * source.width + srcX) * 4;
            final destStartIndex:Int = (destInvertedY * width + destX) * 4;
            
            untyped __cpp__("
                memcpy({0} + {1}, {2} + {3}, {4} * 4);
            ", pixels, destStartIndex, source.pixels, sourceStartIndex, actualWidth);
        }
    
        updateTexture();
    }

	public function clear(color:Color = 0x00000000):Void {
		final colorData:Array<Int> = color;
		final pixelCount:Int = width * height;

		for (i in 0...pixelCount) {
			final offset:Int = i * 4;
			untyped __cpp__("
                {0}[{1}] = {2};
                {0}[{3}] = {4};
                {0}[{5}] = {6};
                {0}[{7}] = {8};
            ", pixels, offset, colorData[0], offset
				+ 1,
				colorData[1], offset
				+ 2, colorData[2], offset
				+ 3, colorData[3]);
		}

		updateTexture();
	}

	public function updateTexture():Void {
		activate();
		final p:RawPointer<UInt8> = pixels;
		Glad.texSubImage2D(Glad.TEXTURE_2D, 0, 0, 0, width, height, transparent ? Glad.RGBA : Glad.RGB, Glad.UNSIGNED_BYTE, p);
	}

	public static function fromPath(path:String):BitmapData {
		Image.setFlipVerticallyOnLoad(1);
		var width:Int = 0;
		var height:Int = 0;
		var channels:Int = 0;

		var data:Star<UChar> = Image.load(path, Pointer.addressOf(width), Pointer.addressOf(height), Pointer.addressOf(channels), 0);

		var b:BitmapData = new BitmapData(width, height, Color.TRANSPARENT);

		final pixelCount:Int = width * height * 4;
		for (i in 0...pixelCount) {
			untyped __cpp__("{0}[{1}] = {2}[{1}]", b.pixels, i, data);
		}

		b.updateTexture();
		b.deactivate();

		Image.freeImage(data);

		return b;
	}

	public function activate():Void {
		Glad.bindTexture(Glad.TEXTURE_2D, id);
	}

	public function deactivate():Void {
		Glad.bindTexture(Glad.TEXTURE_2D, 0);
	}

	public function destroy():Void {
		Glad.deleteTextures(1, Pointer.addressOf(id));
		untyped __cpp__("delete[] {0}", pixels);
	}

	public function getPixelArray():Array<UInt8> {
		final result:Array<UInt8> = [];
		final pixelCount:Int = width * height * 4;

		for (i in 0...pixelCount) {
			final value:UInt8 = untyped __cpp__("{0}[{1}]", pixels, i);
			result.push(value);
		}

		return result;
	}

	public function setPixelArray(data:Array<UInt8>):Void {
		if (data.length != width * height * 4) {
			throw "El array de píxeles debe tener el tamaño correcto";
		}

		for (i in 0...data.length) {
			untyped __cpp__("{0}[{1}] = {2}", pixels, i, data[i]);
		}

		updateTexture();
	}
}
