package org.lamw.apptablelayoutdemo1;
import android.content.Context;
import android.graphics.Color;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TableLayout;
import android.widget.TableRow;
import android.widget.TextView;

import java.util.regex.Pattern;

/*Draft java code by "Lazarus Android Module Wizard" [4/15/2022 17:52:44]*/
/*https://github.com/jmpessoa/lazandroidmodulewizard*/
/*jVisualControl LAMW template*/
  
public class jTableLayout extends TableLayout /*dummy*/ { //please, fix what GUI object will be extended!

    private long pascalObj = 0;        // Pascal Object
    private Controls controls  = null; //Java/Pascal [events] Interface ...
    private jCommons LAMWCommon;
    private Context context = null;

    private OnClickListener onClickListener;   // click event
    private Boolean enabled  = true;           // click-touch enabled!

    int mRowTextColor = Color.BLACK;
    String mTextInnerDelimiter;
    boolean mStretchAllColumns;

    //GUIDELINE: please, preferentially, init all yours params names with "_", ex: int _flag, String _hello ...
    public jTableLayout(Controls _ctrls, long _Self) { //Add more others news "_xxx" params if needed!

       super(_ctrls.activity);
       context   = _ctrls.activity;
       pascalObj = _Self;
       controls  = _ctrls;

       LAMWCommon = new jCommons(this,context,pascalObj);

       onClickListener = new OnClickListener(){
       /*.*/public void onClick(View view){     // *.* is a mask to future parse...;
               if (enabled) {
                  controls.pOnClickGeneric(pascalObj); //JNI event onClick!
               }
            };
       };
       setOnClickListener(onClickListener);

        mStretchAllColumns = true;
        mTextInnerDelimiter = "&";
        this.setStretchAllColumns(true);

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
    public void SetId(int _id) {
       this.setId(_id);
    }

    public void AddTextRow(String _delimitedTextRow, String _delimiter, int _color) {
        String[] texts = _delimitedTextRow.split(Pattern.quote(_delimiter));
        int count =  texts.length;

        TableRow row = new TableRow(controls.activity);  /* Create the Table’s Row */
        //row.setLayoutParams(new ViewGroup.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.WRAP_CONTENT));

        for(int i=0; i < count; i++) {
            TextView txt = new TextView(controls.activity); /* Create new Text view here */

            if (!texts[i].contains(mTextInnerDelimiter)) {
                txt.setText(texts[i]);
            } else {
                String[] contents = texts[i].split(Pattern.quote(mTextInnerDelimiter));
                int n = contents.length;
                String s = contents[0];
                for(int j=1; j < n; j++) {
                    s = s + "\n" + contents[j];
                }
                txt.setText(s);
            }

            txt.setTextColor(mRowTextColor);
            txt.setPadding(5,5,5,5);
            row.addView(txt);
            //Log.i("LAMW", texts[i]);
        }
        row.setBackgroundColor(_color);
        row.setPadding(10,10,10,10);
        this.addView(row);
    }

    public void SetRowTextColor(int _textColor) {
        mRowTextColor = _textColor;
    }

    public void SeInnerTextContentDelimiter(String _delimiter) {
        mTextInnerDelimiter = _delimiter;
    }

    public void SetStretchAllColumns(boolean _value) {
        mStretchAllColumns = _value;
    }

    public void SetColumnStretchable(int _index) {
        this.setColumnStretchable(_index,true);
    }

    public void SetShrinkAllColumns(boolean _value) {
         this.setShrinkAllColumns(_value);
    }

    public void SetColumnShrinkable(int _index) {
        this.setColumnShrinkable(_index, true);
    }
 
}
