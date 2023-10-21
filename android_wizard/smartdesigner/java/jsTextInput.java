package org.lamw.appcompatdemo1;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.content.res.ColorStateList;

import android.graphics.Typeface;
import android.view.View;
import android.view.ViewGroup;
import android.text.InputType;
import com.google.android.material.textfield.TextInputLayout;
import android.util.TypedValue;
import com.google.android.material.textfield.TextInputEditText;
import android.graphics.PorterDuff;

import org.wedus.ftp.Controls;
import org.wedus.ftp.jCommons;
/*Draft java code by "Lazarus Android Module Wizard" [12/30/2017 3:44:48]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/


//https://blog.xamarin.com/add-beautiful-material-design-with-the-android-support-design-library/
//http://www.androidtutorialshub.com/android-material-design-floating-label-for-edittext-tutorial/
//https://www.journaldev.com/14748/android-textinputlayout-example

public class jsTextInput extends TextInputLayout /*dummy*/ { //please, fix what GUI object will be extended!

    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!

    TextInputEditText mTextInputEditText = null;

    int mTextSizeTypedValue = TypedValue.COMPLEX_UNIT_SP;

    private ClipboardManager mClipBoard = null;
    private ClipData mClipData = null;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jsTextInput(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

        super(_ctrls.activity);
        context   = _ctrls.activity;
        pascalObj = _Self;
        controls  = _ctrls;

        LAMWCommon = new jCommons(this,context,pascalObj);

        mTextInputEditText = new TextInputEditText(context);
        //mTextInputEditText.setHint("enter hint here...");

        LayoutParams  txtParam = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.WRAP_CONTENT); //w,h  //layText
        txtParam.leftMargin = 10;
        txtParam.rightMargin = 10;
        this.addView(mTextInputEditText, txtParam);

        //this.setEnabled(true);
        //this.setHintEnabled(false);
        this.setHintAnimationEnabled(true);
        //this.setHint("hello hint...");
        //this.getBackground().mutate().setColorFilter(getResources().getColor(android.R.color.holo_blue_bright), PorterDuff.Mode.SRC_ATOP);


