

//import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Matrix;
import android.graphics.Paint;
import android.graphics.Shader;
import android.graphics.PorterDuff;
//import android.graphics.PorterDuffXfermode;
import android.graphics.BitmapShader;
import android.graphics.ComposeShader;
import android.graphics.LinearGradient;
import android.graphics.RadialGradient;
import android.graphics.SweepGradient;
//import android.os.Bundle;
//import android.view.View;

class Coords {
    public float x;
    public float y;
	public float sx;
	public float sy;
	public float angle;

    Coords(float x, float y, float sx, float sy, float angle) {
        this.x = x;
        this.y = y;
		this.sx = sx;
        this.sy = sy;
		this.angle = angle;
    }
}

public class jPaintShader {
    // Java-Pascal Interface
    private long     pascalObj   = 0;    // Pascal Object
    private Controls controls    = null; // Java/Pascal [events] Interface ...
    private Context  context     = null;
	//
	private Matrix   matrix      = null;
	private Paint    paint       = null;
	private Coords[] coords      = {null, null, null, null, null, null};
	private Shader[] shaders     = {null, null, null, null, null, null};
	private int      shaderIndex = -1;
	private int      MAX_SHADERS = 50;

	// constructor
	public jPaintShader(Controls _Ctrls, long _Self, java.lang.Object _Paint) {
		context   = _Ctrls.activity;
		controls  = _Ctrls;
		pascalObj = _Self;
		paint     = (Paint)_Paint;
		matrix    = new Matrix();
	}

	// destructor
	public void jFree() {
		// free local objects...
		Clear();
		coords = null;
		shaders = null;
		matrix = null;
    }
	
	public void SetPaint(/*java.lang.Object*/Paint _Paint) {
		paint = _Paint;
	}	
	
	public int GetColor() {
		return paint.getColor();
	}
	
	private Shader.TileMode SetTileMode(byte _Mode) {	
		Shader.TileMode tm = Shader.TileMode.CLAMP;
		switch (_Mode) {
            case 0: { tm = Shader.TileMode.CLAMP ; break; }
            case 1: { tm = Shader.TileMode.MIRROR; break; }
            case 2: { tm = Shader.TileMode.REPEAT; break; }
		}
		return tm;
	}
	
	// https://developer.android.com/reference/android/graphics/PorterDuff.Mode.html
	private PorterDuff.Mode SetPorterDuffMode(byte _Mode) {
		PorterDuff.Mode pdm = PorterDuff.Mode.SRC_OVER;
		switch (_Mode) {
            case  0: { pdm = PorterDuff.Mode.ADD     ; break; }
            case  1: { pdm = PorterDuff.Mode.CLEAR   ; break; }
            case  2: { pdm = PorterDuff.Mode.DARKEN  ; break; }
			case  3: { pdm = PorterDuff.Mode.DST     ; break; }
            case  4: { pdm = PorterDuff.Mode.DST_ATOP; break; }
            case  5: { pdm = PorterDuff.Mode.DST_IN  ; break; }
			case  6: { pdm = PorterDuff.Mode.DST_OUT ; break; }
            case  7: { pdm = PorterDuff.Mode.DST_OVER; break; }
            case  8: { pdm = PorterDuff.Mode.LIGHTEN ; break; }
			case  9: { pdm = PorterDuff.Mode.MULTIPLY; break; }
            case 10: { pdm = PorterDuff.Mode.OVERLAY ; break; }
            case 11: { pdm = PorterDuff.Mode.SCREEN  ; break; }
			case 12: { pdm = PorterDuff.Mode.SRC     ; break; }
			case 13: { pdm = PorterDuff.Mode.SRC_ATOP; break; }
            case 14: { pdm = PorterDuff.Mode.SRC_IN  ; break; }
            case 15: { pdm = PorterDuff.Mode.SRC_OUT ; break; }
			case 16: { pdm = PorterDuff.Mode.SRC_OVER; break; }
            case 17: { pdm = PorterDuff.Mode.XOR     ; break; }
		}
		return pdm;
	}	
	
	private int CheckBounds(int _value) {
		int index = 0;
		
		if (_value < 0) {
			shaderIndex++;
			index = shaderIndex;
			if (index > shaders.length -1) {
				shaderIndex = -1;
				index = 0;
			}
		} else {
			index = _value;
			if (index > shaders.length -1) 
				index = 0;
		}
		return index;
	}	
	
