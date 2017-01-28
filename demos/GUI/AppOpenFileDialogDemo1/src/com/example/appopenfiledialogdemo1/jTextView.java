package com.example.appopenfiledialogdemo1;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.Gravity;
import android.widget.TextView;


public class jTextView extends TextView {
    //Java-Pascal Interface
    private Controls        controls = null;   // Control Class for Event
    private jCommons LAMWCommon;
        
    private OnClickListener onClickListener;   
    private Boolean         enabled  = true;  

    float mTextSize = 0; 
    int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; 

    private ClipboardManager mClipBoard = null;
    private ClipData mClipData = null;

    public  jTextView(android.content.Context context,
                      Controls ctrls,long pasobj ) {
        super(context);
        controls = ctrls;
		LAMWCommon = new jCommons(this,context,pasobj);
        
        mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

        onClickListener = new OnClickListener() {
            public  void onClick(View view) {
                if (enabled) {
                    controls.pOnClick(LAMWCommon.getPasObj(),Const.Click_Default);
                }
            };
        };
        setOnClickListener(onClickListener);

    }

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		this.setOnKeyListener(null);
		this.setText("");
		LAMWCommon.free();
	}

	public long GetPasObj() {
		return LAMWCommon.getPasObj();
	}

	public  void SetViewParent(ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}
	
	public ViewGroup GetParent() {
		return LAMWCommon.getParent();
	}
	
	public void RemoveFromViewParent() {
		LAMWCommon.removeFromViewParent();
	}

	public void SetLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
		
	public void SetLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void SetLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
	}
    
	public int GetLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int GetLParamWidth() {				
		return LAMWCommon.getLParamWidth();					
	}  

	public void SetLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void SetLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public void AddLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}
	
	public void AddLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void SetLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}
	
	public void ClearLayoutAll() {		
		LAMWCommon.clearLayoutAll();
	}

	public View GetView() {
	   return this;
    }

    //LORDMAN 2013-08-13
    public  void SetTextAlignment( int align ) {
        switch ( align ) {
 //[ifdef_api14up]
            case 0 : { setGravity( Gravity.START             ); }; break;
            case 1 : { setGravity( Gravity.END               ); }; break;
 //[endif_api14up]
 /* //[endif_api14up]
            case 0 : { setGravity( Gravity.LEFT              ); }; break;
            case 1 : { setGravity( Gravity.RIGHT             ); }; break;
 //[ifdef_api14up] */
            case 2 : { setGravity( Gravity.TOP               ); }; break;
            case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
            case 4 : { setGravity( Gravity.CENTER            ); }; break;
            case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
            case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
 //[ifdef_api14up]
            default : { setGravity( Gravity.START            ); }; break;
 //[endif_api14up]
 /* //[endif_api14up]
            default : { setGravity( Gravity.LEFT             ); }; break;
 //[ifdef_api14up] */
        };
    }

    public void CopyToClipboard() {
        mClipData = ClipData.newPlainText("text", this.getText().toString());
        mClipBoard.setPrimaryClip(mClipData);
    }

    public void PasteFromClipboard() {
        ClipData cdata = mClipBoard.getPrimaryClip();
        ClipData.Item item = cdata.getItemAt(0);
        this.setText(item.getText().toString());
    }

    public  void SetEnabled( boolean value ) {
        enabled = value;
    }

    public void SetTextTypeFace(int _typeface) {
        this.setTypeface(null, _typeface);
    }

    public void Append(String _txt) {
        this.append( _txt);
    }

    public void AppendLn(String _txt) {
        this.append( _txt+ "\n");
    }

    public void AppendTab() {
        this.append("\t");
    }

    public void SetFontAndTextTypeFace(int fontFace, int fontStyle) {
        Typeface t = null;
        switch (fontFace) {
            case 0: t = Typeface.DEFAULT; break;
            case 1: t = Typeface.SANS_SERIF; break;
            case 2: t = Typeface.SERIF; break;
            case 3: t = Typeface.MONOSPACE; break;
        }
        this.setTypeface(t, fontStyle);
    }

    public void SetTextSize(float size) {
        mTextSize = size;
        String t = this.getText().toString();
        this.setTextSize(mTextSizeTypedValue, mTextSize);
        this.setText(t);
    }

    //TTextSizeTypedValue =(tsDefault, tsPixels, tsDIP, tsInches, tsMillimeters, tsPoints, tsScaledPixel);
    public void SetFontSizeUnit(int _unit) {
        switch (_unit) {
            case 0: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
            case 1: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PX; break; //default
            case 2: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_DIP; break; //default
            case 3: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_IN; break; //default
            case 4: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_MM; break; //default
            case 5: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_PT; break; //default
            case 6: mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; break; //default
        }
        String t = this.getText().toString();
        this.setTextSize(mTextSizeTypedValue, mTextSize);
        this.setText(t);
    }
	
	@Override
	protected void dispatchDraw(Canvas canvas) {	 	
	    //DO YOUR DRAWING ON UNDER THIS VIEWS CHILDREN
		controls.pOnBeforeDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);  //event handle by pascal side		
	    super.dispatchDraw(canvas);	    
	    //DO YOUR DRAWING ON TOP OF THIS VIEWS CHILDREN
	    controls.pOnAfterDispatchDraw(LAMWCommon.getPasObj(), canvas, 1);	 //event handle by pascal side    
	}

}
