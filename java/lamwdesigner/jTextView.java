package com.example.appdemo1;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.graphics.Typeface;
import android.util.TypedValue;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewGroup.MarginLayoutParams;
import android.widget.RelativeLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import android.view.Gravity;
import android.widget.TextView;


public class jTextView extends TextView {
    //Java-Pascal Interface
    private long             PasObj   = 0;      // Pascal Obj
    private Controls        controls = null;   // Control Class for Event
    //
    private ViewGroup       parent   = null;   // parent view
    private ViewGroup.MarginLayoutParams lparams = null;              // layout XYWH
    private OnClickListener onClickListener;   // event
    private Boolean         enabled  = true;   //

    //by jmpessoa
    private int lparamsAnchorRule[] = new int[30];
    int countAnchorRule = 0;

    private int lparamsParentRule[] = new int[30];
    int countParentRule = 0;

    int lparamH = android.view.ViewGroup.LayoutParams.WRAP_CONTENT;
    int lparamW = android.view.ViewGroup.LayoutParams.MATCH_PARENT;
    int marginLeft = 5;
    int marginTop = 5;
    int marginRight = 5;
    int marginBottom = 5;

    float mTextSize = 0; //default
    int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP; //default

    private ClipboardManager mClipBoard = null;
    private ClipData mClipData = null;

    //Constructor
    public  jTextView(android.content.Context context,
                      Controls ctrls,long pasobj ) {
        super(context);

        //Connect Pascal I/F
        PasObj   = pasobj;
        controls = ctrls;

        //Init Class
        mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

        //Init Event
        onClickListener = new OnClickListener() {
            public  void onClick(View view) {
                if (enabled) {
                    controls.pOnClick(PasObj,Const.Click_Default);
                }
            };
        };
        setOnClickListener(onClickListener);

        lparams = new ViewGroup.MarginLayoutParams(lparamW, lparamH);     // W,H
        lparams.setMargins(marginLeft,marginTop,marginRight,marginBottom); // L,T,R,B
    }

    //by jmpessoa
    public void setLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
        marginLeft = _left;
        marginTop = _top;
        marginRight = _right;
        marginBottom = _bottom;
        lparamH = _h;
        lparamW = _w;
    }

    //by jmpessoa
    public void setLayoutAll(int idAnchor) {
        lparams.width  = lparamW; //matchParent;
        lparams.height = lparamH; //wrapContent;
        lparams.setMargins(marginLeft, marginTop,marginRight,marginBottom);

        if (lparams instanceof RelativeLayout.LayoutParams) {
            if (idAnchor > 0) {
                for (int i=0; i < countAnchorRule; i++) {
                    ((RelativeLayout.LayoutParams)lparams).addRule(lparamsAnchorRule[i], idAnchor);
                }
            }
            for (int j=0; j < countParentRule; j++) {
                ((RelativeLayout.LayoutParams)lparams).addRule(lparamsParentRule[j]);
            }
        }
        if (lparams instanceof FrameLayout.LayoutParams) {
            ((FrameLayout.LayoutParams)lparams).gravity = lgravity;
        }
        if (lparams instanceof LinearLayout.LayoutParams) {
            ((LinearLayout.LayoutParams)lparams).weight = lweight;
        }
        //
        this.setLayoutParams(lparams);
    }

    public void clearLayoutAll() {
        if (lparams instanceof RelativeLayout.LayoutParams) {
            for (int i=0; i < countAnchorRule; i++) {
                ((RelativeLayout.LayoutParams)lparams).removeRule(lparamsAnchorRule[i]);
            }
            for (int j=0; j < countParentRule; j++) {
                ((RelativeLayout.LayoutParams)lparams).removeRule(lparamsParentRule[j]);
            }
        }
        countAnchorRule = 0;
        countParentRule = 0;
    }

    //by jmpessoa
    public void setLParamWidth(int _w) {
        lparamW = _w;
    }

    //by jmpessoa
    public void setLParamHeight(int _h) {
        lparamH = _h;
    }

    public void setLGravity(int _g) {
        lgravity = _g;
    }

    public void setLWeight(float _w) {
        lweight = _w;
    }

    //by jmpessoa
    public void addLParamsAnchorRule(int rule) {
        lparamsAnchorRule[countAnchorRule] = rule;
        countAnchorRule = countAnchorRule + 1;
    }

    //by jmpessoa
    public void addLParamsParentRule(int rule) {
        lparamsParentRule[countParentRule] = rule;
        countParentRule = countParentRule + 1;
    }

    //LORDMAN 2013-08-13
    public  void setTextAlignment( int align ) {
        switch ( align ) {
            case 0 : { setGravity( Gravity.LEFT              ); }; break;
            case 1 : { setGravity( Gravity.RIGHT             ); }; break;
            case 2 : { setGravity( Gravity.TOP               ); }; break;
            case 3 : { setGravity( Gravity.BOTTOM            ); }; break;
            case 4 : { setGravity( Gravity.CENTER            ); }; break;
            case 5 : { setGravity( Gravity.CENTER_HORIZONTAL ); }; break;
            case 6 : { setGravity( Gravity.CENTER_VERTICAL   ); }; break;
            default : { setGravity( Gravity.LEFT              ); }; break;
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

    public void setParent3( android.view.ViewGroup viewgroup ) {  //deprec...
        if (parent != null) { parent.removeView(this); }
        parent = viewgroup;
        viewgroup.addView(this, lparams);
    }

    private static MarginLayoutParams newLayoutParams(ViewGroup aparent, ViewGroup.MarginLayoutParams baseparams) {
        if (aparent instanceof FrameLayout) {
            return new FrameLayout.LayoutParams(baseparams);
        } else if (aparent instanceof RelativeLayout) {
            return new RelativeLayout.LayoutParams(baseparams);
        } else if (aparent instanceof LinearLayout) {
            return new LinearLayout.LayoutParams(baseparams);
        } else if (aparent == null) {
            throw new NullPointerException("Parent is null");
        } else {
            throw new IllegalArgumentException("Parent is neither FrameLayout or RelativeLayout or LinearLayout: "
                    + aparent.getClass().getName());
        }
    }

    public void setParent( android.view.ViewGroup _viewgroup ) {
        if (parent != null) { parent.removeView(this); }
        parent = _viewgroup;
        parent.addView(this,newLayoutParams(parent,(ViewGroup.MarginLayoutParams)lparams));
        lparams = null;
        lparams = (ViewGroup.MarginLayoutParams)this.getLayoutParams();
    }

    public  void setEnabled( boolean value ) {
        enabled = value;
    }

    //Free object except Self, Pascal Code Free the class.
    public  void Free() {
        if (parent != null) { parent.removeView(this); }
        setText("");
        lparams = null;
        setOnClickListener(null);
    }

/*
* 	this.setTypeface(null, Typeface.BOLD_ITALIC);
	this.setTypeface(null, Typeface.BOLD);
  this.setTypeface(null, Typeface.ITALIC);
  this.setTypeface(null, Typeface.NORMAL);
*/

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

}