        onClickListener = new OnClickListener(){
            /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
                if (enabled) {
                    controls.pOnClickGeneric(pascalObj); //JNI event onClick!
                }
            };
        };

        setOnClickListener(onClickListener);

        mClipBoard = (ClipboardManager) controls.activity.getSystemService(Context.CLIPBOARD_SERVICE);

    } //end constructor

    public void jFree() {
        //free local objects...
        setOnClickListener(null);
        LAMWCommon.free();
    }

    public void SetViewParent(ViewGroup _viewgroup) {
        LAMWCommon.setParent(_viewgroup);
    }

    public ViewGroup GetParent() {
        return LAMWCommon.getParent();
    }

    public void RemoveFromViewParent() {
        LAMWCommon.removeFromViewParent();
    }

    public View GetView() {
        return this;
    }

    public void SetLParamWidth(int _w) {
        LAMWCommon.setLParamWidth(_w);
    }

    public void SetLParamHeight(int _h) {
        LAMWCommon.setLParamHeight(_h);
    }

    public int GetLParamWidth() {
        return LAMWCommon.getLParamWidth();
    }

    public int GetLParamHeight() {
        return  LAMWCommon.getLParamHeight();
    }

    public void SetLGravity(int _g) {
        LAMWCommon.setLGravity(_g);
    }

    public void SetLWeight(float _w) {
        LAMWCommon.setLWeight(_w);
    }

    public void SetLeftTopRightBottomWidthHeight(int _left, int _top, int _right, int _bottom, int _w, int _h) {
        LAMWCommon.setLeftTopRightBottomWidthHeight(_left,_top,_right,_bottom,_w,_h);
    }

    public void AddLParamsAnchorRule(int _rule) {
        LAMWCommon.addLParamsAnchorRule(_rule);
    }

    public void AddLParamsParentRule(int _rule) {
        LAMWCommon.addLParamsParentRule(_rule);
    }

    public void SetLayoutAll(int _idAnchor) {
        LAMWCommon.setLayoutAll(_idAnchor);
    }

    public void ClearLayoutAll() {
        LAMWCommon.clearLayoutAll();
    }

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public void SetHint(String _hint) {
        this.setHint(_hint);
    }

    public void SetHintTextColor(int _color) {
        ColorStateList csl = ColorStateList.valueOf(_color);
        this.setHintTextColor(csl);
    }

    public void SetBackgroundTextColor(int _color) {
        mTextInputEditText.getBackground().mutate().setColorFilter(_color, PorterDuff.Mode.SRC_ATOP);
    }

    public void SetHighlightTextColor(int _color) {
        mTextInputEditText.setHighlightColor(_color);
    }

    public void SetTextSize(float _size) {
        String t = mTextInputEditText.getText().toString();
        mTextInputEditText.setTextSize(mTextSizeTypedValue, _size);
        mTextInputEditText.setText(t);
    }

    public void SetTextColor(int _color) {
        mTextInputEditText.setTextColor(_color);
    }

    public void CopyToClipboard() {
        mClipData = ClipData.newPlainText("text", mTextInputEditText.getText().toString());
        mClipBoard.setPrimaryClip(mClipData);
    }

    public void PasteFromClipboard() {
        ClipData cdata = mClipBoard.getPrimaryClip();
        ClipData.Item item = cdata.getItemAt(0);
        mTextInputEditText.setText(item.getText().toString());
    }

    public void SetText(String _text) {
        mTextInputEditText.setText(_text);
    }

    public String GetText() {
        return mTextInputEditText.getText().toString();
    }

    public void SetFontAndTextTypeFace(int fontFace, int fontStyle) {
        Typeface t = null;
        switch (fontFace) {
            case 0: t = Typeface.DEFAULT; break;
            case 1: t = Typeface.SANS_SERIF; break;
            case 2: t = Typeface.SERIF; break;
            case 3: t = Typeface.MONOSPACE; break;
        }
        mTextInputEditText.setTypeface(t, fontStyle);
    }

    //CURRENCY
    public  void SetInputTypeEx(String str) {
        if(str.equals("NUMBER")) {
            mTextInputEditText.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
        }
        else if(str.equals("NUMBERFLOAT")) {
            mTextInputEditText.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL|InputType.TYPE_NUMBER_FLAG_SIGNED);
        }
        else if(str.equals("NUMBERFLOATPOSITIVE")) {
            mTextInputEditText.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL);
        }
        else if(str.equals("CURRENCY")) {  		    //thanks to @renabor
            mTextInputEditText.setInputType(InputType.TYPE_CLASS_NUMBER|InputType.TYPE_NUMBER_FLAG_DECIMAL|InputType.TYPE_NUMBER_FLAG_SIGNED);
        }
        else if (str.equals("CAPCHARACTERS")) {
            mTextInputEditText.setInputType(android.text.InputType.TYPE_TEXT_FLAG_CAP_CHARACTERS);
        }
        else if (str.equals("TEXT")) {
            mTextInputEditText.setInputType(android.text.InputType.TYPE_CLASS_TEXT);
        }
        else if (str.equals("PHONE"))       {mTextInputEditText.setInputType(android.text.InputType.TYPE_CLASS_PHONE); }
        else if (str.equals("PASSNUMBER"))  {mTextInputEditText.setInputType(android.text.InputType.TYPE_CLASS_NUMBER);
            mTextInputEditText.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }
        else if (str.equals("PASSTEXT"))    {mTextInputEditText.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_VARIATION_PASSWORD);
            mTextInputEditText.setTransformationMethod(android.text.method.PasswordTransformationMethod.getInstance()); }

        else if (str.equals("TEXTMULTILINE")){
            mTextInputEditText.setInputType(android.text.InputType.TYPE_CLASS_TEXT|android.text.InputType.TYPE_TEXT_FLAG_MULTI_LINE);
        }
        else if (str.equals("NULL")){
            mTextInputEditText.setInputType(InputType.TYPE_NULL);
        }
        else {mTextInputEditText.setInputType(android.text.InputType.TYPE_CLASS_TEXT|InputType.TYPE_TEXT_FLAG_NO_SUGGESTIONS);};

    }

    //mTextInputEditText.setAllCaps(allCaps);
    // mTextInputEditText.setInputType(type);  InputType.TYPE_CLASS_NUMBER
    //--- senha
    // InputPassword.setInputType( InputType.TYPE_CLASS_TEXT | InputType.TYPE_TEXT_VARIATION_PASSWORD );
    //InputPassword.setTransformationMethod(PasswordTransformationMethod.getInstance());
    //---
    //decimal sinalizado
    //edt.setInputType(InputType.TYPE_NUMBER_FLAG_DECIMAL | InputType.TYPE_NUMBER_FLAG_SIGNED);

}
