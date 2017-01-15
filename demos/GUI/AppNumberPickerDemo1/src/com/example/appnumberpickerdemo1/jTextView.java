package com.example.appnumberpickerdemo1;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Canvas;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.view.View;
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

	public void setLeftTopRightBottomWidthHeight(int left, int top, int right, int bottom, int w, int h) {
		LAMWCommon.setLeftTopRightBottomWidthHeight(left,top,right,bottom,w,h);
	}
	
	public  void setParent( android.view.ViewGroup _viewgroup ) {
		LAMWCommon.setParent(_viewgroup);
	}

	//Free object except Self, Pascal Code Free the class.
	public  void Free() {
		setOnKeyListener(null);
		setText("");
		LAMWCommon.Free();
	}

	public void setLParamWidth(int w) {
		LAMWCommon.setLParamWidth(w);
	}

	public void setLParamHeight(int h) {
		LAMWCommon.setLParamHeight(h);
	}

	public void setLGravity(int _g) {
		LAMWCommon.setLGravity(_g);
	}

	public void setLWeight(float _w) {
		LAMWCommon.setLWeight(_w);
	}

	public void addLParamsAnchorRule(int rule) {
		LAMWCommon.addLParamsAnchorRule(rule);
	}
	
	public void addLParamsParentRule(int rule) {
		LAMWCommon.addLParamsParentRule(rule);
	}

	public void setLayoutAll(int idAnchor) {
		LAMWCommon.setLayoutAll(idAnchor);
	}
	
    //LORDMAN 2013-08-13
    public  void setTextAlignment( int align ) {
        switch ( align ) {
            case 0 : { setGravity( Gravity.START             ); }; break;
            case 1 : { setGravity( Gravity.END             ); }; break;
            case 2 : { setGravity( Gravity.TOP               ); }; break;
            case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
            case 4 : { setGravity( Gravity.CENTER            ); }; break;
            case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
            case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
            default : { setGravity( Gravity.START              ); }; break;
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

    public  void setEnabled( boolean value ) {
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

    public void setFontAndTextTypeFace(int fontFace, int fontStyle) {
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
    
	public int getLParamHeight() {
		return  LAMWCommon.getLParamHeight();
	}

	public int getLParamWidth() {				
		return LAMWCommon.getLParamWidth();					
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