	public void SetCount(int _value) {
		if (_value < 1) { 
			coords = new Coords[6];
			shaders = new Shader[6];
			Clear();
			return;
		}	
		if (_value > MAX_SHADERS) { 
			coords = new Coords[MAX_SHADERS];
			shaders = new Shader[MAX_SHADERS];		
		} else {
			coords = new Coords[_value];
			shaders = new Shader[_value];
		}	
		Clear();
	}	
	
	public void SetIndex(int _value) {
		if ((_value > -1) && (_value < shaders.length)) 
			shaderIndex = _value - 1;
	}	
	
	public void Clear() {
		int Len = shaders.length;
		for (int i = 0; i < Len; i++) {
			coords[i] = null;
			shaders[i] = null;
		}
	}	
	
	public void Bind(int _ID) {
		int Len = shaders.length;
		if ((_ID < 0) || (Len < 1)) {
			//paint.setDither(false);
			paint.setShader(null);
			return;
		}
		
		if (_ID < Len) {
			//paint.setDither(true);
			paint.setShader(shaders[_ID]);
		}				
	}
	
	public void Combine(int _shdrA, int _shdrB, byte _Mode, int _dstID) {
		// need disable hardware acceleration to work correctly!
		// NOTE: need VERSION.SDK_INT >= 11
		int shdrA = CheckBounds(_shdrA);
		int shdrB = CheckBounds(_shdrB);
		if ((shdrA != shdrB) && (shaders[shdrA] != null) && (shaders[shdrB] != null)) {
			int Index = CheckBounds(_dstID);
			coords[Index] = coords[shdrB];
			shaders[Index] = new ComposeShader(shaders[shdrA], shaders[shdrB], SetPorterDuffMode(_Mode));
		}	
	}	
	
	public int NewBitmapShader(Bitmap _Bitmap, byte _tileX, byte _tileY, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(0, 0, 1, 1, 0);
		shaders[Index] = new BitmapShader(_Bitmap, SetTileMode(_tileX), SetTileMode(_tileY));
		
		return Index;
	}	
	
	public int NewBitmapShader(Bitmap _Bitmap, byte _tileX, byte _tileY, float _scaleX, float _scaleY, float _Rotate, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(0, 0, _scaleX, _scaleY, _Rotate);
		shaders[Index] = new BitmapShader(_Bitmap, SetTileMode(_tileX), SetTileMode(_tileY));
		if ((_Rotate != 0) || (_scaleX != 0) || (_scaleY != 0)) {
			matrix.reset();
			matrix.postScale(_scaleX, _scaleY);
			matrix.postRotate(_Rotate);
			shaders[Index].setLocalMatrix(matrix);
		}	
		
		return Index;
	}
	
	public int NewLinearGradient(float _X0, float _Y0, float _X1, float _Y1, int _Color0, int _Color1, byte _tileMode, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(0, 0, 1, 1, 0);
		shaders[Index] = new LinearGradient(_X0, _Y0, _X1, _Y1, _Color0, _Color1, SetTileMode(_tileMode));
		
		return Index;
	}	
	
	public int NewLinearGradient(float _X0, float _Y0, float _X1, float _Y1, int[] _Colors, float[] _Positions, byte _tileMode, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(0, 0, 1, 1, 0);
		if (_Colors.length != _Positions.length)
			shaders[Index] = new LinearGradient(_X0, _Y0, _X1, _Y1, _Colors, null, SetTileMode(_tileMode));
		else
			shaders[Index] = new LinearGradient(_X0, _Y0, _X1, _Y1, _Colors, _Positions, SetTileMode(_tileMode));
		
		return Index;
	}	
	
	public int NewLinearGradient(float _X, float _Y, float _Wh, float _Ht, float _Rotate, int _Color0, int _Color1, byte _tileMode, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(_X, _Y, 1, 1, _Rotate);
		shaders[Index] = new LinearGradient(_X, _Y, _X + _Wh, _Y + _Ht, _Color0, _Color1, SetTileMode(_tileMode));
		if (_Rotate != 0) {
			matrix.reset();
			matrix.postRotate(_Rotate);
			shaders[Index].setLocalMatrix(matrix);
		}	
		
		return Index;
	}	
	
	public int NewLinearGradient(float _X, float _Y, float _Wh, float _Ht, float _Rotate, int[] _Colors, float[] _Positions, byte _tileMode, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(_X, _Y, 1, 1, _Rotate);
		if (_Colors.length != _Positions.length)
			shaders[Index] = new LinearGradient(_X, _Y, _X + _Wh, _Y + _Ht, _Colors, null, SetTileMode(_tileMode));
		else
			shaders[Index] = new LinearGradient(_X, _Y, _X + _Wh, _Y + _Ht, _Colors, _Positions, SetTileMode(_tileMode));
		if (_Rotate != 0) {
			matrix.reset();
			matrix.postRotate(_Rotate);
			shaders[Index].setLocalMatrix(matrix);
		}	
		
		return Index;
	}	
	
	public int NewRadialGradient(float _centerX, float _centerY, float _Radius, int _centerColor, int _edgeColor, byte _tileMode, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(_centerX, _centerY, 1, 1, 0);
		shaders[Index] = new RadialGradient(_centerX, _centerY, _Radius, _centerColor, _edgeColor, SetTileMode(_tileMode));
		
		return Index;
	}	
	
	public int NewRadialGradient(float _centerX, float _centerY, float _Radius, int[] _Colors, float[] _Stops, byte _tileMode, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(_centerX, _centerY, 1, 1, 0);
		if (_Colors.length != _Stops.length)
			shaders[Index] = new RadialGradient(_centerX, _centerY, _Radius, _Colors, null, SetTileMode(_tileMode));
		else
			shaders[Index] = new RadialGradient(_centerX, _centerY, _Radius, _Colors, _Stops, SetTileMode(_tileMode));
		
		return Index;
	}	
	
	public int NewSweepGradient(float _centerX, float _centerY, int _Color0, int _Color1, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(_centerX, _centerY, 1, 1, 0);
		shaders[Index] = new SweepGradient(_centerX, _centerY, _Color0, _Color1);
		
		return Index;
	}
	
	public int NewSweepGradient(float _centerX, float _centerY, int[] _Colors, float[] _Positions, int _ID) {
		
		int Index = CheckBounds(_ID);
		coords[Index] = new Coords(_centerX, _centerY, 1, 1, 0);
		//int[] color = {0xFFFF0707, 0xFFFF6A07, 0xFFFFD507, 0xFFB8FF07, 0xFF51FF07, 0xFF07FF24, 0xFF07FF8F,
		               //0xFF07FFFF, 0xFF0797FF, 0xFF072CFF, 0xFF4907FF, 0xFFB007FF, 0xFFFF07DE, 0xFFFF0772};
		//float[] pos = {0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f, 0.071f};
		if (_Colors.length != _Positions.length)
			shaders[Index] = new SweepGradient(_centerX, _centerY, _Colors, null);
		else
			shaders[Index] = new SweepGradient(_centerX, _centerY, _Colors, _Positions);
		
		return Index;
	}
	
	public void SetIdentity(int _ID) {
		int Index = CheckBounds(_ID);
		
		matrix.reset();
		shaders[Index].setLocalMatrix(matrix);
	}	
	
	public void SetMatrix(float _X, float _Y, float _scaleX, float _scaleY, float _Rotate, int _ID) {
		int Index = CheckBounds(_ID);
		
		matrix.reset();
		matrix.postScale(_scaleX, _scaleY);
		matrix.postRotate(_Rotate);
		matrix.postTranslate(_X, _Y);
		shaders[Index].setLocalMatrix(matrix);
	}
	
	public void SetZeroCoords(int _ID) {
		int Index = CheckBounds(_ID);
		SetMatrix(-coords[Index].x, -coords[Index].y, coords[Index].sx, coords[Index].sy, coords[Index].angle, Index);
	}
	
	public void SetRotate(float _Degree, int _ID) {
		if (_Degree != 0) {
			int Index = CheckBounds(_ID);
			
			matrix.reset();
			shaders[Index].getLocalMatrix(matrix);
			matrix.postRotate(_Degree);
			shaders[Index].setLocalMatrix(matrix);
		}	
	}
	
	public void SetRotate(float _Degree, float _PointX, float _PointY, int _ID) {
		if (_Degree != 0) {
			int Index = CheckBounds(_ID);
			
			matrix.reset();
			shaders[Index].getLocalMatrix(matrix);
			matrix.postRotate(_Degree, _PointX, _PointY);
			shaders[Index].setLocalMatrix(matrix);
		}	
	}
	
	public void SetScale(float _X, float _Y, int _ID) {
		if ((_X != 0) && (_Y != 0)) {
			int Index = CheckBounds(_ID);
			
			matrix.reset();
			shaders[Index].getLocalMatrix(matrix);
			matrix.postScale(_X, _Y);
			shaders[Index].setLocalMatrix(matrix);
		}
	}	
	
	public void SetTranslate(float _X, float _Y, int _ID) {
		int Index = CheckBounds(_ID);
			
		matrix.reset();
		shaders[Index].getLocalMatrix(matrix);
		matrix.postTranslate(_X, _Y);
		shaders[Index].setLocalMatrix(matrix);	
	}
	
}
